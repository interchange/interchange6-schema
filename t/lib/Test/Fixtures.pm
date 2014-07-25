package Test::Fixtures;

use Test::Exception;
use Test::Roo::Role;

# NOTE: make sure new fixtures are add to this hash

my %classes = (
    Address   => 'addresses',
    Attribute => 'attributes',
    Country   => 'countries',
    Product   => 'products',
    State     => 'states',
    Tax       => 'taxes',
    User      => 'users',
    Zone      => 'zones',
);

# NOTE: do not place any tests before the following test

test 'initial environment' => sub {

    diag Test::Fixtures;

    my $self = shift;

    foreach my $class ( sort keys %classes ) {
        cmp_ok( $self->schema->resultset($class)->count,
            '==', 0, "0 rows in $class" );

        my $has = "has_$classes{$class}";
        ok( !$self->$has, "$has is false" );
    }
};

test 'countries' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    cmp_ok( $self->countries->count, '>=', 250, "at least 250 countries" );

    ok( $self->has_countries, "has_countries is true" );

    cmp_ok( $self->countries->find( { country_iso_code => 'MT' } )->name,
        'eq', 'Malta', "iso_code MT name Malta" );
};

test 'states' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    cmp_ok( $self->states->count, '>=', 64, "at least 64 states" );

    ok( $self->has_states, "has_states is true" );

    cmp_ok( $self->states->search( { country_iso_code => 'US' } )->count,
        '==', 51, "51 states (including DC) in the US" );

    cmp_ok( $self->states->search( { country_iso_code => 'CA' } )->count,
        '==', 13, "13 provinces and territories in Canada" );

};

test 'taxes' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    my $rset;

    cmp_ok( $self->taxes->count, '==', 37, "37 Tax rates" );

    ok( $self->has_taxes, "has_taxes is true" );

    # EU Standard rate VAT
    lives_ok(
        sub {
            $rset = $self->taxes->search( { tax_name => "MT VAT Standard" } );
        },
        "search for Malta VAT"
    );
    cmp_ok( $rset->count, '==', 1, "Found one tax" );
    cmp_ok(
        $rset->first->description,
        'eq',
        'Malta VAT Standard Rate',
        "Tax description is correct"
    );

    # Canada GST/PST/HST/QST
    lives_ok(
        sub {
            $rset = $self->taxes->search( { tax_name => "CA ON HST" } );
        },
        "search for Canada Ontario HST"
    );
    cmp_ok( $rset->count, '==', 1, "Found one tax" );
    cmp_ok(
        $rset->first->description,
        'eq',
        'CA Ontario HST',
        "Tax description is correct"
    );

    my $country_count = $self->countries->count;
    my $state_count   = $self->states->count;

    lives_ok( sub { $self->clear_taxes }, "clear_taxes" );

    ok( !$self->has_taxes, "has_taxes is false" );

    cmp_ok( $schema->resultset('Tax')->count, '==', 0, "0 Taxes in DB" );

    # check no cascade delete to country/state
    cmp_ok( $country_count, '==', $self->countries->count, "country count" );
    cmp_ok( $state_count,   '==', $self->states->count,    "state count" );

};

test 'zones' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    cmp_ok( $self->zones->count, '>=', 317, "at least 317 zones" );

    ok( $self->has_zones, "has_zones is true" );
};

test 'users' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    cmp_ok( $self->users->count, '==', 5, "5 users" );

    ok( $self->has_users, "has_users is true" );

    cmp_ok( $schema->resultset('User')->count, '==', 5, "5 users in the db" );

    cmp_ok(
        $self->users->search( { username => { -like => 'customer%' } } )->count,
        '==', 3, "3 customers"
    );

    cmp_ok(
        $self->users->search( { username => { -like => 'admin%' } } )->count,
        '==', 2, "2 admin" );
};

test 'attributes' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    cmp_ok( $self->attributes->count, '==', 3, "3 attributes" );

    ok( $self->has_attributes, "has_attributes is true" );

    cmp_ok( $schema->resultset('Attribute')->count,
        '==', 3, "3 Attributes in DB" );
};

test 'products' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    my $product;

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
};

test 'addresses' => sub {
    my $self   = shift;
    my $schema = $self->schema;

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
};

# NOTE: do not place any tests after this final test

test 'cleanup' => sub {
    my $self = shift;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    foreach my $class ( keys %classes ) {
        cmp_ok( $self->schema->resultset($class)->count,
            '==', 0, "0 rows in $class" );

        my $has = "has_$classes{$class}";
        ok( !$self->$has, "$has is false" );
    }
};

1;
