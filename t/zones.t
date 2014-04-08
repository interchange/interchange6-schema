use strict;
use warnings;

use Data::Dumper;
use Scalar::Util qw(blessed);

use Test::Most 'die', tests => 106;

use Interchange6::Schema;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;
use DateTime;
use DBICx::TestDatabase;

my ( $rset, %countries, %states, %zones, $data, $result );

my $dt = DateTime->now;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;
my $pop_states    = Interchange6::Schema::Populate::StateLocale->new(
    { generate_states_id => 1 } )->records;
my $pop_zones = Interchange6::Schema::Populate::Zone->new->records;
my $rsetzone  = $schema->resultset('Zone');

# populate Country, State and Zone

lives_ok( sub { $schema->populate( Country => $pop_countries ) },
    "populate countries" );

lives_ok( sub { $schema->populate( State => $pop_states ) },
    "populate states" );

lives_ok( sub { $schema->populate( Zone => $pop_zones ) }, "populate zones" );

# stuff countries and states into hashes to save lots of lookups later

$rset = $schema->resultset('Country')->search( {} );
while ( my $res = $rset->next ) {
    $countries{ $res->country_iso_code } = $res;
}

$rset = $schema->resultset('State')->search( {} );
while ( my $res = $rset->next ) {
    $states{ $res->country_iso_code . "_" . $res->state_iso_code } = $res;
}

# test Country and State first to be one the safe side

cmp_ok( $schema->resultset('Country')->count, '>=', 250, ">= 250 countries" );

cmp_ok(
    $schema->resultset('State')->search( { country_iso_code => 'US' } )->count,
    '==', 51, "51 states (including DC) in the US"
);

cmp_ok(
    $schema->resultset('State')->search( { country_iso_code => 'CA' } )->count,
    '==', 13, "13 provinces and territories in Canada"
);

cmp_ok( $schema->resultset('State')->count, '==', 64, "64 states in total" );

# test populate zone

# Add to 64 the number of extra zones created by Populate::Zone
# Current total is 67
cmp_ok(
    $schema->resultset('Zone')->count,
    '==',
    $schema->resultset('Country')->count + 67,
    "Number of zones eq country count + 67"
);

$rset = $schema->resultset('Zone')->search( { zone => 'US lower 48' } );
cmp_ok( $rset->count, '==', 1, "Found zone: US lower 48" );

$result = $rset->next;
cmp_ok( $result->state_count, '==', 49, "has 49 states :-)" );
ok( $result->has_state('NY'), "includes NY state" );
ok( $result->has_state('DC'), "includes DC" );
is( $result->has_state('AK'), 0, "does not include Alaska" );
is( $result->has_state('HI'), 0, "or Hawaii" );
is( $result->has_state('FooBar'), 0, "or FooBar" );
is( $result->has_state($countries{GB}), 0, "or country GB (as state)" );

$rset = $schema->resultset('Zone')->search( { zone => 'EU member states' } );
cmp_ok( $rset->count, '==', 1, "Found zone: EU member states" );

$result = $rset->next;
cmp_ok( $result->country_count, '==', 28, "has 28 countries" );
cmp_ok( $result->state_count,   '==', 0,  "has 0 states" );
ok( $result->has_country($countries{MT}), "includes Malta (country obj)" );
ok( $result->has_country('MT'), "includes Malta (MT)" );
ok( $result->has_country('Malta'), "includes Malta" );
is( $result->has_country('IM'), 0, "does not include Isle of Man (IM)" );
is( $result->has_country('Isle of Man'), 0, "does not include Isle of Man" );
is( $result->has_country($states{'US_CA'}), 0, "countries does not include Caliornia (state obj)" );

$rset = $schema->resultset('Zone')->search( { zone => 'EU VAT countries' } );
cmp_ok( $rset->count, '==', 1, "Found zone: EU VAT countries" );

$result = $rset->next;
cmp_ok( $result->country_count, '==', 29, "has 29 countries" );
cmp_ok( $result->state_count,   '==', 0,  "has 0 states" );
ok( $result->has_country('MT'), "includes Malta" );
ok( $result->has_country('IM'), "includes Isle of Man" );
is( $result->has_country('CH'), 0, "does not include Switzerland" );

# other zone tests

# Canada

throws_ok( sub { $result = $rsetzone->create( { zone => 'Canada' } ); },
    qr/column zone is not unique|UNIQUE constraint failed/i,
    "Fail to create zone Canada which already exists (populate)" );

lives_ok( sub { $result = $rsetzone->create( { zone => 'Canada test' } ); },
    "Create zone: Canada test" );

