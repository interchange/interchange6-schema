use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 5;
use Try::Tiny;
use DBICx::TestDatabase;
use Interchange6::Schema;

my $count;
my %navigation;
my %product;
my %size;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

$navigation{1} = $schema->resultset("Navigation")->create(
    { uri => 'climbing-gear', type => 'menu', description => 'Gear for climbing'}
);

# add Navigation attribute as hashref
my $nav_attribute = $navigation{1}->add_attribute({ name => 'meta_title'}, 'Find the best rope here.');

my $meta = $nav_attribute->find_attribute_value('meta_title');

ok($meta eq 'Find the best rope here.', "Testing  Navigation->add_attribute method with hash.")
    || diag "meta_title: " . $meta;

# add Navigation attribute as scaler
$nav_attribute = $navigation{1}->add_attribute('meta_keyword', 'DBIC, Interchange6, Fun');

$meta = $nav_attribute->find_attribute_value('meta_keyword');

ok($meta eq 'DBIC, Interchange6, Fun', "Testing  Navigation->add_attribute method with scaler.")
    || diag "meta_keyword: " . $meta;

# update Navigation attribute

$nav_attribute = $navigation{1}->update_attribute('meta_title','Find the very best rope here!');

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
