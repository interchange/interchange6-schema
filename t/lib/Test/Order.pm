package Test::Order;

use Test::Exception;
use Test::Roo::Role;

use DateTime;

test 'order tests' => sub {

    diag 'Test::Order';

    my $self = shift;

    my ( $rset, %countries, %states, %zones, $data, $result );

    my $schema = $self->ic6s_schema;

    # grab a few things from fixtures

    my $nys = $self->states->find( { state_iso_code => 'NY' } );

    my $user = $self->users->find( { username => 'customer1' } );

    my $billing_address =
      $self->addresses->search( { users_id => $user->id, type => 'billing' } )
      ->first;

    my $shipping_address =
      $self->addresses->search( { users_id => $user->id, type => 'shipping' } )
      ->first;

    my ( $product, $order );

    lives_ok( sub { $product = $self->products->first }, "grab a product" );

    lives_ok(
        sub {
            $order = $schema->resultset("Order")->create(
                {
                    order_number          => 'IC60001',
                    users_id              => $user->users_id,
                    email                 => $user->email,
                    shipping_addresses_id => $shipping_address->id,
                    billing_addresses_id  => $billing_address->id,
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
                    statuses => [ { status => 'new' } ],
                }
            );
        },
        "Create order IC60001"
    );

    cmp_ok( $order->statuses->count, '==', 1, "1 order status" );

    my $status;

    lives_ok( sub { $status = $order->status('picking') },
        "add status picking" );
    cmp_ok( $status, 'eq', 'picking', "status is picking" );

    cmp_ok( $order->statuses->count, '==', 2, "2 order statuses" );
    cmp_ok( $order->status, 'eq', 'picking', "status is picking" );

    cmp_ok( $schema->resultset('OrderStatus')->count,
        '==', 2, "2 OrderStatus rows" );

    lives_ok(
        sub {
            $order =
              $schema->resultset("Order")->with_status->find( $order->id );
        },
        "get order via rset with_status"
    );

    ok( $order->has_column_loaded('status'), "has_column_loaded status" );
    cmp_ok( $order->status, 'eq', 'picking', "status is picking" );

    # cleanup
    $self->clear_orders;

    cmp_ok( $schema->resultset('OrderStatus')->count,
        '==', 0, "0 OrderStatus rows" );

};

1;
