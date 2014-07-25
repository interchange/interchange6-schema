package Test::BaseAttribute;

use Test::Most;
use Test::Roo::Role;

test 'base attribute tests' => sub {

    diag Test::BaseAttribute;

    my $self = shift;

    my ( $count, %navigation, $product, %size, $meta, $ret, $rset );

    my $schema = $self->schema;

    $navigation{1} = $schema->resultset("Navigation")->create(
        {
            uri         => 'climbing-gear',
            type        => 'menu',
            description => 'Gear for climbing'
        }
    );

    # add Navigation attribute as hashref
    my $nav_attribute = $navigation{1}
      ->add_attribute( { name => 'meta_title' }, 'Find the best rope here.' );

    throws_ok(
        sub { $nav_attribute->find_attribute_value() },
qr/find_attribute_value input requires at least a valid attribute value/,
        "fail find_attribute_value with no arg"
    );

    lives_ok(
        sub { $meta = $nav_attribute->find_attribute_value('meta_title') },
        "find_attribute_value with scalar arg" );

    ok( $meta eq 'Find the best rope here.',
        "Testing  Navigation->add_attribute method with hash." )
      || diag "meta_title: " . $meta;

    lives_ok(
        sub {
            $meta =
              $nav_attribute->find_attribute_value( { name => 'meta_title' } );
        },
        "find_attribute_value with hashref arg"
    );

    ok( $meta eq 'Find the best rope here.',
        "Testing  Navigation->add_attribute method with hash." )
      || diag "meta_title: " . $meta;

    lives_ok( sub { $meta = $nav_attribute->find_attribute_value('FooBar') },
        "find_attribute_value with scalar FooBar" );

    is( $meta, undef, "not found" );

    # add Navigation attribute as scalar
    $nav_attribute = $navigation{1}
      ->add_attribute( 'meta_keyword', 'DBIC, Interchange6, Fun' );

    $meta = $nav_attribute->find_attribute_value('meta_keyword');

    ok( $meta eq 'DBIC, Interchange6, Fun',
        "Testing  Navigation->add_attribute method with scalar." )
      || diag "meta_keyword: " . $meta;

    # update Navigation attribute

    $nav_attribute = $navigation{1}
      ->update_attribute_value( 'meta_title', 'Find the very best rope here!' );

    $meta = $nav_attribute->find_attribute_value('meta_title');

    ok(
        $meta eq 'Find the very best rope here!',
        "Testing  Navigation->add_attribute method."
    ) || diag "meta_title: " . $meta;

    # delete Navigation attribute

    $nav_attribute = $navigation{1}
      ->delete_attribute( 'meta_title', 'Find the very best rope here!' );

    $meta = $nav_attribute->find_attribute_value('meta_title');

    is( $meta, undef, "undefined as expected" );

    lives_ok(
        sub {
            $product = $self->products->find( { sku => 'G0001-YELLOW-S' } );
        },
        "grab G0001-YELLOW-S from product fixtures"
    );

    my $prod_attribute = $product->add_attribute(
        { name => 'child_shirt_size', type => 'menu', title => 'Choose Size' },
        { value => 'S', title => 'Small', priority => '1' }
    );

    my $variant = $prod_attribute->find_attribute_value('child_shirt_size');

    ok( $variant eq 'S', "Testing  Product->add_attribute method." )
      || diag "Attribute child_shirt_size value " . $variant;

    # return a list of all attributes

    my $attr_rs = $product->search_attributes;

    cmp_ok( $attr_rs->count, '==', 3, "Testing search_attributes method." );

    # with search conditions
    $attr_rs = $product->search_attributes( { name => 'color' } );

    cmp_ok( $attr_rs->count, '==', 1,
        "Testing search_attributes method with condition." );

    # with search attributes
    $attr_rs =
      $product->search_attributes( undef, { order_by => 'priority desc' } );

    cmp_ok( $attr_rs->count, '==', 3,
        "Testing search_attributes method with result search attributes" );

    my $attr_name = $attr_rs->next->name;

    cmp_ok( $attr_name, 'eq', 'color',
        "Testing name of first attribute returned" );

    lives_ok(
        sub {
            $navigation{bananas} =
              $schema->resultset("Navigation")
              ->create(
                { uri => 'bananas', type => 'menu', description => 'Bananas' }
              );
        },
        "Create Navigation item"
    );
    my $navigation_id = $navigation{bananas}->navigation_id;

    lives_ok(
        sub {
            $ret = $self->attributes->create(
                { name => 'colour', title => 'Colour' } );
        },
        "Create Attribute"
    );
    my $attributes_id = $ret->attributes_id;

    lives_ok(
        sub {
            $schema->resultset('NavigationAttribute')->create(
                {
                    navigation_id => $navigation_id,
                    attributes_id => $attributes_id,
                }
            );
        },
        "Create NavigationAttribute to link them together"
    );

    lives_ok(
        sub { $ret = $navigation{bananas}->find_attribute_value('colour') },
        "find_attribute_value colour for bananas Navigation item"
    );
    is( $ret, undef, "got undef" );

    throws_ok(
        sub { $navigation{bananas}->find_or_create_attribute() },
qr/Both attribute and attribute value are required for find_or_create_attribute/,
        "Fail find_or_create_attribute with no args"
    );

    throws_ok(
        sub {
            $navigation{bananas}->find_or_create_attribute( 'colour', undef );
        },
qr/Both attribute and attribute value are required for find_or_create_attribute/,
        "Fail find_or_create_attribute with undef value"
    );

    throws_ok(
        sub {
            $navigation{bananas}->find_or_create_attribute( undef, 'colour' );
        },
        qr/Both attribute and attribute value are required for find_or_create/,
        "Fail find_or_create_attribute with value but undef attribute"
    );

    lives_ok(
        sub {
            $navigation{bananas}->find_or_create_attribute( 'fruity', 'yes' );
        },
        "find_or_create_attribute OK for bananas: fruity yes"
    );

    throws_ok( sub { $navigation{bananas}->find_base_attribute_value() },
        qr/Missing/, "Fail find_base_attribute_value with no args" );

    throws_ok(
        sub { $navigation{bananas}->find_base_attribute_value('colour') },
        qr/Missing base name for find_base_attribute_value/,
        "Fail find_base_attribute_value with undef base"
    );

    throws_ok(
        sub {
            $navigation{bananas}
              ->find_base_attribute_value( undef, 'Navigation' );
        },
        qr/Missing attribute object for find_base_attribute_value/,
        "Fail find_base_attribute_value with base but undef attribute"
    );

    # cleanup

    lives_ok( sub { $schema->resultset("Navigation")->delete_all },
        "delete_all from Navigation" );
    lives_ok( sub { $self->clear_products },   "clear_products" );
    lives_ok( sub { $self->clear_attributes }, "clear_attributes" );

};

1;
