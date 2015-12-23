package Test::Currency;

use utf8;
use Test::Exception;
use Test::Roo::Role;
use DateTime;

test 'setup and environment checks' => sub {
    my $self   = shift;
    my $schema = $self->ic6s_schema;

    $self->products        unless $self->has_products;
    $self->price_modifiers unless $self->has_price_modifiers;

    my $dt_now       = DateTime->now;
    my $dt_yesterday = $dt_now->clone->subtract( days => 1 );
    my $dt_tomorrow  = $dt_now->clone->add( days => 1 );

    lives_ok {
        # don't use void context since that bypasses DateTime deflate
        scalar $schema->resultset('ExchangeRate')->populate(
            [
                [
                    'source_currency_iso_code', 'target_currency_iso_code',
                    'rate',                     'valid_from',
                ],
                [ 'EUR', 'USD', 1.10023, $dt_yesterday, ],
                [ 'EUR', 'USD', 1.09113, $dt_now, ],
                [ 'EUR', 'USD', 1.07234, $dt_tomorrow, ],
                [ 'EUR', 'GBP', 0.73390, $dt_now, ],
                [ 'EUR', 'JPY', 131.899, $dt_now, ],
                [ 'EUR', 'BHD', 0.41156, $dt_now, ],
                [ 'GBP', 'EUR', 1.36315, $dt_now, ],
            ]
        );
    }
    "populate ExchangeRate";

    cmp_ok $schema->currency_iso_code, 'eq', 'EUR',
      'Schema currency_iso_code is EUR';

    cmp_ok $schema->locale, 'eq', 'en', 'Schema local is en';
};

test 'currency tests' => sub {
    my $self   = shift;
    my $schema = $self->ic6s_schema;

    my ( $product, $price );

    lives_ok { $product = $schema->resultset('Product')->find('os28005') }
    "Find product with sku os28005";

    ok $product, "we found the product";

    $price = $product->price;

    cmp_ok $price->locale, 'eq', 'en', 'price locale is en (schema default)';

    cmp_ok $price->converter_class, 'eq',
      'Interchange6::Schema::Currency::Convert',
      'price converter_class is Interchange6::Schema::Currency::Convert';

    cmp_ok $price, '==', 8.99, 'price == 8.99';

    cmp_ok $price, 'eq', '€8.99', 'price eq "€8.99"';

    isa_ok $price, "Interchange6::Schema::Currency", "price";
    isa_ok $price, "Interchange6::Currency",         "price";

    lives_ok { $schema->set_locale('fr') } "set schema locale to 'fr'";

    cmp_ok $price->locale, 'eq', 'en', 'price locale is en (schema default)';

    lives_ok { $product = $product->get_from_storage }
    "reload product from database";

    cmp_ok $price, '==', $product->price, "previous en price == fr price";

    $price = $product->price;

    cmp_ok $price->locale, 'eq', 'fr', 'price locale is fr';

    cmp_ok $price, 'eq', '8,99 €', 'price eq "8,99 €"';

    lives_ok { $price->convert('JPY') } "convert price to JPY";

    cmp_ok $price, 'eq', '1 186 JPY', 'price eq "1 186 JPY"';

    lives_ok { $schema->set_locale('en') } "set schema locale to 'en'";

    lives_ok { $product = $product->get_from_storage }
    "reload product from database";

    $price = $product->price;

    lives_ok { $price->convert('USD') } "convert price to USD";

    cmp_ok $price, 'eq', '$9.81', 'price eq "$9.81"';

};

test 'price_modifier tests' => sub {
    my $self   = shift;
    my $schema = $self->ic6s_schema;

    my $product;

    lives_ok { $product = $schema->resultset('Product')->find('os28005') }
    "Find product with sku os28005";

    lives_ok { $product->price->convert('USD') } "convert price to USD";

    cmp_ok $product->selling_price, 'eq', '$9.81', 'selling_price eq "$9.81"';

    cmp_ok $product->selling_price( { quantity => 10 } ), 'eq', '$9.26',
      'selling_price for qty 10 eq "$9.26"';
};

test 'cleanup' => sub {
    my $self   = shift;
    my $schema = $self->ic6s_schema;

    lives_ok { $schema->resultset('ExchangeRate')->delete }
    "delete all from ExchangeRate ";
};

1;
