use strict;
use warnings;

use Data::Dumper;
use Scalar::Util qw(blessed);

use Test::Most 'die', tests => 7;

use Interchange6::Schema;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;
use DateTime;
use DBICx::TestDatabase;

my ( $rset, %countries, %states, %zones, $data, $result );

my $dt = DateTime->now;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;
my $pop_states    = Interchange6::Schema::Populate::StateLocale->new(
    { generate_states_id => 1 } )->records;
my $pop_zones = Interchange6::Schema::Populate::Zone->new->records;
my $rsetzone  = $schema->resultset('Zone');

# populate Country, State and Zone

lives_ok( sub { $schema->populate( Country => $pop_countries ) },
    "populate countries" );

lives_ok( sub { $schema->populate( State => $pop_states ) },
    "populate states" );

lives_ok( sub { $schema->populate( Zone => $pop_zones ) }, "populate zones" );

my $nys = $schema->resultset('State')->find( { state_iso_code => 'NY' } );

my %users;

# Create user john
$users{john} = $schema->resultset("User")->create(
    {
        username => 'john@johndoeinc.local',
        password => 'ohhjohnnyboy',
        first_name => 'John',
        last_name => 'Doe', email => 'john@johndoeinc.local',
            Address => [
                {    
                    type => 'shipping',
                    address => 'Test Road',
                    postal_code => '13783',
                    city => 'Hancock',
                    states_id => $nys->{id},
                    country_iso_code => 'US',
                }
            ],
    }
);

$users{john}{address} = $schema->resultset("Address")->create(
    {
        users_id => $users{john}->id,
        type => 'shipping',
        address => 'Test Road',
        postal_code => '13783',
        city => 'Hancock',
        states_id => $nys->{id},
        country_iso_code => 'US',
    }
);

# populate ShipmentCarriers
my %carrier;
 
$carrier{UPS} = $schema->resultset("ShipmentCarrier")->create(
    {
        name => 'UPS',
        account_number => '1Z99999',
    },
);

#populate shipment methods
$schema->resultset("ShipmentMethod")->populate([
    {
        shipment_carriers_id => $carrier{UPS}->id,
        name => '1DM',
        title => 'Next Day Air Early AM',
        max_weight => '150',
    },
    {
        shipment_carriers_id => $carrier{UPS}->id,
        name => 'GNDRES',
        title => 'Ground Residential',
        max_weight => '150',
     },
]);

ok($carrier{UPS}->id eq '1', "Testing ShipmentCarrier record creation.")
    || diag "UPS ShipmentCarrier id: " . $carrier{UPS}->id;


my $shipment_method = $schema->resultset("ShipmentMethod")->find({ title => 'Next Day Air Early AM' } );

ok($shipment_method->name eq '1DM', "Testing ShipmentMethod record creation.")
    || diag "UPS Next Day Air Early AM name: " . $shipment_method->name;

my %order;
 
# Create order IC60001
$order{IC60001} = $schema->resultset("Order")->create(
    { 
        order_number => 'IC60001',
        users_id => $users{john}->id,
        email => $users{john}->email,
        shipping_addresses_id => $users{john}{address}->id,
        billing_addresses_id => $users{john}{address}->id,
        order_date => $dt,
            Orderline => [
                {
                    order_position => '1',
                    sku => 'WBA0002',
                    name => 'Orvis Helios 2 9FT 6WT Mid Flex Fly Rod',
                    short_description => 'Also a nice rod.',
                    weight => '4.5',
                    quantity => '1',
                    price => '795.00',
                    subtotal => '795.00',
                    shipping => '7.95',
                    handling => '1.95',
                    salestax => '63.36',
                },
            ],
    }
);

#

my %orderline;

$orderline{1} = $order{IC60001}->find_related('Orderline', '1');

ok($orderline{1}->sku eq 'WBA0002', "Testing Orderline record creation.")
    || diag "Orderline 1 sku: " . $orderline{1}->sku;

my %shipment;
# Create shipment 1
$shipment{1} = $schema->resultset("Shipment")->create(
    { 
        shipment_methods_id => $shipment_method->id,
        tracking_number => '1Z99283WNMS984920498320',
        shipment_carriers_id => $carrier{UPS}->id,
    }
);

my $orderlines_shipping = $schema->resultset("OrderlinesShipping")->create(
    {
        orderlines_id => $orderline{1}->id,
        addresses_id => $users{john}{address}->id,
        shipments_id => $shipment{1}->id,
    }
);

# test all relationships

# find order
my $order_rs = $users{john}->find_related('Order', {order_number => 'IC60001'});

my $orderline_rs = $order_rs->find_related('Orderline', {orders_id => $order_rs->id });

my $orderline_shipping_rs = $orderline_rs->find_related('OrderlinesShipping', {orderlines_id => $orderline_rs->id});

my $shipment_rs = $orderline_shipping_rs->find_related('Shipment', {shipments_id => '1' });

ok($shipment_rs->tracking_number eq '1Z99283WNMS984920498320', "Testing tracking number.")
    || diag "Tracking number: " . $shipment_rs->tracking_number;


