package Test::Fixtures;

use Test::Exception;
use Test::Roo::Role;
use Data::Dumper::Concise;

has websites => (
    is       => 'ro',
    default  => sub { [] },
    init_arg => undef,
);

my %classes;

test 'construct classes hash' => sub {

    while ( my ( $accessor, $class ) =
        each %Interchange6::Test::Role::Fixtures::accessor2class )
    {
        $classes{$class} = $accessor;
    }

    cmp_ok(scalar keys %classes, '==', 19, '%classes has 19 keys' ) or die;
};

my @currencies = ( 'EUR', 'USD', 'GBP', 'JPY' );

test 'create websites' => sub {
    my $self = shift;

    my $schema = $self->ic6s_schema;

    foreach my $i ( 0 .. 1 ) {
        my $website;

        # test hash and hashref forms of create_website
        if ( $i % 2 ) {
            lives_ok {
                $website = $schema->create_website(
                    name        => "shop$i",
                    description => "Test Shop $i",
                    admin       => "shop${i}admin\@example.com",
                    currency    => $currencies[$i]
                );
            }
            "Create shop$i using hash";
        }
        else {
            lives_ok {
                $website = $schema->create_website(
                    {
                        name        => "shop$i",
                        description => "Test Shop $i",
                        admin       => "admin",
                        currency    => $currencies[$i]
                    }
                );
            }
            "Create shop$i using hashref";
        }
        push @{ $self->websites }, $website;

        my $settings = $website->settings->search(
            { scope => 'global', name => 'currency' } );

        cmp_ok($settings->count, '==', 1, 'found 1 currency setting');

        my $currency = $currencies[$i];

        cmp_ok( $settings->first->value,
            'eq', $currency, "currency is $currency" );

        # clear out some rows that will be replaced by test fixtures
        $self->ic6s_schema->resultset('User')->delete;
        $self->ic6s_schema->resultset('Role')->delete;
    }
};

test 'initial environment' => sub {
    my $self = shift;

    # start with unrestricted schema
    $self->clear_ic6s_schema;

    cmp_ok( $self->ic6s_schema->resultset('Country')->count,
        '>=', 500, "at least 500 countries" );

    cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
        '>=', 300, "at least 300 currencies" );

    cmp_ok( $self->ic6s_schema->resultset('MessageType')->count,
        '==', 8, "8 message_types" );

    cmp_ok( $self->ic6s_schema->resultset('State')->count,
        '>=', 128, "at least 128 states" );

    cmp_ok( $self->ic6s_schema->resultset('Zone')->count,
        '==', 634, "634 zones" );

    # restrict using Admin Website

    my $website = $self->ic6s_schema->resultset('Website')
      ->find( { name => 'Admin Website' } );

    isa_ok( $website, "Interchange6::Schema::Result::Website" );

    lives_ok { $self->set_website($website) }
    "restrict schema to " . $website->name;

    cmp_ok( $self->ic6s_schema->resultset('Country')->count,
        '==', 0, "0 countries" );

    cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
        '==', 0, "0 currencies" );

    cmp_ok( $self->ic6s_schema->resultset('MessageType')->count,
        '==', 0, "0 message_types" );

    cmp_ok( $self->ic6s_schema->resultset('State')->count, '==', 0,
        "0 states" );

    cmp_ok( $self->ic6s_schema->resultset('Zone')->count, '==', 0, "0 zones" );

    # restrict by individual shop websites

    foreach my $website ( @{ $self->websites } ) {

        lives_ok { $self->set_website($website) }
        "restrict schema to " . $website->name;

        cmp_ok( $self->ic6s_schema->resultset('Country')->count,
            '>=', 250, "at least 250 countries" );

        cmp_ok( $self->ic6s_schema->resultset('Country')->count,
            '<', 500, "less than 500 countries" );

        cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
            '>=', 150, "at least 150 currencies" );

        cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
            '<', 200, "less than 200 currencies" );

        cmp_ok( $self->ic6s_schema->resultset('MessageType')->count,
            '==', 4, "4 message_types" );

        cmp_ok( $self->ic6s_schema->resultset('State')->count,
            '>=', 64, "at least 64 states" );

        cmp_ok( $self->ic6s_schema->resultset('State')->count,
            '<', 100, "less than 100 states" );

        cmp_ok( $self->ic6s_schema->resultset('Zone')->count,
            '==', 317, "317 zones" );

        foreach my $class (
            qw/
            Address Attribute Inventory Media Navigation Order
            PriceModifier Product Role ShipmentCarrier ShipmentRate
            Tax UriRedirect User
            /
          )
        {
            cmp_ok( $self->ic6s_schema->resultset($class)->count,
                '==', 0, "0 $classes{$class}" );
        }
    }

    lives_ok { $self->clear_website } "remove schema restriction";
};

