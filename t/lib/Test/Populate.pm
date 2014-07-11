package Test::Populate;

use Test::Exception;
use Test::Roo::Role;

use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;

test 'populate Country, State and Zone' => sub {
    my $self = shift;

    my $schema = $self->schema;

    my $pop_countries =
      Interchange6::Schema::Populate::CountryLocale->new->records;
    my $pop_states = Interchange6::Schema::Populate::StateLocale->new->records;
    my $pop_zones  = Interchange6::Schema::Populate::Zone->new->records;

    lives_ok( sub { $schema->populate( Country => $pop_countries ) },
        "populate Country" );

    lives_ok( sub { $schema->populate( State => $pop_states ) },
        "populate State" );

    lives_ok( sub { $schema->populate( Zone => $pop_zones ) },
        "populate Zone" );

    my $country = $schema->resultset('Country');
    my $state   = $schema->resultset('State');
    my $zone    = $schema->resultset('Zone');

    my $country_count = $country->count;
    my $state_count   = $state->count;
    my $zone_count    = $zone->count;

    cmp_ok( $country_count, '>=', 250, "At least 250 countries" );
    cmp_ok( $state_count,   '>=', 64,  "At least 64 states" );
    cmp_ok( $zone_count,    '>=', 317, "At least 317 zones" );

    cmp_ok( $state->get_column('states_id')->max,
        '==', $state_count, "max states_id as expected" );
    cmp_ok( $zone->get_column('zones_id')->max,
        '==', $zone_count, "max zones_id as expected" );

};

1;
