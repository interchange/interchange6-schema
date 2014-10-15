package Test::GroupPricing;

use Test::Deep;
use Test::Exception;
use Test::MockDateTime;
use Test::Roo::Role;
use DateTime;

test 'group pricing tests' => sub {

    diag Test::GroupPricing;

    my $self      = shift;
    my $schema    = $self->schema;
    my $rset_gp   = $schema->resultset('GroupPricing');
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

    lives_ok(
        sub {
            $role_multi = $rset_role->create(
                {
                    name  => 'multi',
                    label => 'Multi',
                    description =>
                      'Customer with retail, trade and wholesale roles',
                }
            );
        },
        "Add role 'multi'"
    );

    my $role_anonymous     = $rset_role->find( { name => 'anonymous' } );
    my $role_authenticated = $rset_role->find( { name => 'authenticated' } );

    my $retail_customer    = $self->users->find( { username => 'customer1' } );
    my $trade_customer     = $self->users->find( { username => 'customer2' } );
    my $wholesale_customer = $self->users->find( { username => 'customer3' } );
    my $multi_customer     = $self->users->find( { username => 'admin' } );

    lives_ok( sub { $trade_customer->set_roles( [$role_trade] ) },
        "Add trade role to trade customer" );

    lives_ok( sub { $wholesale_customer->set_roles( [$role_wholesale] ) },
        "Add wholesale role to wholesale customer" );

    lives_ok(
        sub {
            $wholesale_customer->set_roles(
                [ $role_wholesale, $role_authenticated, $role_trade ] );
        },
        "Add wholesale, authenticated & trade roles to multi customer"
    );

    lives_ok(
        sub {
            $rset_gp->populate(
                [
                    [qw/sku quantity roles_id price/],
                    [ 'G0001', 10,  $role_anonymous->id,     19 ],
                    [ 'G0001', 10,  $role_authenticated->id, 19 ],
                    [ 'G0001', 20,  $role_authenticated->id, 18 ],
                    [ 'G0001', 1,   $role_trade->id,         18 ],
                    [ 'G0001', 10,  $role_trade->id,         17 ],
                    [ 'G0001', 20,  $role_trade->id,         16 ],
                    [ 'G0001', 50,  $role_trade->id,         15 ],
                    [ 'G0001', 1,   $role_wholesale->id,     12 ],
                    [ 'G0001', 10,  $role_wholesale->id,     11 ],
                    [ 'G0001', 20,  $role_wholesale->id,     10 ],
                    [ 'G0001', 50,  $role_wholesale->id,     9 ],
                    [ 'G0001', 200, $role_wholesale->id,     8 ],
                ]
            );
        },
        "Add price groups with tiers for sku G0001"
    );

    lives_ok( sub { $product = $self->products->find('G0001') },
        "Find product G0001" );

    my $special_from = DateTime->new( year => 2000, month => 1,  day => 1 );
    my $special_to   = DateTime->new( year => 2000, month => 12, day => 31 );
    lives_ok(
        sub {
            $product->update(
                {
                    special_price      => 19.20,
                    special_price_from => $special_from,
                    special_price_to   => $special_to
                }
            );
        },
        "Set special price for G0001 during 2000"
    );

    # sqlite uses float for numerics and messes them up so use sprintf in
    # all following tests that compare non-integer values

    cmp_ok( sprintf( "%.02f", $product->price ),
        '==', 19.95, "price is 19.95" );

    on '1999-12-31 23:59:59' => sub {
        cmp_ok( sprintf( "%.02f", $product->selling_price ),
            '==', 19.95, "selling_price is 19.95" );
    };
    on '2000-01-01 00:00:00' => sub {
        cmp_ok( sprintf( "%.02f", $product->selling_price ),
            '==', 19.20, "selling_price is 19.20" );
    };
    on '2000-12-31 23:59:59' => sub {
        cmp_ok( sprintf( "%.02f", $product->selling_price ),
            '==', 19.20, "selling_price is 19.20" );
    };
    on '2001-01-01 00:00:00' => sub {
        cmp_ok( sprintf( "%.02f", $product->selling_price ),
            '==', 19.95, "selling_price is 19.95" );
    };

    on '2000-01-01 00:00:00' => sub {
        cmp_ok(
            sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
            '==', 19.20, "anonymous qty 1 selling_price is 19.20" );
    };
    on '2001-01-01 00:00:00' => sub {
        cmp_ok(
            sprintf( "%.02f", $product->selling_price( { quantity => 1 } ) ),
            '==', 19.95, "anonymous qty 1 selling_price is 19.95" );
    };

    on '2000-01-01 00:00:00' => sub {
        cmp_ok( $product->selling_price( { quantity => 15 } ),
            '==', 19, "anonymous qty 15 selling_price is 19" );
    };
    on '2001-01-01 00:00:00' => sub {
        cmp_ok( $product->selling_price( { quantity => 15 } ),
            '==', 19, "anonymous qty 15 selling_price is 19" );
    };

    on '2000-01-01 00:00:00' => sub {
        cmp_ok( $product->selling_price( { quantity => 30 } ),
            '==', 19, "anonymous qty 30 selling_price is 19" );
    };
    on '2001-01-01 00:00:00' => sub {
        cmp_ok( $product->selling_price( { quantity => 30 } ),
            '==', 19, "anonymous qty 30 selling_price is 19" );
    };

    on '2000-01-01 00:00:00' => sub {
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
    };
    on '2001-01-01 00:00:00' => sub {
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
    };

    on '2000-01-01 00:00:00' => sub {
        cmp_ok(
            $product->selling_price(
                { quantity => 15, roles => [qw/authenticated/] }
            ),
            '==', 19,
            "authenticated qty 15 selling_price is 19"
        );
    };
    on '2001-01-01 00:00:00' => sub {
        cmp_ok(
            $product->selling_price(
                { quantity => 15, roles => [qw/authenticated/] }
            ),
            '==', 19,
            "authenticated qty 15 selling_price is 19"
        );
    };

    on '2000-01-01 00:00:00' => sub {
        cmp_ok(
            $product->selling_price(
                { quantity => 30, roles => [qw/authenticated/] }
            ),
            '==', 18,
            "authenticated qty 30 selling_price is 18"
        );
    };
    on '2001-01-01 00:00:00' => sub {
        cmp_ok(
            $product->selling_price(
                { quantity => 30, roles => [qw/authenticated/] }
            ),
            '==', 18,
            "authenticated qty 30 selling_price is 18"
        );
    };

    # from here on special_price is irrelevant - we finished with it ^^
    # so no need to fudge dates anymore

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

    # cleanup
    $rset_gp->delete_all;
    $role_trade->delete;
    $role_wholesale->delete;
    $self->clear_products;
};

1;
