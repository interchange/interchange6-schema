package Test::Navigation;

use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'navigation tests' => sub {

    diag Test::Navigation;

    my $self = shift;

    my ( $navlist, $nav_product );

    my $product = $self->products->first;

    my @path = (
        { name => 'Flowers', uri => 'Flowers' },
        { name => 'Tulips',  uri => 'Flowers/Tulips' },
    );

    lives_ok( sub { $navlist = navigation_make_path( $self->schema, \@path ) },
        "Create navlist" );

    cmp_ok( scalar(@$navlist), '==', 2, "Number of navigation items created." );

    cmp_ok( $navlist->[1]->parent_id,
        '==', $navlist->[0]->id, "Correct parent for second navigation item" );

    lives_ok(
        sub {
            $nav_product =
              $self->schema->resultset('NavigationProduct')
              ->create(
                { navigation_id => $navlist->[1]->id, sku => $product->sku } );
        },
        "Create navigation_product"
    );

    my @product_path = $product->path;

    cmp_ok( scalar(@product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path[0]->uri,
        'eq', 'Flowers', "1st branch URI for product" );

    cmp_ok( $product_path[1]->uri,
        'eq', 'Flowers/Tulips', "2nd branch URI for product" );

    # also check in scalar context

    my $product_path = $product->path;

    cmp_ok( scalar(@$product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path->[0]->uri,
        'eq', 'Flowers', "1st branch URI for product" );

    cmp_ok( $product_path->[1]->uri,
        'eq', 'Flowers/Tulips', "2nd branch URI for product" );

    # add product to country navigation

    @path = (
        {
            name => 'South America',
            uri  => 'South-America',
            type => 'country'
        },
        { name => 'Chile', uri => 'South-America/Chile', type => 'country' },
    );

    lives_ok( sub { $navlist = navigation_make_path( $self->schema, \@path ) },
        "Create country navlist" );

    cmp_ok( scalar(@$navlist), '==', 2,
        "Number of navigation items created for country type." );

    lives_ok(
        sub {
            $nav_product =
              $self->schema->resultset('NavigationProduct')
              ->create(
                { navigation_id => $navlist->[1]->id, sku => $product->sku } );
        },
        "Create navigation_product"
    );

    @product_path = $product->path;

    cmp_ok( scalar(@product_path), '==', 0, "Length of path for product" );

    @product_path = $product->path('country');

    cmp_ok( scalar(@product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path[0]->uri, 'eq', 'South-America',
        "path[0] is correct" );

    cmp_ok( $product_path[1]->uri,
        'eq', 'South-America/Chile', "path[1] is correct" );

    cmp_ok( $self->schema->resultset('Navigation')->count,
        '==', 4, "4 Navigation rows" );

    cmp_ok( $self->schema->resultset('NavigationProduct')->count,
        '==', 2, "2 NavigationProduct rows" );

    lives_ok( sub { $self->schema->resultset('Navigation')->delete_all },
        "delete all Navigation rows" );

    cmp_ok( $self->schema->resultset('Navigation')->count,
        '==', 0, "0 Navigation rows" );

    cmp_ok( $self->schema->resultset('NavigationProduct')->count,
        '==', 0, "0 NavigationProduct rows" );

};

sub navigation_make_path {
    my ( $schema, $path ) = @_;
    my ( $nav, @list );
    my $parent = undef;

    for my $navref (@$path) {
        $nav = $schema->resultset('Navigation')
          ->create( { %$navref, parent_id => $parent } );
        $parent = $nav->id;
        push @list, $nav;
    }

    return \@list;
}

1;
