package Test::Fixtures;

use Test::Exception;
use Test::Roo::Role;

test 'countries' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_countries, "has_countries is false" );

    cmp_ok( $self->countries->count, '>=', 250, "at least 250 countries" );

    ok( $self->has_countries, "has_countries is true" );

    lives_ok( sub { $self->clear_countries }, "clear_countries" );

    ok( !$self->has_countries, "has_countries is false" );

    cmp_ok( $schema->resultset('Country')->count, '==', 0, "no Country rows" );
};

test 'states' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_states,    "has_states is false" );
    ok( !$self->has_countries, "has_countries is false" );

    cmp_ok( $self->states->count, '>=', 64, "at least 64 states" );

    cmp_ok( $self->states->search( { country_iso_code => 'US' } )->count,
        '==', 51, "51 states (including DC) in the US" );

    cmp_ok( $self->states->search( { country_iso_code => 'CA' } )->count,
        '==', 13, "13 provinces and territories in Canada" );

    ok( $self->has_states,    "has_states is true" );
    ok( $self->has_countries, "has_countries is true" );

    lives_ok( sub { $self->clear_states }, "clear_states" );

    ok( !$self->has_states,   "has_states is false" );
    ok( $self->has_countries, "has_countries is true" );

    cmp_ok( $schema->resultset('State')->count,   '==', 0,   "no State rows" );
    cmp_ok( $schema->resultset('Country')->count, '>=', 250, "Country rows" );
};

test 'taxes' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_countries, "has_countries is false" );
    ok( !$self->has_states,    "has_states is false" );
    ok( !$self->has_taxes,     "has_taxes is false" );

    cmp_ok( $self->taxes->count, '=', 28, "28 Tax rates" );

    ok( $self->has_countries, "has_countries is true" );
    ok( $self->has_states,    "has_states is true" );
    ok( $self->has_taxes,     "has_taxes is true" );

};

test 'zones' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_countries, "has_countries is false" );
    ok( !$self->has_states,    "has_states is false" );
    ok( !$self->has_zones,     "has_zones is false" );

    cmp_ok( $self->zones->count, '>=', 317, "at least 317 zones" );

    ok( $self->has_countries, "has_countries is true" );
    ok( $self->has_states,    "has_states is true" );
    ok( $self->has_zones,     "has_zones is true" );

    lives_ok( sub { $self->clear_zones }, "clear_zones" );

    ok( $self->has_countries, "has_countries is true" );
    ok( $self->has_states,    "has_states is true" );
    ok( !$self->has_zones,    "has_zones is false" );
    cmp_ok( $schema->resultset('Zone')->count, '==', 0, "no Zone rows" );
};

test 'users' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_users, "has_users is false" );

    cmp_ok( $self->users->count,               '==', 5, "5 users" );
    cmp_ok( $schema->resultset('User')->count, '==', 5, "5 users in the db" );

    ok( $self->has_users, "has_users is true" );

    lives_ok( sub { $self->clear_users }, "clear_users" );

    ok( !$self->has_users, "has_users is false" );

    cmp_ok( $self->users->count, '==', 5, "5 users" );

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_users, "has_users is false" );
    cmp_ok( $schema->resultset('User')->count, '==', 0, "0 users in the db" );
};

test 'attributes' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_attributes, "has_attributes is false" );

    cmp_ok( $self->attributes->count, '==', 3, "3 attributes" );

    ok( $self->has_attributes, "has_attributes is true" );

    cmp_ok( $schema->resultset('Attribute')->count,
        '==', 3, "3 Attributes in DB" );

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_attributes, "has_attributes is false" );

    cmp_ok( $schema->resultset('Attribute')->count,
        '==', 0, "0 Attributes in DB" );

    cmp_ok( $schema->resultset('AttributeValue')->count,
        '==', 0, "0 AttributeValues in DB" );
};

test 'products' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    my $product;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_products,   "has_products is false" );
    ok( !$self->has_attributes, "has_attributes is false" );

    cmp_ok( $self->products->count, '==', 6, "6 products" );

    ok( $self->has_products,   "has_products is true" );
    ok( $self->has_attributes, "has_attributes is true" );

    lives_ok(
        sub {
            $product = $self->products->search(
                {
                    canonical_sku => undef
                },
                { rows => 1 }
            )->single;
        },
        "select canonical product"
    );

    cmp_ok( $product->variants->count, '==', 5, "5 product variants" );

    cmp_ok( $schema->resultset('AttributeValue')->count,
        '==', 11, "11 AttributeValues" );

    cmp_ok( $schema->resultset('ProductAttribute')->count,
        '==', 10, "10 ProductAttributes" );

    lives_ok( sub { $self->clear_products }, "clear_products" );

    ok( !$self->has_products,  "has_products is false" );
    ok( $self->has_attributes, "has_attributes is true" );

    # reload products fixtures
    cmp_ok( $self->products->count, '==', 6, "6 products" );

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_products,   "has_products is false" );
    ok( !$self->has_attributes, "has_attributes is false" );

    cmp_ok( $schema->resultset('Product')->count,
        '==', 0, "0 Products in the db" );

    cmp_ok( $schema->resultset('ProductAttribute')->count,
        '==', 0, "0 ProductAttributes in the db" );
};

test 'addresses' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_addresses, "has_addresses is false" );

    cmp_ok( $self->addresses->count, '==', 8, "8 addresses" );

    ok( $self->has_addresses, "has_addresses is true" );
    ok( $self->has_users,     "has_users is true" );

    cmp_ok(
        $self->users->find( { username => 'customer1' } )
          ->search_related('addresses')->count,
        '==', 3, "3 addresses for customer1"
    );

    cmp_ok(
        $self->users->find( { username => 'customer2' } )
          ->search_related('addresses')->count,
        '==', 3, "3 addresses for customer2"
    );

    cmp_ok(
        $self->users->find( { username => 'customer3' } )
          ->search_related('addresses')->count,
        '==', 2, "2 addresses for customer3"
    );

    cmp_ok( $schema->resultset('Address')->count, '==', 8,
        "8 Addresses in DB" );

    lives_ok( sub { $self->clear_users }, "clear_users" );

    cmp_ok( $schema->resultset('Address')->count, '==', 0,
        "0 Addresses in DB" );

    cmp_ok( $schema->resultset('User')->count, '==', 0, "0 Users in DB" );

    ok( !$self->has_users,    "has_users is false" );
    ok( $self->has_addresses, "has_addresses is true !!!" );
};

1;