test 'load all fixtures' => sub {
    my $self = shift;

    foreach my $website ( @{ $self->websites } ) {

        my $name = $website->name;

        lives_ok { $self->set_website($website) } "restrict schema to $name";

        my $currency = $self->ic6s_schema->primary_currency;

        isa_ok( $currency, "Interchange6::Schema::Result::Currency" );

        ok( !$self->has_taxes, "$name 0 Tax rates" );

        lives_ok( sub { $self->load_all_fixtures }, "$name load_all_fixtures" );

        cmp_ok( $self->ic6s_schema->resultset('Address')->count,
            '==', 8, "8 addresses" );

        cmp_ok( $self->ic6s_schema->resultset('Attribute')->count,
            '==', 11, "11 attributes" );

        cmp_ok( $self->ic6s_schema->resultset('Country')->count,
            '>=', 250, "at least 250 countries" );

        cmp_ok( $self->ic6s_schema->resultset('Country')->count,
            '<', 500, "less than 500 countries" );

        cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
            '>=', 150, "at least 150 currencies" );

        cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
            '<', 200, "less than 200 currencies" );

        cmp_ok( $self->ic6s_schema->resultset('MessageType')->count,
            '==', 4, "4 message_types" );

        cmp_ok( $self->ic6s_schema->resultset('Inventory')->count,
            '==', 59, "59 inventory items" );

        cmp_ok( $self->ic6s_schema->resultset('Media')->count,
            '==', 69, "69 media items" );

        cmp_ok( $self->ic6s_schema->resultset('Navigation')->count,
            '==', 31, "31 navigation items" );

        cmp_ok( $self->ic6s_schema->resultset('Order')->count,
            '==', 2, "2 orders" );

        cmp_ok( $self->ic6s_schema->resultset('PriceModifier')->count,
            '==', 17, "17 price_modifiers" );

        cmp_ok( $self->ic6s_schema->resultset('Product')->count,
            '==', 69, "69 products" );

        cmp_ok( $self->ic6s_schema->resultset('Role')->count,
            '==', 6, "6 roles" );

        cmp_ok( $self->ic6s_schema->resultset('ShipmentCarrier')->count,
            '==', 2, "2 shipment_carriers" );

        cmp_ok( $self->ic6s_schema->resultset('ShipmentRate')->count,
            '==', 2, "2 shipment_rates" );

        cmp_ok( $self->ic6s_schema->resultset('UriRedirect')->count,
            '==', 3, "3 uri_redirects" );

        cmp_ok( $self->ic6s_schema->resultset('User')->count,
            '==', 5, "5 users" );

        cmp_ok( $self->ic6s_schema->resultset('State')->count,
            '>=', 64, "at least 64 states" );

        cmp_ok( $self->ic6s_schema->resultset('State')->count,
            '<', 100, "less than 100 states" );

        cmp_ok( $self->ic6s_schema->resultset('Tax')->count,
            '==', 37, "37 taxes" );

        cmp_ok( $self->ic6s_schema->resultset('Zone')->count,
            '==', 317, "317 zones" );

        foreach my $class ( sort keys %classes ) {
            my $predicate = "has_$classes{$class}";
            ok( $self->$predicate, "$name $predicate is true" );
        }
    }

    lives_ok { $self->clear_website } "remove schema restriction";

    cmp_ok( $self->ic6s_schema->resultset('Address')->count,
        '==', 16, "16 addresses" );

    cmp_ok( $self->ic6s_schema->resultset('Attribute')->count,
        '==', 22, "22 attributes" );

    cmp_ok( $self->ic6s_schema->resultset('Country')->count,
        '>=', 500, "at least 500 countries" );

    cmp_ok( $self->ic6s_schema->resultset('Country')->count,
        '<', 1000, "less than 1000 countries" );

    cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
        '>=', 300, "at least 300 currencies" );

    cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
        '<', 400, "less than 400 currencies" );

    cmp_ok( $self->ic6s_schema->resultset('MessageType')->count,
        '==', 8, "8 message_types" );

    cmp_ok( $self->ic6s_schema->resultset('Inventory')->count,
        '==', 118, "118 inventory items" );

    cmp_ok( $self->ic6s_schema->resultset('Media')->count,
        '==', 138, "138 media items" );

    cmp_ok( $self->ic6s_schema->resultset('Navigation')->count,
        '==', 62, "62 navigation items" );

    cmp_ok( $self->ic6s_schema->resultset('Order')->count,
        '==', 4, "4 orders" );

    cmp_ok( $self->ic6s_schema->resultset('PriceModifier')->count,
        '==', 34, "34 price_modifiers" );

    cmp_ok( $self->ic6s_schema->resultset('Product')->count,
        '==', 138, "138 products" );

    cmp_ok( $self->ic6s_schema->resultset('Role')->count, '==', 12,
        "12 roles" );

    cmp_ok( $self->ic6s_schema->resultset('ShipmentCarrier')->count,
        '==', 4, "4 shipment_carriers" );

    cmp_ok( $self->ic6s_schema->resultset('ShipmentRate')->count,
        '==', 4, "4 shipment_rates" );

    cmp_ok( $self->ic6s_schema->resultset('UriRedirect')->count,
        '==', 6, "6 uri_redirects" );

    cmp_ok( $self->ic6s_schema->resultset('User')->count, '==', 10,
        "10 users" );

    cmp_ok( $self->ic6s_schema->resultset('State')->count,
        '>=', 128, "at least 128 states" );

    cmp_ok( $self->ic6s_schema->resultset('State')->count,
        '<', 200, "less than 200 states" );

    cmp_ok( $self->ic6s_schema->resultset('Tax')->count, '==', 74, "74 taxes" );

    cmp_ok( $self->ic6s_schema->resultset('Zone')->count,
        '==', 634, "634 zones" );

};

