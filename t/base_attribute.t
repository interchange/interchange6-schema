use strict;
use warnings;

use Data::Dumper;
use Test::Most tests => 24;
use DBICx::TestDatabase;
use Interchange6::Schema;

my ( $count, %navigation, %product, %size, $meta, $ret, $rset );

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

$navigation{1} = $schema->resultset("Navigation")->create(
    { uri => 'climbing-gear', type => 'menu', description => 'Gear for climbing'}
);

# add Navigation attribute as hashref
my $nav_attribute = $navigation{1}->add_attribute({ name => 'meta_title'}, 'Find the best rope here.');

throws_ok ( sub { $nav_attribute->find_attribute_value()},
    qr/find_attribute_value input requires at least a valid attribute value/,
    "fail find_attribute_value with no arg"
);

lives_ok( sub { $meta = $nav_attribute->find_attribute_value('meta_title')},
    "find_attribute_value with scalar arg"
);

ok($meta eq 'Find the best rope here.', "Testing  Navigation->add_attribute method with hash.")
    || diag "meta_title: " . $meta;

lives_ok( sub {$meta = $nav_attribute->find_attribute_value({ name => 'meta_title'})},
    "find_attribute_value with hashref arg"
);

ok($meta eq 'Find the best rope here.', "Testing  Navigation->add_attribute method with hash.")
    || diag "meta_title: " . $meta;

lives_ok( sub { $meta = $nav_attribute->find_attribute_value('FooBar')},
    "find_attribute_value with scalar FooBar"
);

is($meta, undef, "not found");

# add Navigation attribute as scaler
$nav_attribute = $navigation{1}->add_attribute('meta_keyword', 'DBIC, Interchange6, Fun');

$meta = $nav_attribute->find_attribute_value('meta_keyword');

ok($meta eq 'DBIC, Interchange6, Fun', "Testing  Navigation->add_attribute method with scaler.")
    || diag "meta_keyword: " . $meta;

# update Navigation attribute

$nav_attribute = $navigation{1}->update_attribute_value('meta_title','Find the very best rope here!');

$meta = $nav_attribute->find_attribute_value('meta_title');

ok($meta eq 'Find the very best rope here!', "Testing  Navigation->add_attribute method.")
    || diag "meta_title: " . $meta;

# delete Navigation attribute

$nav_attribute =  $navigation{1}->delete_attribute('meta_title', 'Find the very best rope here!');

$meta = $nav_attribute->find_attribute_value('meta_title');

is($meta, undef, "undefined as expected");

$product{IC6001} = $schema->resultset("Product")->create(
    { sku => 'IC6001', name => 'Ice Axe', description => 'ACME Ice Axe', price => '225.00', uri => 'acme-ice-axe'}
);

#add Product variants
my $prod_attribute  = $product{IC6001}->add_attribute({ name => 'child_shirt_size', type => 'menu', title =>'Choose Size'}, 
                                                            { value => 'S', title => 'Small', priority => '1' });

my $variant = $prod_attribute->find_attribute_value('child_shirt_size');

ok($variant eq 'S', "Testing  Product->add_attribute method.")
    || diag "Attribute child_shirt_size value " . $variant;

# return a list of all attributes

$nav_attribute = $navigation{1}->add_attribute({name =>'js_head', priority => '1'}, '/js/mysuper.js');

my $attr_rs = $navigation{1}->search_attributes;

ok($attr_rs->count eq '2', "Testing search_attributes method.")
    || diag "Total attributes" . $attr_rs->count;

lives_ok( sub { $navigation{bananas} = $schema->resultset("Navigation")->create(
    { uri => 'bananas', type => 'menu', description => 'Bananas'})},
    "Create Navigation item"
);
my $navigation_id = $navigation{bananas}->navigation_id;

lives_ok( sub { $ret = $schema->resultset("Attribute")->create(
    { name => 'colour', title => 'Colour'})},
    "Create Attribute"
);
my $attributes_id = $ret->attributes_id;

lives_ok( sub { $schema->resultset('NavigationAttribute')->create(
            {
                navigation_id => $navigation_id,
                attributes_id => $attributes_id,
            }
        )},
    "Create NavigationAttribute to link them together"
);

lives_ok( sub { $ret = $navigation{bananas}->find_attribute_value('colour') },
    "find_attribute_value colour for bananas Navigation item"
);
is( $ret, undef, "got undef");

throws_ok( sub { $navigation{bananas}->find_or_create_attribute() },
    qr/Both attribute and attribute value are required for find_or_create_attribute/,
    "Fail find_or_create_attribute with no args"
);

throws_ok( sub { $navigation{bananas}->find_or_create_attribute('colour', undef) },
    qr/Both attribute and attribute value are required for find_or_create_attribute/,
    "Fail find_or_create_attribute with undef value"
);

throws_ok( sub { $navigation{bananas}->find_or_create_attribute(undef, 'colour') },
    qr/Both attribute and attribute value are required for find_or_create/,
    "Fail find_or_create_attribute with value but undef attribute"
);

lives_ok( sub { $navigation{bananas}->find_or_create_attribute('fruity', 'yes') },
    "find_or_create_attribute OK for bananas: fruity yes"
);

throws_ok( sub { $navigation{bananas}->find_base_attribute_value() },
    qr/Missing/,
    "Fail find_base_attribute_value with no args"
);

throws_ok( sub { $navigation{bananas}->find_base_attribute_value('colour') },
    qr/Missing base name for find_base_attribute_value/,
    "Fail find_base_attribute_value with undef base"
);

throws_ok( sub { $navigation{bananas}->find_base_attribute_value(undef, 'Navigation') },
    qr/Missing attribute object for find_base_attribute_value/,
    "Fail find_base_attribute_value with base but undef attribute"
);
