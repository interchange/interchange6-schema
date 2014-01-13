use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 3;
use Try::Tiny;
use DBICx::TestDatabase;

my $shop_schema = DBICx::TestDatabase->new('Interchange6::Schema');
my $ret;

# create color attribute
my $color_data = {name => 'color', title => 'Color', type => 'variant',
                  AttributeValue =>
                  [{value => 'black', title => 'Black'},
                   {value => 'white', title => 'White'},
                   {value => 'green', title => 'Green'},
                   {value => 'red', title => 'Red'},
                   {value => 'yellow', title => 'Yellow'},
                   {value => 'pink', title => 'Pink'},
                  ]};


my $color_att = $shop_schema->resultset('Attribute')->create($color_data);

# create size attribute
my $size_data = {name => 'size', title => 'Size', type => 'variant',
                  AttributeValue =>
                  [{value => 'small', title => 'Small'},
                   {value => 'medium', title => 'Medium'},
                   {value => 'large', title => 'Large'},
                              ]};

my $size_att = $shop_schema->resultset('Attribute')->create($size_data);

# create height attribute
my $height_data = {name => 'height', title => 'Height', type => 'specification',
                   AttributeValue =>
                       [{value => '10', title => '10cm'},
                        {value => '20', title => '20cm'},
                    ]};

my $height_att = $shop_schema->resultset('Attribute')->create($height_data);

# create canonical and variants
my $product_data = {sku => 'G0001',
                    name => 'Six Tulips',
                    short_description => 'What says I love you better than 1 dozen fresh roses?',
                    description => 'Surprise the one who makes you smile, or express yourself perfectly with this stunning bouquet of one dozen fresh red roses. This elegant arrangement is a truly thoughtful gift that shows how much you care.',
                    price => '19.95',
                    uri => 'six-tulips',
                    weight => '4',
                    canonical_sku => undef,
                };

my $product = $shop_schema->resultset('Product')->create($product_data)->add_variants(
    {color => 'yellow', size => 'small', sku => 'G0001-YELLOW-S',
     name => 'Six Small Yellow Tulips', uri => 'six-small-yellow-tulips'},
    {color => 'yellow', size => 'large', sku => 'G0001-YELLOW-L',
     name => 'Six Large Yellow Tulips', uri => 'six-large-yellow-tulips'},
     {color => 'pink', size => 'small', sku => 'G0001-PINK-S',
     name => 'Six Small Pink Tulips', uri => 'six-small-pink-tulips'},
    {color => 'pink', size => 'medium', sku => 'G0001-PINK-M',
     name => 'Six Medium Pink Tulips', uri => 'six-medium-pink-tulips'},
    {color => 'pink', size => 'large', sku => 'G0001-PINK-L',
     name => 'Six Large Pink Tulips', uri => 'six-large-pink-tulips'},
    );

isa_ok($product, 'Interchange6::Schema::Result::Product');

$ret = $product->find_variant({color => 'pink',
                                  size => 'medium',
                              });

isa_ok($ret, 'Interchange6::Schema::Result::Product');

ok($ret->sku eq 'G0001-PINK-M', 'Check find_variant result for pink/medium')
    || diag "Result: ", $ret->sku;

