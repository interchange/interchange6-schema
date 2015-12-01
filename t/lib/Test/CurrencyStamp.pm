package Test::CurrencyStamp;

use Test::Exception;
use Test::Roo::Role;

test 'payment tests' => sub {
    my $self = shift;

    my $product;
    my $schema = $self->ic6s_schema;

    lives_ok { $schema->set_currency_iso_code(undef) }
    "Undef schema's currency_iso_code";

    ok !defined $schema->currency_iso_code, "schema currency_iso_code is undef";

    lives_ok {
        $schema->resultset('Setting')->search(
            {
                scope    => 'global',
                name     => 'currency_iso_code',
                category => ''
            }
          )->delete
    }
    "Delete any existing currency setting from Setting class";

    lives_ok {
        $product = $schema->resultset('Product')->create(
            {
                name        => 'testing_currency_stamp',
                sku         => 'tcs0001',
                description => '',
            }
          )
    }
    "Create product";

    cmp_ok( $schema->currency_iso_code,
        'eq', 'EUR', "schema currency_iso_code is set to default 'EUR'" );

    cmp_ok( $product->currency_iso_code,
        'eq', 'EUR', "product currency_iso_code is EUR" );

    lives_ok { $product->delete } "delete the product";

    lives_ok { $schema->set_currency_iso_code(undef) }
    "Undef schema's currency_iso_code";

    ok !defined $schema->currency_iso_code, "schema currency_iso_code is undef";

    lives_ok {
        $schema->resultset('Setting')->create(
            {
                scope    => 'global',
                name     => 'currency_iso_code',
                category => '',
                value    => 'GBP',
            }
          )
    }
    "Set currency_iso_code setting to GBP";

    lives_ok {
        $product = $schema->resultset('Product')->create(
            {
                name        => 'testing_currency_stamp',
                sku         => 'tcs0001',
                description => '',
            }
          )
    }
    "Create product";

    cmp_ok( $schema->currency_iso_code,
        'eq', 'GBP', "schema currency_iso_code is set to 'GBP'" );

    cmp_ok( $product->currency_iso_code,
        'eq', 'GBP', "product currency_iso_code is GBP" );

    lives_ok { $product->delete } "delete the product (cleanup)";

    lives_ok {
        $schema->resultset('Setting')->search(
            {
                scope    => 'global',
                name     => 'currency_iso_code',
                category => ''
            }
          )->delete
    }
    "Delete currency setting from Setting class (cleanup)";
};

1;