test 'clear_all_fixtures' => sub {
    my $self = shift;
    my ( $website, $name );

    # clear shop0

    $website = $self->websites->[0];
    $name    = $website->name;

    lives_ok { $self->set_website($website) } "restrict schema to $name";

    lives_ok( sub { $self->clear_all_fixtures }, "$name clear_all_fixtures" );

    foreach my $class ( sort keys %classes ) {

        # all fixtures should be empty
        my $predicate = "has_$classes{$class}";
        ok( !$self->$predicate, "$name $predicate is false" );
        cmp_ok( $self->ic6s_schema->resultset($class)->count,
            '==', 0, "0 $class rows" );
    }

    # but we should still see shop1 fixtures in schema

    lives_ok { $self->clear_website } "remove schema restriction";

    cmp_ok( $self->ic6s_schema->resultset('Address')->count,
        '==', 8, "8 addresses" );

    cmp_ok( $self->ic6s_schema->resultset('Attribute')->count,
        '==', 11, "11 attributes" );

    cmp_ok( $self->ic6s_schema->resultset('Country')->count,
        '>=', 250, "at least 250 countries" );

    cmp_ok( $self->ic6s_schema->resultset('Country')->count,
        '<', 500, "less than 500 countries" );

    cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
        '>=', 150, "at least 150 currencies" );

    cmp_ok( $self->ic6s_schema->resultset('Currency')->count,
        '<', 200, "less than 200 currencies" );

    cmp_ok( $self->ic6s_schema->resultset('MessageType')->count,
        '==', 4, "4 message_types" );

    cmp_ok( $self->ic6s_schema->resultset('Inventory')->count,
        '==', 59, "59 inventory items" );

    cmp_ok( $self->ic6s_schema->resultset('Media')->count,
        '==', 69, "69 media items" );

    cmp_ok( $self->ic6s_schema->resultset('Navigation')->count,
        '==', 31, "31 navigation items" );

    cmp_ok( $self->ic6s_schema->resultset('Order')->count,
        '==', 2, "2 orders" );

    cmp_ok( $self->ic6s_schema->resultset('PriceModifier')->count,
        '==', 17, "17 price_modifiers" );

    cmp_ok( $self->ic6s_schema->resultset('Product')->count,
        '==', 69, "69 products" );

    cmp_ok( $self->ic6s_schema->resultset('Role')->count, '==', 6, "6 roles" );

    cmp_ok( $self->ic6s_schema->resultset('ShipmentCarrier')->count,
        '==', 2, "2 shipment_carriers" );

    cmp_ok( $self->ic6s_schema->resultset('ShipmentRate')->count,
        '==', 2, "2 shipment_rates" );

    cmp_ok( $self->ic6s_schema->resultset('UriRedirect')->count,
        '==', 3, "3 uri_redirects" );

    cmp_ok( $self->ic6s_schema->resultset('User')->count, '==', 5, "5 users" );

    cmp_ok( $self->ic6s_schema->resultset('State')->count,
        '>=', 64, "at least 64 states" );

    cmp_ok( $self->ic6s_schema->resultset('State')->count,
        '<', 100, "less than 100 states" );

    cmp_ok( $self->ic6s_schema->resultset('Tax')->count, '==', 37, "37 taxes" );

    cmp_ok( $self->ic6s_schema->resultset('Zone')->count,
        '==', 317, "317 zones" );

    # now clear out shop1

    $website = $self->websites->[1];
    $name    = $website->name;

    lives_ok { $self->set_website($website) } "restrict schema to $name";

    lives_ok( sub { $self->clear_all_fixtures }, "$name clear_all_fixtures" );

    foreach my $class ( sort keys %classes ) {

        # all fixtures should be empty
        my $predicate = "has_$classes{$class}";
        ok( !$self->$predicate, "$name $predicate is false" );
        cmp_ok( $self->ic6s_schema->resultset($class)->count,
            '==', 0, "0 $class rows" );
    }

    # now we should see nothing in unrestricted schema

    lives_ok { $self->clear_website } "remove schema restriction";

    foreach my $class ( sort keys %classes ) {
        my $predicate = "has_$classes{$class}";
        ok( !$self->$predicate, "$name $predicate is false" );
        cmp_ok( $self->ic6s_schema->resultset($class)->count,
            '==', 0, "0 $class rows" );
    }

};

1;
