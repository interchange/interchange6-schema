package Test::Fixtures;

use Test::Exception;
use Test::Roo::Role;

test 'countries attribute' => sub {
    my $self = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_countries, "countries attribute not set" );

    cmp_ok( $self->countries->count, '>=', 250, "at least 250 countries" );

    ok( $self->has_countries, "countries attribute is set" );

    lives_ok( sub { $self->clear_countries }, "clear_countries" );

    ok( !$self->has_countries, "countries attribute not set" );

    cmp_ok( $schema->resultset('Country')->count, '==', 0, "no Country rows" );

};

test 'states attribute' => sub {
    my $self = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_states, "states attribute not set" );
    ok( !$self->has_countries, "countries attribute not set" );

    cmp_ok( $self->states->count, '>=', 64, "at least 64 states" );

    cmp_ok( $self->states->search({ country_iso_code => 'US' } )->count,
        '==', 51, "51 states (including DC) in the US"
    );

    cmp_ok( $self->states->search({ country_iso_code => 'CA' } )->count,
        '==', 13, "13 provinces and territories in Canada"
    );

    ok( $self->has_states, "states attribute is set" );
    ok( $self->has_states, "countries attribute is set" );

    lives_ok( sub { $self->clear_states }, "clear_states" );

    ok( !$self->has_states, "states attribute not set" );
    ok( $self->has_countries, "countries attribute is set" );

    cmp_ok( $schema->resultset('State')->count, '==', 0, "no State rows" );
    cmp_ok( $schema->resultset('Country')->count, '>=', 250, "Country rows" );

};

test 'zones attribute' => sub {
    my $self = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_countries, "countries attribute not set" );
    ok( !$self->has_states, "states attribute not set" );
    ok( !$self->has_zones, "zones attribute not set" );

    cmp_ok( $self->zones->count, '>=', 317, "at least 317 zones" );

    ok( $self->has_countries, "countries attribute is set" );
    ok( $self->has_states, "states attribute is set" );
    ok( $self->has_zones, "zones attribute is set" );

    lives_ok( sub { $self->clear_zones }, "clear_zones" );

    ok( $self->has_countries, "countries attribute is set" );
    ok( $self->has_states, "states attribute is set" );
    ok( !$self->has_zones, "zones attribute not set" );

};

test 'users attribute' => sub {
    my $self = shift;
    my $schema = $self->schema;

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_users, "users attribute not set" );

    cmp_ok( $self->users->count, '==', 5, "5 users" );
    cmp_ok( $schema->resultset('User')->count, '==', 5, "5 users in the db" );

    ok( $self->has_users, "users attribute is set" );

    lives_ok( sub { $self->clear_users }, "clear_users" );

    ok( !$self->has_users, "users attribute not set" );

    cmp_ok( $self->users->count, '==', 5, "5 users" );

    lives_ok( sub { $self->clear_all_fixtures }, "clear_all_fixtures" );

    ok( !$self->has_users, "users attribute not set" );
    cmp_ok( $schema->resultset('User')->count, '==', 0, "0 users in the db" );
};


1;
