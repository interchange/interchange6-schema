package Test::Variant;

use Data::Dumper;
use Test::Most;
use Test::Roo::Role;

test 'variant tests' => sub {
    my $self = shift;

    my ( $data, $ret );

    my $shop_schema = $self->schema;

    # create color attribute
    my $color_data = {
        name             => 'color',
        title            => 'Color',
        type             => 'variant',
        priority         => 2,
        attribute_values => [
            { value => 'black',  title => 'Black' },
            { value => 'white',  title => 'White' },
            { value => 'green',  title => 'Green' },
            { value => 'red',    title => 'Red' },
            { value => 'yellow', title => 'Yellow', priority => 1 },
            { value => 'pink',   title => 'Pink', priority => 2 },
        ]
    };

    my $color_att = $shop_schema->resultset('Attribute')->create($color_data);

    # create size attribute
    my $size_data = {
        name             => 'size',
        title            => 'Size',
        type             => 'variant',
        priority         => 1,
        attribute_values => [
            { value => 'small',  title => 'Small',  priority => 2 },
            { value => 'medium', title => 'Medium', priority => 1 },
            { value => 'large',  title => 'Large',  priority => 0 },
        ]
    };

    my $size_att = $shop_schema->resultset('Attribute')->create($size_data);

    # create height attribute
    my $height_data = {
        name             => 'height',
        title            => 'Height',
        type             => 'specification',
        attribute_values => [
            { value => '10', title => '10cm' },
            { value => '20', title => '20cm' },
        ]
    };

    my $height_att = $shop_schema->resultset('Attribute')->create($height_data);

    # create canonical and variants
    my $product_data = {
        sku  => 'G0001',
        name => 'Six Tulips',
        short_description =>
          'What says I love you better than 1 dozen fresh roses?',
        description =>
'Surprise the one who makes you smile, or express yourself perfectly with this stunning bouquet of one dozen fresh red roses. This elegant arrangement is a truly thoughtful gift that shows how much you care.',
        price         => '19.95',
        uri           => 'six-tulips',
        weight        => '4',
        canonical_sku => undef,
    };

    my $product =
      $shop_schema->resultset('Product')->create($product_data)->add_variants(
        {
            color => 'yellow',
            size  => 'small',
            sku   => 'G0001-YELLOW-S',
            name  => 'Six Small Yellow Tulips',
            uri   => 'six-small-yellow-tulips'
        },
        {
            color => 'yellow',
            size  => 'large',
            sku   => 'G0001-YELLOW-L',
            name  => 'Six Large Yellow Tulips',
            uri   => 'six-large-yellow-tulips'
        },
        {
            color => 'pink',
            size  => 'small',
            sku   => 'G0001-PINK-S',
            name  => 'Six Small Pink Tulips',
            uri   => 'six-small-pink-tulips'
        },
        {
            color => 'pink',
            size  => 'medium',
            sku   => 'G0001-PINK-M',
            name  => 'Six Medium Pink Tulips',
            uri   => 'six-medium-pink-tulips'
        },
        {
            color => 'pink',
            size  => 'large',
            sku   => 'G0001-PINK-L',
            name  => 'Six Large Pink Tulips',
            uri   => 'six-large-pink-tulips'
        },
      );

    isa_ok( $product, 'Interchange6::Schema::Result::Product' );

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
            $ret =
              $shop_schema->resultset('Attribute')
              ->create(
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

    my $imagetype =
      $shop_schema->resultset('MediaType')->create( { type => 'image' } );

    $product->add_to_media(
        {
            file       => 'product/image.jpg',
            uri        => 'image.jpg',
            mime_type  => 'image/jpeg',
            media_type => { type => 'image' },
        }
    );

    my @media = $product->media;
    ok( @media == 1, "Found the media" );
    is $media[0]->uri, 'image.jpg', "found the image";
    ok $media[0]->media_id, "found the primary key";

    # test the other way around
    is $media[0]->products->first->sku, 'G0001',
      "found via ->products->first->sku";

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
        "Number of records in colors iterator" )
      || diag "Results: ", Dumper($colors_record);

    ok(
        $colors_record->[0]->{value} eq 'pink'
          && $colors_record->[1]->{value} eq 'yellow',
        "Order of records in colors iterator"
      )
      || diag "Results: ", Dumper($colors_record);

    ok( ref($sizes_record) eq 'ARRAY' && @$sizes_record == 3,
        "Number of records in sizes iterator" )
      || diag "Results: ", Dumper($sizes_record);

    ok(
        $sizes_record->[0]->{value} eq 'small'
          && $sizes_record->[1]->{value} eq 'medium'
          && $sizes_record->[2]->{value} eq 'large',
        "Order of records in sizes iterator"
      )
      || diag "Results: ", Dumper($sizes_record);

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
        "Number of records in colors iterator" )
      || diag "Results: ", Dumper($colors_record);

    ok(
        $colors_record->[0]->{value} eq 'pink'
          && $colors_record->[1]->{value} eq 'yellow',
        "Order of records in colors iterator"
      )
      || diag "Results: ", Dumper($colors_record);

    ok(
        $colors_record->[0]->{selected} eq '0'
          && $colors_record->[1]->{selected} eq '1',
        "Value of selected in colors iterator"
      )
      || diag "Results: ", Dumper($colors_record);

    ok( ref($sizes_record) eq 'ARRAY' && @$sizes_record == 3,
        "Number of records in sizes iterator" )
      || diag "Results: ", Dumper($sizes_record);

    ok(
        $sizes_record->[0]->{value} eq 'small'
          && $sizes_record->[1]->{value} eq 'medium'
          && $sizes_record->[2]->{value} eq 'large',
        "Order of records in sizes iterator"
      )
      || diag "Results: ", Dumper($sizes_record);

    ok(
        $sizes_record->[0]->{selected} eq '0'
          && $sizes_record->[1]->{selected} eq '0'
          && $sizes_record->[2]->{selected} eq '1',
        "Value of selected in sizes iterator"
      )
      || diag "Results: ", Dumper($sizes_record);

};

1;
