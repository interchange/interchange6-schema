package Test::Variant;

use Test::Deep;
use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'variant tests' => sub {

    diag Test::Variant;

    my $self = shift;

    my ( $product, $data, $ret, $rset, $result );

    my $shop_schema = $self->ic6s_schema;

    lives_ok(
        sub {
            $product = $self->products->find( { sku => 'os28066' } );
        },
        "find product os28066"
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

    ok( $ret == 6, 'Number of variants' ) || diag "count: $ret.";

    $ret = $product->find_variant(
        {
            handle => 'ebony',
            blade  => 'plastic',
        }
    );

    isa_ok( $ret, 'Interchange6::Schema::Result::Product' );

    ok( $ret->sku eq 'os28066-E-P',
        'Check find_variant result for ebony/plastic' )
      || diag "Result: ", $ret->sku;

    # find_variant against variant should go via canonical

    lives_ok(
        sub {
            $ret =
              $ret->find_variant( { handle => 'wood', blade => 'steel', } );
        },
        "find_variant on a variant"
    );

    isa_ok( $ret, 'Interchange6::Schema::Result::Product' );

    cmp_ok( $ret->sku, 'eq', 'os28066-W-S', 'got same variant back' );

    # call find_variant without input
    my %match_info;

    $ret = $product->find_variant(
        {
            handle => undef,
            blade  => undef,
        },
        \%match_info
    );

    ok( !defined $ret, 'Check find_variant result without input.' );

    my $expected = {
        'os28066-E-P' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-E-S' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-E-T' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-W-P' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-W-S' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-W-T' => {
            handle => 0,
            blade  => 0,
        },
    };

    is_deeply( \%match_info, $expected, "Check match information" );

    # find missing variant
    $ret = $product->find_variant(
        {
            handle => 'banana',
            blade  => 'steel',
        },
        \%match_info
    );

    ok( !defined $ret,
        'Check find_variant result for missing variant banana/steel' )
      || diag "Result: ", $ret;

    $expected = {
        'os28066-E-P' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-E-S' => {
            handle => 0,
            blade  => 1,
        },
        'os28066-E-T' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-W-P' => {
            handle => 0,
            blade  => 0,
        },
        'os28066-W-S' => {
            handle => 0,
            blade  => 1,
        },
        'os28066-W-T' => {
            handle => 0,
            blade  => 0,
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
        ref( $ret->[0] ) eq 'HASH' && $ret->[0]->{name} eq 'handle',
        "handle is first record in attribute_iterator"
    ) || diag "Name in first record: ", $ret->[0]->{name};

    ok(
        ref( $ret->[1] ) eq 'HASH' && $ret->[1]->{name} eq 'blade',
        "blade is second record in attribute_iterator"
    ) || diag "Name in second record: ", $ret->[1]->{name};

    # checking Color and Size records
    my $handles_record = $ret->[0]->{attribute_values};
    my $blades_record  = $ret->[1]->{attribute_values};

    ok( ref($handles_record) eq 'ARRAY' && @$handles_record == 2,
        "Number of records in handles iterator" ) or diag scalar @$handles_record;

    ok( ref($blades_record) eq 'ARRAY' && @$blades_record == 3,
        "Number of records in blades iterator" ) or diag scalar @$blades_record;

    # attribute_iterator with hashref => 1 TODO

    # jeff_b comment on GH#86
    # Similarly, I found a need for something that would retrieve all product
    # attribute values for a multi-valued attribute. ...

    my $count = $self->products->count;

    $data = {
        sku                => "922",
        name               => "sku 922",
        description        => "product with sku 922",
        product_attributes => [
            {
                attribute => {
                    name             => "video_url",
                    attribute_values => [
                        {
                            value =>
                              'http://www.youtube.com/watch?v=q57Kgb-oyfQ',
                            priority => 1,
                        },
                        {
                            value =>
                              'http://www.youtube.com/watch?v=binmsZ0eQEg',
                            priority => 0,
                        },
                    ],
                },
            },
        ],
    };

    lives_ok( sub { $product = $self->products->create($data); },
        "Create product with sku 922" );

    $count++;
    cmp_ok( $self->products->count, '==', $count, "$count Products" );

    $data = {
        sku                => "123",
        name               => "sku 123",
        description        => "product with sku 123",
        product_attributes => [
            {
                attribute => {
                    name             => "video_url",
                    attribute_values => [
                        {
                            value =>
                              'http://www.youtube.com/watch?v=q57Kgb-111',
                            priority => 2,
                        },
                        {
                            value =>
                              'http://www.youtube.com/watch?v=binmsZ0-222',
                            priority => 3,
                        },
                    ],
                },
            },
        ],
    };

    lives_ok( sub { $self->products->create($data); },
        "Create product with sku 123" );

    $count++;
    cmp_ok( $self->products->count, '==', $count, "$count Products" );

    lives_ok(
        sub {
            $rset =
              $product->product_attributes->search_related(
                "attribute",
                { name => "video_url" },
              )->first->search_related(
                "attribute_values",
                undef,
                { order_by => { -asc => "priority" } }
              )
        },
        "fetch attribute values for product attribute name video_url"
    );

    cmp_ok( $rset->count, '==', 2, "2 results found" );

    lives_ok( sub { $result = $rset->next }, "get 1st result" );

    cmp_ok( $result->value, 'eq', 'http://www.youtube.com/watch?v=binmsZ0eQEg',
        "value of 1st result is correct" );

    cmp_ok( $result->priority, '==', 0, "priority of 1st result is correct" );

    lives_ok( sub { $result = $rset->next }, "get 2nd result" );

    cmp_ok( $result->value, 'eq', 'http://www.youtube.com/watch?v=q57Kgb-oyfQ',
        "value of 2nd result is correct" );

    cmp_ok( $result->priority, '==', 1, "priority of 2nd result is correct" );

    # cleanup
    lives_ok( sub { $self->clear_products },   "clear_products" );
    lives_ok( sub { $self->clear_attributes }, "clear_attributes" );
};

1;
