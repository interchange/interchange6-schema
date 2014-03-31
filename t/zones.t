use strict;
use warnings;

use Data::Dumper;

use Test::Most 'die', tests => 170;

use Interchange6::Schema;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use DateTime;
use DBICx::TestDatabase;

my ( $rset, %countries, %states, %zones, $data, $result );

my $dt = DateTime->now;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;
my $pop_states    = Interchange6::Schema::Populate::StateLocale->new->records;
my $rsetzone      = $schema->resultset('Zone');

lives_ok( sub { $schema->populate( Country => $pop_countries ) },
    "populate countries" );

lives_ok { $schema->populate( State => $pop_states ) } "populate states";

# stuff countries and states into hashes to save lots of lookups later

$rset = $schema->resultset('Country')->search( {} );
while ( my $res = $rset->next ) {
    $countries{ $res->country_iso_code } = $res;
}

$rset = $schema->resultset('State')->search( {} );
while ( my $res = $rset->next ) {
    $states{ $res->country_iso_code . "_" . $res->state_iso_code } = $res;
}

# create zones

# EU zone with countries added to zone in loop below

lives_ok(
    sub { $zones{EU} = $rsetzone->create( { zone => "EU VAT countries" } ) },
    "Create zone: EU VAT countries" );

my @eu_vat_countries =
  qw( BE BG CZ DK DE EE GR ES FR HR IE IT CY LV LT LU HU MT NL AT PL PT RO SI SK FI SE GB IM );

# create a zone for each EU vat country

foreach my $code (@eu_vat_countries) {

    my $country = $countries{$code};

    lives_ok( sub { $zones{EU}->add_countries($country) },
        "Create relationship to Country in zone EU VAT countries" );

    unless ( $code eq 'IM' ) {

        # not Isle of Man

        my $zone;

        lives_ok(
            sub { $zone = $rsetzone->create( { zone => $country->name } ) },
            "Create zone: " . $country->name );

        $zones{ $country->name } = $zone;

        lives_ok( sub { $zone->add_countries($country) },
            "Create relationship to Country in zone " . $country->name );

        cmp_ok( $zone->country_count, '==', 1, "1 country in zone" )
          || diag Dumper( $zone->errors );

        if ( $code eq 'GB' ) {

            # add Isle of Man to United Kingdom (GB) zone

            my $country = $countries{IM};

            lives_ok(
                sub { $zone->add_countries($country) },
                "Create relationship to Country for IM in zone United Kingdom"
            );
            cmp_ok( $zone->country_count, '==', 2, "2 countries in zone" )
              || diag Dumper( $zone->errors );
        }
    }
}

my $zone_eu_count = scalar @eu_vat_countries;

cmp_ok( $zones{EU}->country_count,
    '==', $zone_eu_count, "$zone_eu_count countries in zone EU VAT countries" );

# now Canada

lives_ok(
    sub {
        $zones{'Canada'} =
          $rsetzone->create( { zone => 'Canada' } );
    },
    "Create zone: Canada"
);

lives_ok(
    sub { $zones{'Canada'}->add_countries( $countries{CA} ) },
    "Create relationship to Country for Canada in zone Canada"
);

cmp_ok( $zones{'Canada'}->country_count, '==', 1, "1 country in zone" )
  || diag Dumper( $zones{'Canada'}->errors );

lives_ok(
    sub {
        $zones{'CA GST only'} =
          $rsetzone->create( { zone => 'CA GST only' } );
    },
    "Create zone: CA GST only"
);

lives_ok(
    sub { $result = $zones{'CA GST only'}->add_countries( $countries{CA} ) },
    "Create relationship to Country for Canada in zone CA GST only"
);

cmp_ok(
    ref($result), 'eq',
    'Interchange6::Schema::Result::Zone',
    "Check result is a Zone"
);

cmp_ok( $zones{'CA GST only'}->has_error, '==', 0, "No errors" );

throws_ok(
    sub { $result = $zones{'CA GST only'}->add_countries( $countries{CA} ) },
    qr/Zone already includes country: Canada/,
    "Exception when adding Canada a second time"
);

cmp_ok( $zones{'CA GST only'}->has_error, '==', 1, "1 error" );

