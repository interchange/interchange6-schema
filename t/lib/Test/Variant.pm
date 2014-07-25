package Test::Variant;

use Test::Deep;
use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'variant tests' => sub {

    diag Test::Variant;

    my $self = shift;

    my ( $product, $data, $ret );

    my $shop_schema = $self->schema;

    lives_ok(
        sub {
            $product =
              $self->products->search( { canonical_sku => undef } )->first;
        },
        "find a canonical product"
    );

    throws_ok(
        sub { $product->add_variants( { color => 'red' } ) },
        qr/SKU missing in input for add_variants./,
        "Fail add_variants with missing sku"
    );

    throws_ok(
        sub { $product->add_variants( { color => 'red', sku => undef } ) },
        qr/SKU missing in input for add_variants./,
        "Fail add_variants with undef sku"
    );

    throws_ok(
        sub {
            $product->add_variants(
                { fruit => 'banana', sku => 'G0001-YELLOW-S' } );
        },
        qr/Missing variant attribute 'fruit' for SKU G0001-YELLOW-S/,
        "Fail to add with bad attribute fruit"
    );

    throws_ok(
        sub {
            $product->add_variants(
                { color => 'orange', sku => 'G0001-YELLOW-S' } );
        },
        qr/Missing variant attribute value 'orange' for attribute 'color'/,
        "Fail to add with bad color value orange"
    );

    lives_ok(
        sub {
            $ret = $self->attributes->create(
                { name => 'color', title => 'Color', type => 'variant' } );
        },
        "Add color attribute a second time"
    );

    throws_ok(
        sub {
            $product->add_variants(
                { color => 'pink', sku => 'G0001-YELLOW-S' } );
        },
        qr/Ambigious variant attribute 'color' for SKU G0001-YELLOW-S/,
        "Fail add_variant now that color attributes exists twice"
    );

    lives_ok( sub { $ret->delete }, "Delete duplicate color attribute" );

    $ret = $product->variants->count;

    ok( $ret == 5, 'Number of variants' )
      || diag "count: $ret.";

    $ret = $product->find_variant(
        {
            color => 'pink',
            size  => 'medium',
        }
    );

    isa_ok( $ret, 'Interchange6::Schema::Result::Product' );

    ok( $ret->sku eq 'G0001-PINK-M',
        'Check find_variant result for pink/medium' )
      || diag "Result: ", $ret->sku;

    # find_variant against variant should go via canonical

    lives_ok(
        sub {
            $ret = $ret->find_variant( { color => 'pink', size => 'medium', } );
        },
        "find_variant on a variant"
    );

    isa_ok( $ret, 'Interchange6::Schema::Result::Product' );

    cmp_ok( $ret->sku, 'eq', 'G0001-PINK-M', 'got same variant back' );

    # call find_variant without input
    my %match_info;

    $ret = $product->find_variant(
        {
            color => undef,
            size  => undef,
        },
        \%match_info
    );

    ok( !defined $ret, 'Check find_variant result without input.' );

    my $expected = {
        'G0001-PINK-M' => {
            'color' => 0,
            'size'  => 0
        },
        'G0001-YELLOW-S' => {
            'size'  => 0,
            'color' => 0
        },
        'G0001-PINK-L' => {
            'size'  => 0,
            'color' => 0
        },
        'G0001-PINK-S' => {
            'color' => 0,
            'size'  => 0
        },
        'G0001-YELLOW-L' => {
            'color' => 0,
            'size'  => 0
        }
    };

    is_deeply( \%match_info, $expected, "Check match information" );

    # find missing variant
    $ret = $product->find_variant(
        {
            color => 'yellow',
            size  => 'medium',
        },
        \%match_info
    );

    ok( !defined $ret,
        'Check find_variant result for missing variant yellow/medium' )
      || diag "Result: ", $ret;

    # check contents of match info
    $expected = {
        'G0001-PINK-L' => {
            'color' => 0,
            'size'  => 0
        },
        'G0001-YELLOW-L' => {
            'color' => 1,
            'size'  => 0
        },
        'G0001-YELLOW-S' => {
            'size'  => 0,
            'color' => 1
        },
        'G0001-PINK-S' => {
            'color' => 0,
            'size'  => 0
        },
        'G0001-PINK-M' => {
            'size'  => 1,
            'color' => 0
        },
    };

    is_deeply( \%match_info, $expected, "Check match information" );

    $ret = $product->attribute_iterator;

    # expecting two records, first Color and second Size
    ok(
        ref($ret) eq 'ARRAY' && @$ret == 2,
        "Number of records in attribute iterator"
    ) || diag "Results: $ret";

    ok(
        ref( $ret->[0] ) eq 'HASH' && $ret->[0]->{name} eq 'color',
        "Color is first record in attribute_iterator"
    ) || diag "Name in first record: ", $ret->[0]->{name};

    ok(
        ref( $ret->[1] ) eq 'HASH' && $ret->[1]->{name} eq 'size',
        "Size is second record in attribute_iterator"
    ) || diag "Name in second record: ", $ret->[1]->{name};

    # checking Color and Size records
    my $colors_record = $ret->[0]->{attribute_values};
    my $sizes_record  = $ret->[1]->{attribute_values};

    ok( ref($colors_record) eq 'ARRAY' && @$colors_record == 2,
        "Number of records in colors iterator" );

    ok(
        $colors_record->[0]->{value} eq 'pink'
          && $colors_record->[1]->{value} eq 'yellow',
        "Order of records in colors iterator"
    );

    ok( ref($sizes_record) eq 'ARRAY' && @$sizes_record == 3,
        "Number of records in sizes iterator" );

    ok(
        $sizes_record->[0]->{value} eq 'small'
          && $sizes_record->[1]->{value} eq 'medium'
          && $sizes_record->[2]->{value} eq 'large',
        "Order of records in sizes iterator"
    );

    # attribute_iterator with hashref => 1

    lives_ok( sub { $ret = $product->attribute_iterator( hashref => 1 ) },
        "attribute_iterator with hashref => 1" );

    cmp_ok( ref($ret), 'eq', 'HASH', "Got a hashref" );
    cmp_deeply(
        $ret,
        {
            color => {
                name             => 'color',
                title            => 'Color',
                priority         => 2,
                attribute_values => bag(
                    {
                        value    => 'pink',
                        title    => 'Pink',
                        selected => 0,
                        priority => 2,
                    },
                    {
                        value    => 'yellow',
                        title    => 'Yellow',
                        selected => 0,
                        priority => 1,
                    },
                ),
            },
            size => {
                name             => 'size',
                title            => 'Size',
                priority         => 1,
                attribute_values => bag(
                    {
                        value    => 'small',
                        title    => 'Small',
                        selected => 0,
                        priority => 2,
                    },
                    {
                        value    => 'medium',
                        title    => 'Medium',
                        selected => 0,
                        priority => 1,
                    },
                    {
                        value    => 'large',
                        title    => 'Large',
                        selected => 0,
                        priority => 0,
                    },
                ),
            },
        },
        "Deep comparison is good"
    );

    # test selected
    my $variant = $product->find_variant(
        {
            color => 'yellow',
            size  => 'large',
        }
    );

    isa_ok( $variant, 'Interchange6::Schema::Result::Product' );

    ok(
        $variant->sku eq 'G0001-YELLOW-L',
        'Check find_variant result for pink/medium'
    ) || diag "Result: ", $ret->sku;

    $ret           = $variant->attribute_iterator;
    $colors_record = $ret->[0]->{attribute_values};
    $sizes_record  = $ret->[1]->{attribute_values};

    ok( ref($colors_record) eq 'ARRAY' && @$colors_record == 2,
        "Number of records in colors iterator" );

    ok(
        $colors_record->[0]->{value} eq 'pink'
          && $colors_record->[1]->{value} eq 'yellow',
        "Order of records in colors iterator"
    );

    ok(
        $colors_record->[0]->{selected} eq '0'
          && $colors_record->[1]->{selected} eq '1',
        "Value of selected in colors iterator"
    );

    ok( ref($sizes_record) eq 'ARRAY' && @$sizes_record == 3,
        "Number of records in sizes iterator" );

    ok(
        $sizes_record->[0]->{value} eq 'small'
          && $sizes_record->[1]->{value} eq 'medium'
          && $sizes_record->[2]->{value} eq 'large',
        "Order of records in sizes iterator"
    );

    ok(
        $sizes_record->[0]->{selected} eq '0'
          && $sizes_record->[1]->{selected} eq '0'
          && $sizes_record->[2]->{selected} eq '1',
        "Value of selected in sizes iterator"
    );

    # cleanup
    lives_ok( sub { $self->clear_products },   "clear_products" );
    lives_ok( sub { $self->clear_attributes }, "clear_attributes" );
};

1;
