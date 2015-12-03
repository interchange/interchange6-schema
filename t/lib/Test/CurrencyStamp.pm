package Test::CurrencyStamp;

use Test::Exception;
use Test::Roo::Role;

test 'payment tests' => sub {
    my $self = shift;

    my ( $cart, $session );
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
        $session = $schema->resultset('Session')->create(
            {
                sessions_id  => '8746587592345',
                session_data => '',
            }
          )
    }
    "Create session";

    lives_ok {
        $cart = $schema->resultset('Cart')->create(
            {
                sessions_id  => '8746587592345',
            }
          )
    }
    "Create cart";

    cmp_ok( $schema->currency_iso_code,
        'eq', 'EUR', "schema currency_iso_code is set to default 'EUR'" );

    cmp_ok( $cart->currency_iso_code,
        'eq', 'EUR', "cart currency_iso_code is EUR" );

    lives_ok { $cart->delete } "delete the cart";

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
        $cart = $schema->resultset('Cart')->create(
            {
                sessions_id  => '8746587592345',
            }
          )
    }
    "Create cart which should now get currency GBP";

    cmp_ok( $schema->currency_iso_code,
        'eq', 'GBP', "schema currency_iso_code is set to 'GBP'" );

    cmp_ok( $cart->currency_iso_code,
        'eq', 'GBP', "cart currency_iso_code is GBP" );

    lives_ok { $cart->delete } "delete the cart (cleanup)";

    lives_ok { $session->delete } "delete the session (cleanup)";

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
