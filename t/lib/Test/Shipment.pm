package Test::Shipment;

use Test::Most;
use Test::Roo::Role;

use DateTime;

test 'shipment tests' => sub {

    diag Test::Shipment;

    my $self = shift;

    my ( $rset, %countries, %states, %zones, $data, $result );

    my $schema = $self->schema;

    # grab a few things from fixtures

    my $nys = $self->states->find( { state_iso_code => 'NY' } );

    my $user = $self->users->find( { username => 'customer1' } );

    my $billing_address =
      $self->addresses->search( { users_id => $user->id, type => 'billing' } )
      ->first;

    my $shipping_address =
      $self->addresses->search( { users_id => $user->id, type => 'shipping' } )
      ->first;

    # populate ShipmentCarriers

    my %carrier;

    $carrier{UPS} = $schema->resultset("ShipmentCarrier")->create(
        {
            name           => 'UPS',
            account_number => '1Z99999',
        },
    );

    $carrier{KISS} = $schema->resultset("ShipmentCarrier")->create(
        {
            name => 'KISS',
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
            },
            {
                shipment_carriers_id => $carrier{UPS}->id,
                name                 => 'GNDRES',
                title                => 'Ground Residential',
            },
            {
                shipment_carriers_id => $carrier{KISS}->id,
                name                 => 'KISSFAST',
                title                => 'Keep it Simple and Stupid',
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

    my $kiss_shipment_method = $schema->resultset("ShipmentMethod")
        ->find( { shipment_carriers_id => $carrier{KISS}->id });

    ok (
        $kiss_shipment_method->name eq 'KISSFAST',
        "Testing ShipmentMethod record creation.",
    ) || diag "KISS name: ". $kiss_shipment_method->name;

    my $kissfast_id = $kiss_shipment_method->id;
    my $lower48 = $self->zones->find( { zone => 'US lower 48' } );

    lives_ok(
        sub {
            $schema->resultset("ShipmentRate")->create(
                {
                    zones_id            => $lower48->id,
                    shipment_methods_id => $shipment_method->id,
                    condition_name      => 'weight',
                    min_value           => 0,
                    max_value           => 0,
                    price               => 9.95,
                }
            );
        },
        "create ShipmentRate"
    );

    my %flat_rate;

    lives_ok( sub { $flat_rate{KISSFAST_60} = $schema->resultset("ShipmentRate")->create(
                {
                    zones_id            => $lower48->id,
                    shipment_methods_id => $kissfast_id,
                    condition_name      => 'subtotal',
                    min_value           => undef,
                    max_value           => '60',
                    price               => '9.95',
                }
            )}, "Create KISSFAST_60 shipping rate." );

    lives_ok( sub { $flat_rate{KISSFAST_FREE} = $schema->resultset("ShipmentRate")->create(
                {
                    zones_id            => $lower48->id,
                    shipment_methods_id => $kissfast_id,
                    condition_name      => 'subtotal',
                    min_value           => '60',
                    max_value           => undef,
                    price               => '9.95',
                }
            )}, "Create KISSFAST_FREE shipping rate." );

    my $shipment_rate = $schema->resultset("ShipmentRate")
      ->find( { shipment_methods_id => $shipment_method->id } );

    # ugly use of sprintf as SQLite uses float for numeric which can break test
    cmp_ok( sprintf("%.02f", $shipment_rate->price), '==', 9.95,
        "Testing flat rate shipping price for UPS Ground lower 48 states." );

    my ( $product, $order );

    lives_ok( sub { $product = $self->products->first } );

    my $shipping_address_id = $shipping_address->id;
    my $billing_address_id  = $billing_address->id;

    lives_ok(
        sub {
            $order = $schema->resultset("Order")->create(
                {
                    order_number          => 'IC60001',
                    users_id              => $user->users_id,
                    email                 => $user->email,
                    shipping_addresses_id => $shipping_address_id,
                    billing_addresses_id  => $billing_address_id,
                    order_date            => DateTime->now,
                    orderlines            => [
                        {
                            order_position => '1',
                            sku            => $product->sku,
                            name           => $product->name,
                            description    => $product->description,
                            weight         => $product->weight,
                            quantity       => 1,
                            price          => 795,
                            subtotal       => 795,
                            shipping       => 7.95,
                            handling       => 1.95,
                            salestax       => 63.36,
                        },
                    ],
                }
            );
        },
        "Create order IC60001"
    );

    my $orderline = $order->find_related( 'orderlines', '1' );

    cmp_ok( $orderline->sku, 'eq', $product->sku,
        "Testing Orderline record creation." );

    # Create shipment 1
    my $shipment = $schema->resultset("Shipment")->create(
        {
            shipment_methods_id  => $shipment_method->id,
            tracking_number      => '1Z99283WNMS984920498320',
            shipment_carriers_id => $carrier{UPS}->id,
        }
    );

    my $orderlines_shipping = $schema->resultset("OrderlinesShipping")->create(
        {
            orderlines_id => $orderline->id,
            addresses_id  => $shipping_address->id,
            shipments_id  => $shipment->id,
        }
    );

    # test all relationships

    # find order
    my $order_rs =
      $user->find_related( 'orders', { order_number => 'IC60001' } );

    my $orderline_rs =
      $order_rs->find_related( 'orderlines', { orders_id => $order_rs->id } );

    my $orderline_shipping_rs =
      $orderline_rs->find_related( 'orderlines_shipping',
        { orderlines_id => $orderline_rs->id } );

    my $shipment_rs = $orderline_shipping_rs->find_related( 'shipment',
        { shipments_id => '1' } );

    cmp_ok( $shipment_rs->tracking_number,
        'eq', '1Z99283WNMS984920498320', "Testing tracking number." );

    # cleanup
    $schema->resultset('Order')->delete_all;

};

1;
