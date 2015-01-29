package Test::Product;
use utf8;

use Test::Deep;
use Test::Exception;
use Test::Roo::Role;

test 'product tests' => sub {

    diag 'Test::Product';

    my $self = shift;

    my $schema = $self->ic6s_schema;

    my $products = $schema->resultset('Product');

    my ( $product, $result, $i );

    # generate_uri

    my %data = (
        "I can eat glass and it doesn't hurt me" =>
          "I-can-eat-glass-and-it-doesn't-hurt-me",
'Μπορώ να φάω σπασμένα γυαλιά χωρίς να πάθω τίποτα'
          => 'Μπορώ-να-φάω-σπασμένα-γυαλιά-χωρίς-να-πάθω-τίποτα',
        'aɪ kæn iːt glɑːs ænd ɪt dɐz nɒt hɜːt miː' =>
          'aɪ-kæn-iːt-glɑːs-ænd-ɪt-dɐz-nɒt-hɜːt-miː',
'ᛖᚴ ᚷᛖᛏ ᛖᛏᛁ ᚧ ᚷᛚᛖᚱ ᛘᚾ ᚦᛖᛋᛋ ᚨᚧ ᚡᛖ ᚱᚧᚨ ᛋᚨᚱ'
          => 'ᛖᚴ-ᚷᛖᛏ-ᛖᛏᛁ-ᚧ-ᚷᛚᛖᚱ-ᛘᚾ-ᚦᛖᛋᛋ-ᚨᚧ-ᚡᛖ-ᚱᚧᚨ-ᛋᚨᚱ',
'私はガラスを食べられます。 それは私を傷つけません'
          => '私はガラスを食べられます。-それは私を傷つけません',
        '  banana  apple '                     => 'banana-apple-',
        '  /  //  banana  / ///   / apple  / ' => '-banana-apple-',
    );

    use Encode;
    my $sku = 1;
    foreach my $key ( keys %data ) {

        lives_ok(
            sub {
                $product =
                  $products->create(
                    { name => $key, sku => ++$sku, description => '' } );
            },
            "create product for name: " . Encode::encode_utf8($key)
        );

        lives_ok( sub { $product->get_from_storage }, "refetch nav from db" );

        cmp_ok(
            $product->uri, 'eq',
            $data{$key} . "-$sku",
            "uri is set correctly"
        );
    }

    lives_ok(
        sub {
            $result = $schema->resultset('Setting')->create(
                {
                    scope => 'Product',
                    name  => 'generate_uri_filter',
                    value => '$uri =~ s/[abc]/X/g',
                }
            );
        },
        'add filter to Setting: $uri =~ s/[abc]/X/g'
    );

    lives_ok(
        sub {
            $product = $products->create(
                {
                    name        => 'one banana and a carrot',
                    sku         => '1001',
                    description => ''
                }
            );
        },
        "create nav with name: one banana and a carrot"
    );

    lives_ok( sub { $product->get_from_storage }, "refetch nav from db" );

    cmp_ok(
        $product->uri, 'eq',
        'one-XXnXnX-Xnd-X-XXrrot-1001',
        "uri is: one-XXnXnX-Xnd-X-XXrrot-1001"
    );

    lives_ok( sub { $result->delete }, "remove filter" );

    lives_ok(
        sub {
            $result = $schema->resultset('Setting')->create(
                {
                    scope => 'Product',
                    name  => 'generate_uri_filter',
                    value => '$uri = lc($uri)',
                }
            );
        },
        'add filter to Setting: $uri = lc($uri)'
    );

    lives_ok(
        sub {
            $product = $products->create(
                {
                    name        => 'One BANANA and a carrot',
                    sku         => '1002',
                    description => ''
                }
            );
        },
        "create nav with name: One BANANA and a carrot"
    );

    lives_ok( sub { $product->get_from_storage }, "refetch nav from db" );

    cmp_ok(
        $product->uri, 'eq',
        'one-banana-and-a-carrot-1002',
        "uri is: one-banana-and-a-carrot-1002"
    );

    lives_ok( sub { $result->delete }, "remove filter" );

    lives_ok(
        sub {
            $result = $schema->resultset('Setting')->create(
                {
                    scope => 'Product',
                    name  => 'generate_uri_filter',
                    value => '$uri =',
                }
            );
        },
        'add broken filter to Setting: $uri ='
    );

    throws_ok(
        sub {
            $product = $products->create(
                {
                    name        => 'One BANANA and a carrot',
                    sku         => '1003',
                    description => ''
                }
            );
        },
        qr/Product->generate_uri filter croaked/,
        "generate_uri should croak"
    );

    lives_ok( sub { $result->delete }, "remove filter" );

    # reset products fixture and make sure we have modifiers
    $self->clear_products;
    $self->price_modifiers unless $self->has_price_modifiers;

    my $num_products = $self->products->count;

    # average_rating

    lives_ok( sub { $products = $self->products->with_average_rating },
        "get products with_average_rating" );

    cmp_ok( $products->count, '==', $num_products, "$num_products products" );

    # test on simple products rset and also with_average_rating
    $i = 0;
    foreach my $rset ( $self->products, $products ) {

        lives_ok( sub { $product = $rset->find('os28066') },
            "find product os28066" );

        isa_ok(
            $product,
            "Interchange6::Schema::Result::Product",
            "we have a Product"
        );

        cmp_ok( $product->has_column_loaded('average_rating'),
            '==', $i, "product has_column_loaded average_rating == $i" );

        cmp_ok( $product->average_rating, '==', 4.3, "average_rating is 4.3" );
        cmp_ok( $product->average_rating(2),
            '==', 4.27, "average_rating to 2 DP is 4.27" );

        lives_ok( sub { $product = $rset->find('os28066-E-P') },
            "find product os28066-E-P" );

        isa_ok(
            $product,
            "Interchange6::Schema::Result::Product",
            "we have a Product"
        );

        cmp_ok( $product->has_column_loaded('average_rating'),
            '==', $i, "product has_column_loaded average_rating == $i" );

        cmp_ok( $product->average_rating, '==', 4.3, "average_rating is 4.3" );
        cmp_ok( $product->average_rating(2),
            '==', 4.27, "average_rating to 2 DP is 4.27" );

        $i = 1;
    }

    # quantity_in_stock

    lives_ok( sub { $products = $self->products->with_quantity_in_stock },
        "get products with_quantity_in_stock" );

    cmp_ok( $products->count, '==', $num_products, "$num_products products" );

    # lowest_selling_price

    lives_ok( sub { $products = $self->products->with_lowest_selling_price },
        "get products with_lowest_selling_price" );

    cmp_ok( $products->count, '==', $num_products, "$num_products products" );

    lives_ok( sub { $product = $products->find('os28006') },
        "get product os28006" );

    cmp_deeply( $product->price, num(29.99, 0.01), "price is 29.99" );

    cmp_deeply(
        $product->selling_price,
        num( 24.99, 0.01 ),
        "selling_price is 24.99"
    );

    lives_ok( sub { $product = $products->find('os28085') },
        "get product os28085" );

    cmp_deeply( $product->price, num(36.99, 0.01), "price is 36.99" );

    cmp_deeply(
        $product->selling_price,
        num( 34.99, 0.01 ),
        "selling_price is 34.99"
    );

    # variant_count

    lives_ok( sub { $products = $self->products->with_variant_count },
        "get products with_variant_count" );

    cmp_ok( $products->count, '==', $num_products, "$num_products products" );

    # test on simple products rset and also with_variant_count
    $i = 0;
    foreach my $rset ( $self->products, $products ) {

        lives_ok( sub { $product = $rset->find('os28085') },
            "get product os28085" );

        isa_ok(
            $product,
            "Interchange6::Schema::Result::Product",
            "we have a Product"
        );

        cmp_ok( $product->has_column_loaded('variant_count'),
            '==', $i, "product has_column_loaded variant_count == $i" );

        cmp_ok( $product->variant_count,
            '==', 2, "product variant_count is 2" );

        lives_ok( sub { $product = $rset->find('os28085-12') },
            "get product os28085-12" );

        isa_ok(
            $product,
            "Interchange6::Schema::Result::Product",
            "we have a Product"
        );

        cmp_ok( $product->has_column_loaded('variant_count'),
            '==', $i, "product has_column_loaded variant_count == $i" );

        cmp_ok( $product->variant_count,
            '==', 0, "product variant_count is 0" );

        $i = 1;
    }

    # chain 
    lives_ok(
        sub {
            $products =
              $self->products->with_average_rating->with_quantity_in_stock
              ->with_lowest_selling_price->with_variant_count;
        },
        "get products with_*everything*"
    );

    cmp_ok( $products->count, '==', $num_products, "$num_products products" );

    # cleanup
    $self->clear_price_modifiers;
};

1;
