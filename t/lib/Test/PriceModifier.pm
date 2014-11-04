package Test::PriceModifier;

use Test::Deep;
use Test::Exception;
use Test::Roo::Role;
use Test::MockTime qw( :all );
use DateTime;

test 'pricing tests' => sub {

    diag 'Test::PriceModifier';

    my $self      = shift;
    my $schema    = $self->schema;
    my $rset_pm   = $schema->resultset('PriceModifier');
    my $rset_role = $schema->resultset('Role');

    # fixtures
    $self->products;
    $self->price_modifiers;

    my ( $role_multi, $product );

    cmp_ok( $rset_role->find({ name => 'trade' })->label,
        'eq', 'Trade customer', "Trade customer exists" );

    cmp_ok( $rset_role->find({ name => 'anonymous' })->label,
        'eq', 'Anonymous', "Anonamous customer exists" );

    lives_ok( sub { $product = $self->products->find('os28004') },
        "Find product os28004" );

    # sqlite uses float for numerics and messes them up so use sprintf in
    # all following tests that compare non-integer values

    # price always fixed

    cmp_ok( sprintf( "%.02f", $product->price ),
        '==', 21.99, "price is 21.99" );

    # end of 1999

    set_absolute_time('1999-12-31T23:59:59Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 21.99, "selling_price is 21.99" );

    # during 2000

    set_absolute_time('2000-06-01T00:00:00Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 19.20, "selling_price is 19.20" );

    cmp_ok( sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
        '==', 19.20, "anonymous qty 1 selling_price is 19.20" );

    cmp_ok( $product->selling_price( { quantity => 15 } ),
        '==', 19, "anonymous qty 15 selling_price is 19" );

    cmp_ok( $product->selling_price( { quantity => 30 } ),
        '==', 19, "anonymous qty 30 selling_price is 19" );

    cmp_ok(
        sprintf(
            "%.02f",
            $product->selling_price(
                { quantity => 1, roles => [qw/authenticated/] }
            )
        ),
        '==', 19.20,
        "authenticated qty 1 selling_price is 19.20"
    );

    cmp_ok( $product->selling_price( { quantity => 1, roles => [qw/trade/] }),
        '==', 17, "trade qty 1 selling_price is 17");

    cmp_ok(
        $product->selling_price(
            { quantity => 15, roles => [qw/authenticated/] }
        ),
        '==', 19,
        "authenticated qty 15 selling_price is 19"
    );

    cmp_ok(
        $product->selling_price(
            { quantity => 25, roles => [qw/authenticated/] }
        ),
        '==', 18,
        "authenticated qty 25 selling_price is 18"
    );

    # 2001

    set_absolute_time('2001-01-01T00:00:00Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 21.99, "selling_price is 21.99" );

    cmp_ok( sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
        '==', 21.99, "anonymous qty 1 selling_price is 21.99" );

    cmp_ok( $product->selling_price( { quantity => 15 } ),
        '==', 19, "anonymous qty 15 selling_price is 19" );

    cmp_ok( $product->selling_price( { quantity => 30 } ),
        '==', 19, "anonymous qty 30 selling_price is 19" );

    cmp_ok(
        sprintf(
            "%.02f",
            $product->selling_price(
                { quantity => 1, roles => [qw/authenticated/] }
            )
        ),
        '==', 21.99,
        "authenticated qty 1 selling_price is 21.99"
    );

    cmp_ok(
        $product->selling_price(
            { quantity => 15, roles => [qw/authenticated/] }
        ),
        '==', 19,
        "authenticated qty 15 selling_price is 19"
    );

    cmp_ok(
        $product->selling_price(
            { quantity => 25, roles => [qw/authenticated/] }
        ),
        '==', 18,
        "authenticated qty 25 selling_price is 18"
    );

    # stop mocking time

    restore_time();

    cmp_ok( $product->selling_price( { quantity => 1, roles => [qw/trade/] } ),
        '==', 18, "trade qty 1 selling_price is 18" );
    cmp_ok( $product->selling_price( { quantity => 2, roles => [qw/trade/] } ),
        '==', 18, "trade qty 2 selling_price is 18" );
    cmp_ok( $product->selling_price( { quantity => 15, roles => [qw/trade/] } ),
        '==', 17, "trade qty 15 selling_price is 17" );
    cmp_ok( $product->selling_price( { quantity => 30, roles => [qw/trade/] } ),
        '==', 16, "trade qty 30 selling_price is 16" );
    cmp_ok( $product->selling_price( { quantity => 50, roles => [qw/trade/] } ),
        '==', 15, "trade qty 50 selling_price is 15" );

    cmp_ok(
        $product->selling_price(
            { quantity => 1, roles => [qw/authenticated trade/] }
        ),
        '==', 18,
        "authenticated & trade qty 1 selling_price is 18"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 2, roles => [qw/authenticated trade/] }
        ),
        '==', 18,
        "authenticated & trade qty 2 selling_price is 18"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 15, roles => [qw/authenticated trade/] }
        ),
        '==', 17,
        "authenticated & trade qty 15 selling_price is 17"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 30, roles => [qw/authenticated trade/] }
        ),
        '==', 16,
        "authenticated & trade qty 30 selling_price is 16"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 50, roles => [qw/authenticated trade/] }
        ),
        '==', 15,
        "authenticated & trade qty 50 selling_price is 15"
    );

    cmp_ok(
        $product->selling_price(
            { quantity => 1, roles => [qw/wholesale trade/] }
        ),
        '==', 12,
        "wholesale & trade qty 1 selling_price is 12"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 2, roles => [qw/wholesale trade/] }
        ),
        '==', 12,
        "wholesale & trade qty 2 selling_price is 12"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 15, roles => [qw/wholesale trade/] }
        ),
        '==', 11,
        "wholesale & trade qty 15 selling_price is 11"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 30, roles => [qw/wholesale trade/] }
        ),
        '==', 10,
        "wholesale & trade qty 30 selling_price is 10"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 50, roles => [qw/wholesale trade/] }
        ),
        '==', 9,
        "wholesale & trade qty 50 selling_price is 9"
    );

    $product->tier_pricing([qw/anonymous authenticated trade wholesale/]);
    # cleanup
    $rset_pm->delete_all;
    $self->clear_roles;
    $self->clear_price_modifiers;
    $self->clear_products;
};

1;