lives_ok(
    sub { $result->add_countries( $countries{CA} ) },
    "Create relationship to Country for Canada in zone Canada"
);

cmp_ok( $result->country_count, '==', 1, "1 country in zone" )
  || diag Dumper( $rset->errors );

throws_ok(
    sub { $result->remove_countries( $countries{US} ) },
    qr/Country does not exist in zone: United States/,
    "Fail to remove country US from zone Canada"
);

lives_ok( sub { $result->remove_countries( $countries{CA} ) },
    "Remove country CA from zone Canada" );

cmp_ok( $result->country_count, '==', 0, "0 country in zone" )
  || diag Dumper( $rset->errors );

$rset = $schema->resultset('ZoneCountry')
  ->search( { zones_id => $result->zones_id } );
cmp_ok( $rset->count, '==', 0, "check cascade delete in ZoneCountry" );

$rset = $schema->resultset('Country')->search( { country_iso_code => 'CA' } );
cmp_ok( $rset->count, '==', 1, "check cascade delete in Country" );

lives_ok(
    sub { $result->add_countries( $countries{CA} ) },
    "Create relationship to Country for Canada in zone Canada"
);

throws_ok( sub { $result->remove_countries('FooBar') },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail remove country FooBar from zone Canada" );

throws_ok( sub { $result->remove_countries(['FooBar']) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail remove country FooBar (arrayref) from zone Canada" );

throws_ok( sub { $result->remove_countries([$states{'US_CA'}]) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail remove country FooBar (arrayref) from zone Canada" );

lives_ok( sub { $result->remove_countries( [$countries{CA}] ) },
    "Remove country CA (arrayref) from zone Canada" );

lives_ok(
    sub { $result->add_countries( $countries{CA} ) },
    "Create relationship to Country for Canada in zone Canada"
);
lives_ok(
    sub { $result->add_countries( $countries{US} ) },
    "Create relationship to Country for United States in zone Canada"
);

throws_ok(
    sub { $result->add_states($states{'CA_BC'}) },
    qr /Cannot add state to zone with multiple countries/,
    "Cannot add state to zone with multiple countries"
);

lives_ok(
    sub { $result->remove_countries( $countries{US} ) },
    "Remove United States from zone Canada"
);

throws_ok(
    sub { $result->add_states($countries{CA}) },
    qr /State must be an Interchange6::Schema::Result::State/,
    "Cannot add country with add_states"
);

lives_ok(
    sub { $result->add_states($states{'CA_BC'}) },
    "Add BC to CA"
);

throws_ok(
    sub { $result->add_states([$states{'CA_NT'}, 'FooBar']) },
    qr/State must be an Interchange6::Schema::Result::State/,
    "Fail add FooBar state to CA in arrayref"
);

throws_ok(
    sub { $result->add_states([$states{'CA_NT'}, $countries{US}]) },
    qr/State must be an Interchange6::Schema::Result::State/,
    "Fail add_state country obj to CA in arrayref"
);


lives_ok(
    sub { $result->remove_states($states{'CA_BC'}) },
    "Add BC to CA"
);
lives_ok( sub { $result->remove_countries( [$countries{CA}] ) },
    "Remove country CA (arrayref) from zone Canada" );

lives_ok( sub { $result->add_states($states{'CA_NT'}) },
    "Add state NT to CA zone without country");

is($result->has_country('CA'), 1, "Zone has country Canada");

throws_ok( sub { $result->add_states($states{'CA_NT'}) },
    qr/Zone already includes state: Northwest Te/,
    "Fail add state NT to CA zone second time");

throws_ok( sub { $result->add_states($states{'US_CA'}) },
    qr/State California is not in country Canada/,
    "Fail add state California to Canada zone");

lives_ok(
    sub { $result->add_states($states{'CA_BC'}) },
    "Add BC to CA"
);

throws_ok(
    sub { $result->remove_states(['FooBar']) },
    qr/State must be an Interchange6::Schema::Result::State/,
    "Fail remove_states arrayref of scalar"
);

throws_ok(
    sub { $result->remove_states($countries{US}) },
    qr/State must be an Interchange6::Schema::Result::State/,
    "Fail remove_states arg is Country obj"
);

# CA GST only

lives_ok( sub { $result = $rsetzone->create( { zone => 'CA GST only' } ) },
    "Create zone: CA GST only" );

ok(blessed($result), "Result is blessed");
ok(
    $result->isa('Interchange6::Schema::Result::Zone'),
    "Result is a Zone"
);

lives_ok(
    sub { $result->add_countries( $countries{CA} ) },
    "Create relationship to Country for Canada in zone CA GST only"
);

cmp_ok( $result->has_error, '==', 0, "No errors" );

throws_ok(
    sub { $result->add_countries( $countries{CA} ) },
    qr/Zone already includes country: Canada/,
    "Exception when adding Canada a second time"
);

cmp_ok( $result->has_error, '==', 1, "1 error" );

cmp_deeply(
    $result->errors,
    [ re('^Zone already includes country') ],
    "Error contains 'Failed to add Canada'"
);

throws_ok(
    sub { $result->add_countries(undef) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail add_countries with undef arg"
);

throws_ok(
    sub { $result->add_countries([undef]) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail add_countries with arrayref of undef"
);


throws_ok(
    sub { $result->add_countries('FooBar') },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail add_countries with scalar arg"
);

throws_ok(
    sub { $result->add_countries(['FooBar']) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    "Fail add_countries with arrayref of scalar"
);

throws_ok(
    sub { $result->add_countries( [ $states{US_CA} ] ) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    'Exception add_countries([$state])'
);

$data = [
    $states{CA_AB}, $states{CA_NT}, $states{CA_NU},
    $states{CA_YT}, $states{US_CA}
];

throws_ok(
    sub { $result->add_states($data) },
    qr/State California is not in country Canada/,
    "Exception: create relationship to 4 states in zone CA GST plus US_CA"
);

cmp_ok( $result->country_count, '==', 1, "1 country in zone" );
cmp_ok( $result->state_count,   '==', 0, "0 states in zone" );

$data = [ $states{CA_AB}, $states{CA_NT}, $states{CA_NU}, $states{CA_YT} ];

lives_ok( sub { $result->add_states($data) },
    "Create relationship to 4 states in zone CA GST" );

cmp_ok( $result->error_count, '==', 0, "No errors" )
  || diag Dumper( $zones{'CA GST only'}->errors );

cmp_ok( $result->country_count, '==', 1, "1 country in zone" );
cmp_ok( $result->state_count,   '==', 4, "4 states in zone" );

throws_ok(
    sub { $result->add_countries( $countries{US} ) },
    qr/Cannot add countries to zone containing states/,
    "Exception Cannot add countries to zone containing states"
);

# USA

lives_ok(
    sub { $result = $rsetzone->create( { zone => 'US' } ) },
    "Create zone: US"
);

ok(blessed($result), "Result is blessed");
ok(
    $result->isa('Interchange6::Schema::Result::Zone'),
    "Result is a Zone"
);

lives_ok(
    sub { $result->add_countries( $countries{US} ) },
    "Create relationship to Country for US"
);

lives_ok( sub { $result->add_to_states( $states{US_CA} ) },
    "add CA to zone US" );

throws_ok(
    sub { $result->remove_countries( $countries{US} ) },
    qr/States must be removed before countries/,
    "Exception on remove country"
);

cmp_ok( $result->country_count, '==', 1, "Country till there" );
cmp_ok( $result->state_count,   '==', 1, "State still there" );

lives_ok( sub { $result->remove_states( $states{US_CA} ) },
    "Try to remove state" );

cmp_ok( $result->country_count, '==', 1, "Country till there" );
cmp_ok( $result->state_count,   '==', 0, "State removed" );

lives_ok( sub { $result->remove_countries( $countries{US} ) },
    "Try to remove country" );

cmp_ok( $result->country_count, '==', 0, "Country removed" );

# California

lives_ok(
    sub {
        $result = $rsetzone->create(
            {
                zone => "California",
            }
        );
    },
    "Create California zone"
);

lives_ok( sub { $result->add_to_states( $states{US_CA} ) },
    "add CA to zone California" );

cmp_ok( $result->state_count, '==', 1, "zone has one state" );

lives_ok( sub { $rset = $rsetzone->search( { zone => 'CA GST only' } ) },
    "Search for CA GST only" );
cmp_ok( $rset->count, '==', 1, "Should have one result" );

$result = $rset->next;
cmp_ok( $result->country_count,        '==', 1, "Should have 1 country" );
cmp_ok( $result->state_count,          '==', 4, "and 4 states" );
cmp_ok( $result->has_state('AB'),      '==', 1, "Check has_state('AB')" );
cmp_ok( $result->has_state('Alberta'), '==', 1, "Check has_state('Alberta')" );
cmp_ok( $result->has_state( $states{CA_AB} ), '==', 1,
    'Check has_state($obj)' );
