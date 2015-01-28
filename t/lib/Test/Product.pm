package Test::Product;
use utf8;

use Test::Exception;
use Test::Roo::Role;

test 'product tests' => sub {

    diag 'Test::Product';

    my $self = shift;

    my $schema = $self->ic6s_schema;

    my $products = $schema->resultset('Product');

    my ( $product, $result );

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

    # cleanup
    $self->clear_products;
};

1;
