package Test::PriceModifier;

use Test::Deep;
use Test::Exception;
use Test::Roo::Role;
use Test::MockTime qw( :all );
use DateTime;

test 'pricing tests' => sub {

    diag 'Test::PriceModifier';

    my $self      = shift;
    my $schema    = $self->ic6s_schema;
    my $rset_pm   = $schema->resultset('PriceModifier');
    my $rset_role = $schema->resultset('Role');

    # fixtures
    $self->products;
    $self->price_modifiers;

    my ( $role_multi, $product );

    cmp_ok( $rset_role->find({ name => 'trade' })->label,
        'eq', 'Trade customer', "Trade customer role exists" );

    cmp_ok( $rset_role->find({ name => 'user' })->label,
        'eq', 'User', "User role exists" );

    lives_ok( sub { $product = $self->products->find('os28005') },
        "Find product os28005" );

    # sqlite uses float for numerics and messes them up so use sprintf in
    # all following tests that compare non-integer values

    # price always fixed

    cmp_ok( sprintf( "%.02f", $product->price ),
        '==', 8.99, "price is 8.99" );

    # end of 1999

    set_absolute_time('1999-12-31T23:59:59Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 8.99, "selling_price is 8.99" );

    # during 2000

    set_absolute_time('2000-06-01T00:00:00Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 7.50, "selling_price is 7.50" );

    cmp_ok( sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
        '==', 7.50, "anonymous qty 1 selling_price is 7.50" );

    cmp_ok( sprintf ( "%.2f", $product->selling_price( { quantity => 15 } ) ),
        '==', 7.50, "anonymous qty 15 selling_price is 7.50" );

    cmp_ok( sprintf( "%.2f", $product->selling_price( { quantity => 30 } ) ),
        '==', 7.50, "anonymous qty 30 selling_price is 7.50" );

    cmp_ok(
        sprintf(
            "%.02f",
            $product->selling_price(
                { quantity => 1, roles => [qw/authenticated/] }
            )
        ),
        '==', 7.50,
        "authenticated qty 1 selling_price is 7.50"
    );

    cmp_ok(
        sprintf( "%.2f",
            $product->selling_price( { quantity => 1, roles => [qw/trade/] } )
        ),
        '==', 6.90,
        "trade qty 1 selling_price is 6.90"
    );

    cmp_ok(
        sprintf ( "%.2f", $product->selling_price(
            { quantity => 15, roles => [qw/trade/] }
        )),
        '==', 6.90,
        "trade qty 15 selling_price is 6.90"
    );

    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 50, roles => [qw/trade/] }
        )),
        '==', 6.90,
        "trade qty 50 selling_price is 6.90"
    );

    # 2001

    set_absolute_time('2001-01-01T00:00:00Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 8.99, "selling_price is 8.99" );

    cmp_ok( sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
        '==', 8.99, "anonymous qty 1 selling_price is 8.99" );

    cmp_ok( sprintf( "%.2f", $product->selling_price( { quantity => 15 } ) ),
        '==', 8.49, "anonymous qty 15 selling_price is 8.49" );

    cmp_ok( sprintf( "%.2f", $product->selling_price( { quantity => 30 } ) ),
        '==', 8.49, "anonymous qty 30 selling_price is 8.49" );

    cmp_ok(
        sprintf(
            "%.02f",
            $product->selling_price(
                { quantity => 1, roles => [qw/authenticated/] }
            )
        ),
        '==', 8.99,
        "authenticated qty 1 selling_price is 8.99"
    );

    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 15, roles => [qw/authenticated/] }
        )),
        '==', 8.20,
        "authenticated qty 15 selling_price is 8.20"
    );

    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 25, roles => [qw/authenticated/] }
        )),
        '==', 8.00,
        "authenticated qty 25 selling_price is 8.00"
    );

    # stop mocking time

    restore_time();

    cmp_ok( $product->selling_price( { quantity => 1, roles => [qw/trade/] } ),
        '==', 8, "trade qty 1 selling_price is 8" );
    cmp_ok( $product->selling_price( { quantity => 2, roles => [qw/trade/] } ),
        '==', 8, "trade qty 2 selling_price is 8" );
    cmp_ok(
        sprintf( "%.2f",
            $product->selling_price( { quantity => 15, roles => [qw/trade/] } )
        ),
        '==', 7.80,
        "trade qty 15 selling_price is 7.80"
    );
    cmp_ok(
        sprintf( "%.2f",
            $product->selling_price( { quantity => 30, roles => [qw/trade/] } )
        ),
        '==', 7.50,
        "trade qty 30 selling_price is 7.50"
    );
    cmp_ok( $product->selling_price( { quantity => 50, roles => [qw/trade/] } ),
        '==', 7, "trade qty 50 selling_price is 7" );

    cmp_ok(
        $product->selling_price(
            { quantity => 1, roles => [qw/authenticated trade/] }
        ),
        '==', 8,
        "authenticated & trade qty 1 selling_price is 8"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 2, roles => [qw/authenticated trade/] }
        ),
        '==', 8,
        "authenticated & trade qty 2 selling_price is 8"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 15, roles => [qw/authenticated trade/] }
        )),
        '==', 7.80,
        "authenticated & trade qty 15 selling_price is 7.80"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 30, roles => [qw/authenticated trade/] }
        )),
        '==', 7.50,
        "authenticated & trade qty 30 selling_price is 7.50"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 50, roles => [qw/authenticated trade/] }
        ),
        '==', 7,
        "authenticated & trade qty 50 selling_price is 7"
    );

    cmp_ok(
        $product->selling_price(
            { quantity => 1, roles => [qw/wholesale trade/] }
        ),
        '==', 7,
        "wholesale & trade qty 1 selling_price is 7"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 2, roles => [qw/wholesale trade/] }
        ),
        '==', 7,
        "wholesale & trade qty 2 selling_price is 7"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 15, roles => [qw/wholesale trade/] }
        )),
        '==', 6.80,
        "wholesale & trade qty 15 selling_price is 6.80"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 30, roles => [qw/wholesale trade/] }
        )),
        '==', 6.70,
        "wholesale & trade qty 30 selling_price is 6.70"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 50, roles => [qw/wholesale trade/] }
        )),
        '==', 6.50,
        "wholesale & trade qty 50 selling_price is 6.50"
    );

    # TODO: add tier pricing tests
    $product->tier_pricing([qw/anonymous authenticated trade wholesale/]);
    # cleanup
    $rset_pm->delete_all;
    $self->clear_roles;
    $self->clear_price_modifiers;
    $self->clear_products;
};

1;
