
BEGIN {
    plan tests => 11;
    use_ok( 'Test::DBIx::Class', 0.41 )
      or BAIL_OUT "Cannot load Test::DBIx::Class 0.41";
}

use Data::Dumper;

use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;

my $ret;

my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;
my $pop_states    = Interchange6::Schema::Populate::StateLocale->new->records;
my $pop_zones     = Interchange6::Schema::Populate::Zone->new->records;

fixtures_ok [ Country => $pop_countries, ], 'Populate countries';

fixtures_ok [ State => $pop_states, ], 'Populate states';

fixtures_ok [ Zone => $pop_zones, ], 'Populate zones';

my $country_count = Country->count;
my $state_count   = State->count;
my $zone_count    = Zone->count;

cmp_ok( $country_count, '>=', 250, "At least 250 countries" );
cmp_ok( $state_count,   '>=', 64,  "At least 64 states" );
cmp_ok( $zone_count,    '>=', 317, "At least 317 zones" );

cmp_ok( State->get_column('states_id')->max,
    '==', $state_count, "max states_id as expected" );
cmp_ok( Zone->get_column('zones_id')->max,
    '==', $zone_count, "max zones_id as expected" );

lives_ok(
    sub {
        $ret = State->create(
            {
                country_iso_code => 'US',
                state_iso_code   => 'VI',
                name             => 'U.S. Virgin Islands'
            }
        );
    },
    "Create a new state"
);

cmp_ok( $ret->states_id, '==', ++$state_count, "Check states_id" );