cmp_deeply(
    $zones{'CA GST only'}->errors,
    [ re('^Zone already includes country') ],
    "Error contains 'Failed to add Canada'"
);

throws_ok( sub { $zones{'CA GST only'}->add_countries('FooBar') },
    qr/Bad arg passed to add_countries/,
    "Exception Bad arg passed to add_countries"
);

throws_ok( sub { $zones{'CA GST only'}->add_countries([$states{US_CA}]) },
    qr/Country must be an Interchange6::Schema::Result::Country/,
    'Exception add_countries([$state])'
);

$data = [ $states{CA_AB}, $states{CA_NT}, $states{CA_NU}, $states{CA_YT}, $states{US_CA} ];

throws_ok(
    sub { $zones{'CA GST only'}->add_states($data) },
    qr/State California is not in country Canada/,
    "Exception: create relationship to 4 states in zone CA GST plus US_CA"
);

cmp_ok( $zones{'CA GST only'}->country_count, '==', 1, "1 country in zone" );
cmp_ok( $zones{'CA GST only'}->state_count,   '==', 0, "0 states in zone" );

$data = [ $states{CA_AB}, $states{CA_NT}, $states{CA_NU}, $states{CA_YT} ];

lives_ok(
    sub { $zones{'CA GST only'}->add_states($data) },
    "Create relationship to 4 states in zone CA GST"
);

cmp_ok( $zones{'CA GST only'}->error_count, '==', 0, "No errors" )
  || diag Dumper( $zones{'CA GST only'}->errors );

cmp_ok( $zones{'CA GST only'}->country_count, '==', 1, "1 country in zone" );
cmp_ok( $zones{'CA GST only'}->state_count,   '==', 4, "4 states in zone" );

throws_ok( sub { $zones{'CA GST only'}->add_countries($countries{US}) },
    qr/Cannot add countries to zone containing states/,
    "Exception Cannot add countries to zone containing states"
);

# USA

lives_ok(
    sub {
        $zones{US} = $rsetzone->create( { zone => 'United States' } );
    },
    "Create zone: United States"
);

lives_ok(
    sub { $result = $zones{US}->add_countries( $countries{US} ) },
    "Create relationship to Country for United States"
);
cmp_ok(
    ref($result), 'eq',
    'Interchange6::Schema::Result::Zone',
    "Check result is a Zone"
);

lives_ok( sub { $zones{US}->add_to_states( $states{US_CA} ) },
    "add CA to zone United States" );

throws_ok( sub { $result = $zones{US}->remove_countries( $countries{US} ) },
    qr/States must be removed before countries/,
    "Exception on remove country" );

cmp_ok( $zones{US}->country_count, '==', 1, "Country till there" );
cmp_ok( $zones{US}->state_count,   '==', 1, "State still there" );

lives_ok( sub { $result = $zones{US}->remove_states( $states{US_CA} ) },
    "Try to remove state" );

cmp_ok( $zones{US}->country_count, '==', 1, "Country till there" );
cmp_ok( $zones{US}->state_count,   '==', 0, "State removed" );

lives_ok( sub { $result = $zones{US}->remove_countries( $countries{US} ) },
    "Try to remove country" );

cmp_ok( $zones{US}->country_count, '==', 0, "Country removed" );

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

# test zone contents

lives_ok( sub { $rset = $rsetzone->search( { zone => 'EU VAT countries' } ) },
    "Search for EU VAT countries" );
cmp_ok( $rset->count, '==', 1, "Should have one result" );

$result = $rset->next;
cmp_ok( $result->country_count,        '==', 29, "Should have 29 countries" );
cmp_ok( $result->state_count,          '==', 0,  "and zero states" );
cmp_ok( $result->has_country('MT'),    '==', 1,  "Check has_country('MT')" );
cmp_ok( $result->has_country('Malta'), '==', 1,  "Check has_country('Malta')" );
cmp_ok( $result->has_country( $countries{MT} ),
    '==', 1, 'Check has_country($obj)' );
cmp_ok( $result->has_country('US'), '==', 0, "Check has_country('US') fails" );
cmp_ok( $result->has_country('United States'),
    '==', 0, "Check has_country('United States') fails" );

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
