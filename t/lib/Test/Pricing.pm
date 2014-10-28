package Test::Pricing;

use Test::Deep;
use Test::Exception;
use Test::Roo::Role;
use Test::MockTime qw( :all );
use DateTime;

test 'pricing tests' => sub {

    diag Test::Pricing;

    my $self      = shift;
    my $schema    = $self->schema;
    my $rset_gp   = $schema->resultset('Pricing');
    my $rset_role = $schema->resultset('Role');

    # fixtures
    $self->products;
    $self->users;

    my ( $role_trade, $role_wholesale, $role_multi, $product );

    lives_ok(
        sub {
            $role_trade = $rset_role->create(
                {
                    name        => 'trade',
                    label       => 'Trade',
                    description => 'Trade customer',
                }
            );
        },
        "Add role 'trade'"
    );

    lives_ok(
        sub {
            $role_wholesale = $rset_role->create(
                {
                    name        => 'wholesale',
                    label       => 'Wholesale',
                    description => 'Wholesale customer',
                }
            );
        },
        "Add role 'wholesale'"
    );

    my $role_anonymous     = $rset_role->find( { name => 'anonymous' } );
    my $role_authenticated = $rset_role->find( { name => 'authenticated' } );

    my $start = DateTime->new( year => 2000, month => 1,  day => 1 );
    my $end   = DateTime->new( year => 2000, month => 12, day => 31 );

    lives_ok(
        sub {
            $rset_gp->populate(
                [
                    [qw/sku quantity roles_id price start_date end_date/],
                    [ 'G0001', 10,  $role_anonymous->id,     19, undef, undef ],
                    [ 'G0001', 10,  $role_authenticated->id, 19, undef, undef ],
                    [ 'G0001', 20,  $role_authenticated->id, 18, undef, undef ],
                    [ 'G0001', 30,  $role_authenticated->id, 17, undef, undef ],
                    [ 'G0001', 1,   $role_trade->id,         18, undef, undef ],
                    [ 'G0001', 10,  $role_trade->id,         17, undef, undef ],
                    [ 'G0001', 20,  $role_trade->id,         16, undef, undef ],
                    [ 'G0001', 50,  $role_trade->id,         15, undef, undef ],
                    [ 'G0001', 1,   $role_wholesale->id,     12, undef, undef ],
                    [ 'G0001', 10,  $role_wholesale->id,     11, undef, undef ],
                    [ 'G0001', 20,  $role_wholesale->id,     10, undef, undef ],
                    [ 'G0001', 50,  $role_wholesale->id,     9,  undef, undef ],
                    [ 'G0001', 200, $role_wholesale->id,     8,  undef, undef ],
                    [ 'G0001', 1, $role_anonymous->id, 19.20, $start, $end ],
                    [ 'G0001', 1, $role_trade->id,     17,    $start, $end ],
                ]
            );
        },
        "Add price groups with tiers for sku G0001"
    );

    lives_ok( sub { $product = $self->products->find('G0001') },
        "Find product G0001" );

    # sqlite uses float for numerics and messes them up so use sprintf in
    # all following tests that compare non-integer values

    # price always fixed

    cmp_ok( sprintf( "%.02f", $product->price ),
        '==', 19.95, "price is 19.95" );

    # end of 1999

    set_absolute_time('1999-12-31T23:59:59Z');

    cmp_ok( sprintf( "%.02f", $product->selling_price ),
        '==', 19.95, "selling_price is 19.95" );

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
        '==', 19.95, "selling_price is 19.95" );

    cmp_ok( sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
        '==', 19.95, "anonymous qty 1 selling_price is 19.95" );

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
        '==', 19.95,
        "authenticated qty 1 selling_price is 19.95"
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
    $rset_gp->delete_all;
    $role_trade->delete;
    $role_wholesale->delete;
    $self->clear_products;
};

1;
