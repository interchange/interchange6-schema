package Test::Relationships;

use Test::Exception;
use Test::Roo::Role;

test 'Address delete cascade' => sub {

    diag "Test::Relationships";

    my $self   = shift;
    my $schema = $self->ic6s_schema;

    # prereqs
    $self->addresses unless $self->has_addresses;
    $self->orders    unless $self->has_orders;

    my ( $customer, $shipping_address, $billing_address, $order, $orderline,
        $shipment, $carrier, $result );

    lives_ok(
        sub { $customer = $self->users->find( { username => 'customer2' } ) },
        "find customer2 (this customer has states_id set in all addresses)" );

    ok( defined $customer, "we have a customer" );

    lives_ok( sub { $order = $customer->orders->first },
        "find customer order" );

    ok( defined $order, "we have an order" );

    lives_ok( sub { $billing_address = $order->billing_address; },
        "find the billing address" );

    ok( defined $billing_address, "we have a billing address" );

    cmp_ok( $billing_address->orders->count,
        '==', 1, "billing address has 1 order" );

    ok( defined $billing_address->state, "billing address has state" );

    lives_ok( sub { $shipping_address = $order->shipping_address; },
        "find the shipping address" );

    ok( defined $shipping_address, "we have a shipping address" );

    ok( defined $shipping_address->state, "shipping address has state" );

    cmp_ok( $shipping_address->orderlines_shipping->count,
        '==', 0, "shipping address has 0 orderlines_shipping" );

    cmp_ok( $shipping_address->orderlines->count,
        '==', 0, "shipping address has 0 orderlines" );

    lives_ok( sub { $orderline = $order->orderlines->first },
        "find an orderline" );

    ok( defined $order, "we have an orderline" );

    lives_ok( sub { $carrier = $self->shipment_carriers->first },
        "find a carrier" );

    ok( defined $carrier, "we have a carrier" );

    lives_ok(
        sub {
            $shipment = $schema->resultset("Shipment")->create(
                {
                    shipment_methods_id =>
                      $carrier->shipment_methods->first->id,
                    tracking_number      => '123456789ABC',
                    shipment_carriers_id => $carrier->id,
                }
            );
        },
        "create a shipment"
    );

    ok( defined $shipment, "we have a shipment" );

    lives_ok(
        sub {
            $result = $orderline->create_related(
                'orderlines_shipping',
                {
                    addresses_id => $shipping_address->id,
                    shipments_id => $shipment->id
                }
            );
        },
        "create orderlines_shipping row for this orderline/shipment"
    );

    ok( defined $result, "we got the orderlines_shipping row" );

    cmp_ok( $shipping_address->orderlines_shipping->count,
        '==', 1, "shipping address has 1 orderlines_shipping" );

    cmp_ok( $shipping_address->orderlines->count,
        '==', 1, "shipping address has 1 orderline" );

    # save counts for all relationships of Address so we can check against
    # these later
    my $num_orderlines_shipping =
      $schema->resultset('OrderlinesShipping')->count;
    my $num_orders     = $self->orders->count;
    my $num_users      = $self->users->count;
    my $num_states     = $self->states->count;
    my $num_countries  = $self->countries->count;
    my $num_orderlines = $schema->resultset('Orderline')->count;

    throws_ok( sub { $billing_address->delete },
        qr/failed/i, "fail to delete billing address" );

    throws_ok( sub { $shipping_address->delete },
        qr/failed/i, "fail to delete shipping address" );

    cmp_ok( $schema->resultset('OrderlinesShipping')->count,
        '==', $num_orderlines_shipping,
        "count of orderlines_shipping has not changed" );
    cmp_ok( $self->orders->count, '==', $num_orders,
        "count of orders has not changed" );
    cmp_ok( $self->users->count, '==', $num_users,
        "count of users has not changed" );
    cmp_ok( $self->states->count, '==', $num_states,
        "count of states has not changed" );
    cmp_ok( $self->countries->count,
        '==', $num_countries, "count of countries has not changed" );
    cmp_ok( $schema->resultset('Orderline')->count,
        '==', $num_orderlines, "count of orderlines has not changed" );

};

1;
