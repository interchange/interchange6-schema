package Test::Navigation;

use Test::Exception;
use Test::Roo::Role;

test 'navigation tests' => sub {

    diag Test::Navigation;

    my $self = shift;

    # prereqs
    $self->navigation unless $self->has_navigation;

    my ( $nav, $navlist, $nav_product );

    my $product = $self->products->find('os28077');

    my @product_path = $product->path;

    cmp_ok( scalar(@product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path[0]->uri,
        'eq', 'tool-storage', "1st branch URI for product" );

    cmp_ok( $product_path[1]->uri,
        'eq', 'tool-storage/tool-belts', "2nd branch URI for product" );

    cmp_ok(
        $product_path[1]->parent_id,
        '==',
        $product_path[0]->id,
        "Correct parent for second navigation item"
    );

    # also check in scalar context

    my $product_path = $product->path;

    cmp_ok( scalar(@$product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path->[0]->uri,
        'eq', 'tool-storage', "1st branch URI for product" );

    cmp_ok( $product_path->[1]->uri,
        'eq', 'tool-storage/tool-belts', "2nd branch URI for product" );

    # add product to country navigation

    my @path = (
        {
            name => 'South America',
            uri  => 'South-America',
            type => 'country'
        },
        { name => 'Chile', uri => 'South-America/Chile', type => 'country' },
    );

    lives_ok( sub { $navlist = navigation_make_path( $self->ic6s_schema, \@path ) },
        "Create country navlist" );

    cmp_ok( scalar(@$navlist), '==', 2,
        "Number of navigation items created for country type." );

    lives_ok(
        sub {
            $nav_product =
              $self->ic6s_schema->resultset('NavigationProduct')
              ->create(
                { navigation_id => $navlist->[1]->id, sku => $product->sku } );
        },
        "Create navigation_product"
    );

    # we should get the primary path since fixtures sets higher prio for this

    @product_path = $product->path;

    cmp_ok( scalar(@product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path[0]->uri,
        'eq', 'tool-storage', "1st branch URI for product" );

    # now the country path

    @product_path = $product->path('country');

    cmp_ok( scalar(@product_path), '==', 2, "Length of path for product" );

    cmp_ok( $product_path[0]->uri, 'eq', 'South-America',
        "path[0] is correct" );

    cmp_ok( $product_path[1]->uri,
        'eq', 'South-America/Chile', "path[1] is correct" );

    lives_ok(
        sub {
            $nav = $self->navigation->find( { uri => 'hand-tools/hammers' } );
        },
        "find nav hand-tools/hammers"
    );

    cmp_ok( $nav->siblings->count, "==", 8, "nav has 8 siblings" );

    cmp_ok( $nav->siblings_with_self->count, "==", 9,
        "9 siblings with self" );

    # cleanup
    $self->clear_navigation;
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
