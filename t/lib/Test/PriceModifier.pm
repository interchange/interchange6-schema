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
    $self->products unless $self->has_products;
    $self->navigation unless $self->has_navigation;
    $self->price_modifiers unless $self->has_price_modifiers;

    my ( $role_multi, $product, $nav, $products, @products );

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
        '==', 7.50, "undef role qty 1 selling_price is 7.50" );

    cmp_ok( sprintf ( "%.2f", $product->selling_price( { quantity => 15 } ) ),
        '==', 7.50, "undef role qty 15 selling_price is 7.50" );

    cmp_ok( sprintf( "%.2f", $product->selling_price( { quantity => 30 } ) ),
        '==', 7.50, "undef role qty 30 selling_price is 7.50" );

    cmp_ok(
        sprintf(
            "%.02f",
            $product->selling_price(
                { quantity => 1, roles => [qw/user/] }
            )
        ),
        '==', 7.50,
        "user qty 1 selling_price is 7.50"
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
        '==', 8.99, "undef role qty 1 selling_price is 8.99" );

    cmp_ok( sprintf( "%.2f", $product->selling_price( { quantity => 15 } ) ),
        '==', 8.49, "undef role qty 15 selling_price is 8.49" );

    cmp_ok( sprintf( "%.2f", $product->selling_price( { quantity => 30 } ) ),
        '==', 8.49, "undef role qty 30 selling_price is 8.49" );

    cmp_ok(
        sprintf(
            "%.02f",
            $product->selling_price(
                { quantity => 1, roles => [qw/user/] }
            )
        ),
        '==', 8.99,
        "user qty 1 selling_price is 8.99"
    );

    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 15, roles => [qw/user/] }
        )),
        '==', 8.20,
        "user qty 15 selling_price is 8.20"
    );

    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 25, roles => [qw/user/] }
        )),
        '==', 8.00,
        "user qty 25 selling_price is 8.00"
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
            { quantity => 1, roles => [qw/user trade/] }
        ),
        '==', 8,
        "user & trade qty 1 selling_price is 8"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 2, roles => [qw/user trade/] }
        ),
        '==', 8,
        "user & trade qty 2 selling_price is 8"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 15, roles => [qw/user trade/] }
        )),
        '==', 7.80,
        "user & trade qty 15 selling_price is 7.80"
    );
    cmp_ok(
        sprintf( "%.2f", $product->selling_price(
            { quantity => 30, roles => [qw/user trade/] }
        )),
        '==', 7.50,
        "user & trade qty 30 selling_price is 7.50"
    );
    cmp_ok(
        $product->selling_price(
            { quantity => 50, roles => [qw/user trade/] }
        ),
        '==', 7,
        "user & trade qty 50 selling_price is 7"
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

    # NavigationProduct->product_with_selling_price

    lives_ok(
        sub {
            $nav =
              $schema->resultset('Navigation')->find(
                { uri => 'painting-supplies/paintbrushes' } );
        },
        "find paintbrushes in navigation"
    );

    cmp_ok( $nav->name, 'eq', "Paintbrushes", "nav has name Paintbrushes" );

    # no args to product_with_selling_price

    lives_ok(
        sub {
            $products =
              $nav->navigation_products->search_related('product')->active;
        },
        "find all active paintbrush products"
    );

    cmp_ok( $products->count, "==", 3, "we have 3 products" );

    lives_ok(
        sub {
            @products = $products->listing->search( undef,
                { order_by => { -desc => 'product.sku' } } )->all;
        },
        "get product listing order by sku desc"
    );

    my $expected = [
        {
            discount_percent  => undef,
            inventory         => undef,
            name              => "Disposable Brush Set",
            price             => num(14.99, 0.01),
            average_rating    => 0,
            selling_price     => num(14.99, 0.01),
            short_description => "Disposable Brush Set",
            sku               => "os28007",
            uri               => "disposable-brush-set"
        },
        {
            discount_percent  => 16,
            inventory         => undef,
            name              => "Painters Brush Set",
            price             => num(29.99, 0.01),
            average_rating    => 0,
            selling_price     => num(24.99, 0.01),
            short_description => "Painters Brush Set",
            sku               => "os28006",
            uri               => "painters-brush-set"
        },
        {
            discount_percent  => undef,
            inventory         => undef,
            name              => "Trim Brush",
            price             => num(8.99, 0.01),
            average_rating    => 0,
            selling_price     => num(8.99, 0.01),
            short_description => "Trim Brush",
            sku               => "os28005",
            uri               => "trim-brush"
        }
    ];

    cmp_deeply( \@products, $expected, "do we have expected products?" );

    lives_ok(
        sub {
            @products = $products->listing->search(
                undef,
                {
                    order_by => { -desc => 'product.sku' },
                    rows     => 2,
                    page     => 1
                }
            )->all;
        },
        "get product listing order by sku desc with 2 rows and page 1"
    );

    $expected = [
        {
            discount_percent  => undef,
            inventory         => undef,
            name              => "Disposable Brush Set",
            price             => num(14.99, 0.01),
            average_rating    => 0,
            selling_price     => num(14.99, 0.01),
            short_description => "Disposable Brush Set",
            sku               => "os28007",
            uri               => "disposable-brush-set"
        },
        {
            discount_percent  => 16,
            inventory         => undef,
            name              => "Painters Brush Set",
            price             => num(29.99, 0.01),
            average_rating    => 0,
            selling_price     => num(24.99, 0.01),
            short_description => "Painters Brush Set",
            sku               => "os28006",
            uri               => "painters-brush-set"
        },
    ];

    cmp_deeply( \@products, $expected, "do we have expected products?" );

    lives_ok(
        sub {
            @products = $products->listing->search(
                undef,
                {
                    order_by => { -desc => 'product.sku' },
                    rows     => 2,
                    page     => 2
                }
            )->all;
        },
        "get product listing order by sku desc with 2 rows and page 2"
    );

    $expected = [
        {
            discount_percent  => undef,
            inventory         => undef,
            name              => "Trim Brush",
            price             => num(8.99, 0.01),
            average_rating    => 0,
            selling_price     => num(8.99, 0.01),
            short_description => "Trim Brush",
            sku               => "os28005",
            uri               => "trim-brush"
        }
    ];

    cmp_deeply( \@products, $expected, "do we have expected products?" );

    # quantity 10

    lives_ok(
        sub {
            @products = $products->listing({ quantity => 10 })->search( undef,
                { order_by => { -desc => 'product.sku' } } )->all;
        },
        "get product listing { quantity => 10} order by sku desc"
    );

    $expected = [
        {
            discount_percent  => undef,
            inventory         => undef,
            name              => "Disposable Brush Set",
            price             => num(14.99, 0.01),
            average_rating    => 0,
            selling_price     => num(14.99, 0.01),
            short_description => "Disposable Brush Set",
            sku               => "os28007",
            uri               => "disposable-brush-set"
        },
        {
            discount_percent  => 16,
            inventory         => undef,
            name              => "Painters Brush Set",
            price             => num(29.99, 0.01),
            average_rating    => 0,
            selling_price     => num(24.99, 0.01),
            short_description => "Painters Brush Set",
            sku               => "os28006",
            uri               => "painters-brush-set"
        },
        {
            discount_percent  => 5,
            inventory         => undef,
            name              => "Trim Brush",
            price             => num(8.99, 0.01),
            average_rating    => 0,
            selling_price     => num(8.49, 0.01),
            short_description => "Trim Brush",
            sku               => "os28005",
            uri               => "trim-brush"
        }
    ];

    cmp_deeply( \@products, $expected, "do we have expected products?" );

    # user customer1

    my $users_id = $self->users->find({ username => 'customer1' })->id;

    lives_ok(
        sub {
            @products =
              $products->listing( { users_id => $users_id } )
              ->search( undef, { order_by => { -desc => 'product.sku' } } )
              ->all;
        },
        "get product listing { users_id => (id of customer1) }"
    );

    $expected->[2]->{discount_percent} = undef;
    $expected->[2]->{selling_price} = num(8.99, 0.01);

    cmp_deeply( \@products, $expected, "do we have expected products?" );

    # user customer1 & quantity = 10

    lives_ok(
        sub {
            @products =
              $products->listing( { users_id => $users_id, quantity => 10 } )
              ->search( undef, { order_by => { -desc => 'product.sku' } } )
              ->all;
        },
        "get product listing { users_id => (id of customer1), quantity => 10 }"
    );

    # we might get this with or without trailing zero depending on
    # database engine we're testing against
    $expected->[2]->{selling_price} = num(8.20, 0.01);
    $expected->[2]->{discount_percent} = 8;

    cmp_deeply( \@products, $expected, "do we have expected products?" );

    # test average_rating

    lives_ok(
        sub {
            @products = $self->products->search({"product.sku"=>'os28066'},{alias => 'product'})->listing->all;
        },
        "get product listing for just sku os28066"
    );

    $expected = [
        {
            discount_percent  => undef,
            inventory         => undef,
            name              => "Big L Carpenters Square",
            price             => num(14.99, 0.01),
            average_rating    => num(4.3, 0.01),
            selling_price     => num(14.99, 0.01),
            short_description => "Big L Carpenters Square",
            sku               => "os28066",
            uri               => "big-l-carpenters-square"
        },
    ];

    cmp_deeply( \@products, $expected, "do we have expected product?" );

    # TODO: add tier pricing tests
    #$product->tier_pricing([qw/user trade wholesale/]);

    # cleanup
    $rset_pm->delete_all;
    $self->clear_roles;
    $self->clear_price_modifiers;
    $self->clear_products;
};

1;
