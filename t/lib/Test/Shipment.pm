package Test::Shipment;

use Test::Most;
use Test::Roo::Role;

use DateTime;
use Scalar::Util qw(blessed);
use Number::Format qw(format_number);

test 'shipment tests' => sub {
    my $self = shift;

    my ( $rset, %countries, %states, %zones, $data, $result );

    my $dt = DateTime->now;

    my $schema = $self->schema;

    my $rsetzone = $schema->resultset('Zone');

    my $nys = $schema->resultset('State')->find( { state_iso_code => 'NY' } );

    my %users;

    # Create user john
    $users{john} = $schema->resultset("User")->create(
        {
            username   => 'john@johndoeinc.local',
            password   => 'ohhjohnnyboy',
            first_name => 'John',
            last_name  => 'Doe',
            email      => 'john@johndoeinc.local',
            addresses  => [
                {
                    type             => 'shipping',
                    address          => 'Test Road',
                    postal_code      => '13783',
                    city             => 'Hancock',
                    states_id        => $nys->{id},
                    country_iso_code => 'US',
                }
            ],
        }
    );

    $users{john}{address} = $schema->resultset("Address")->create(
        {
            users_id         => $users{john}->id,
            type             => 'shipping',
            address          => 'Test Road',
            postal_code      => '13783',
            city             => 'Hancock',
            states_id        => $nys->{id},
            country_iso_code => 'US',
        }
    );

    # populate ShipmentCarriers
    my %carrier;

    $carrier{UPS} = $schema->resultset("ShipmentCarrier")->create(
        {
            name           => 'UPS',
            account_number => '1Z99999',
        },
    );

    #populate shipment methods
    $schema->resultset("ShipmentMethod")->populate(
        [
            {
                shipment_carriers_id => $carrier{UPS}->id,
                name                 => '1DM',
                title                => 'Next Day Air Early AM',
                max_weight           => '150',
            },
            {
                shipment_carriers_id => $carrier{UPS}->id,
                name                 => 'GNDRES',
                title                => 'Ground Residential',
                max_weight           => '150',
            },
        ]
    );

    ok( $carrier{UPS}->id eq '1', "Testing ShipmentCarrier record creation." )
      || diag "UPS ShipmentCarrier id: " . $carrier{UPS}->id;

    my $shipment_method = $schema->resultset("ShipmentMethod")
      ->find( { title => 'Ground Residential' } );

    ok(
        $shipment_method->name eq 'GNDRES',
        "Testing ShipmentMethod record creation."
    ) || diag "UPS Ground Residential name: " . $shipment_method->name;

    my $lower48 = $schema->resultset("Zone")->find( { zone => 'US lower 48' } );

    my %flat_rate;

    $flat_rate{GROUND} = $schema->resultset("ShipmentRate")->create(
        {
            zones_id            => $lower48->id,
            shipment_methods_id => $shipment_method->id,
            min_weight          => '0',
            max_weight          => '0',
            price               => '9.95',
        }
    );

    my $shipment_rate = $schema->resultset("ShipmentRate")
      ->find( { shipment_methods_id => $shipment_method->id } );

    my $price = format_number( $shipment_rate->price, 2, 1 );

    ok( $price eq '9.95',
        "Testing flat rate shipping price for UPS Ground lower 48 states." )
      || diag "Flat rate shipping price. " . $price;

    my %order;

    lives_ok( sub { $result = $schema->resultset("Product")->create(
                {
                    sku => "WBA0002",
                    name           => 'Orvis Helios 2 9FT 6WT Mid Flex Fly Rod',
                    short_description => 'Also a nice rod.',
                    description       => 'In fact a very nice rod indeed',
                    weight            => '4.5',
                    price             => '795.00',
                }
            )}, "Create product WBA0002" );

    lives_ok( sub { $order{IC60001} = $schema->resultset("Order")->create(
        {
            order_number          => 'IC60001',
            users_id              => $users{john}->id,
            email                 => $users{john}->email,
            shipping_addresses_id => $users{john}{address}->id,
            billing_addresses_id  => $users{john}{address}->id,
            order_date            => $dt,
            orderlines            => [
                {
                    order_position => '1',
                    sku            => 'WBA0002',
                    name           => 'Orvis Helios 2 9FT 6WT Mid Flex Fly Rod',
                    short_description => 'Also a nice rod.',
                    description       => 'In fact a very nice rod indeed',
                    weight            => '4.5',
                    quantity          => '1',
                    price             => '795.00',
                    subtotal          => '795.00',
                    shipping          => '7.95',
                    handling          => '1.95',
                    salestax          => '63.36',
                },
            ],
        }
    )}, "Create order IC60001" );

    my %orderline;

    $orderline{1} = $order{IC60001}->find_related( 'orderlines', '1' );

    ok( $orderline{1}->sku eq 'WBA0002', "Testing Orderline record creation." )
      || diag "Orderline 1 sku: " . $orderline{1}->sku;

    my %shipment;

    # Create shipment 1
    $shipment{1} = $schema->resultset("Shipment")->create(
        {
            shipment_methods_id  => $shipment_method->id,
            tracking_number      => '1Z99283WNMS984920498320',
            shipment_carriers_id => $carrier{UPS}->id,
        }
    );

    my $orderlines_shipping = $schema->resultset("OrderlinesShipping")->create(
        {
            orderlines_id => $orderline{1}->id,
            addresses_id  => $users{john}{address}->id,
            shipments_id  => $shipment{1}->id,
        }
    );

    # test all relationships

    # find order
    my $order_rs =
      $users{john}->find_related( 'orders', { order_number => 'IC60001' } );

    my $orderline_rs =
      $order_rs->find_related( 'orderlines', { orders_id => $order_rs->id } );

    my $orderline_shipping_rs =
      $orderline_rs->find_related( 'orderlines_shipping',
        { orderlines_id => $orderline_rs->id } );

    my $shipment_rs = $orderline_shipping_rs->find_related( 'shipment',
        { shipments_id => '1' } );

    ok( $shipment_rs->tracking_number eq '1Z99283WNMS984920498320',
        "Testing tracking number." )
      || diag "Tracking number: " . $shipment_rs->tracking_number;

};

1;
