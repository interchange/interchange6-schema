package Interchange6::Schema::Populate::Zone;

=head1 NAME

Interchange6::Schema::Populate::Zone

=head1 DESCRIPTION

This module provides population capabilities for the Zone schema

=cut

use strict;
use warnings;

use Moo;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;

=head1 ATTRIBUTES

=head2 states_id_initial_value

The initial value of the states_id sequence passed to L<Interchange6::Schema::Populate::StateLocale/new>. Defaults to 1.

=cut

has states_id_initial_value => (
    is      => 'ro',
    default => 1,
);

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per zone ready to use with populate schema method.

=cut

sub records {
    my $self = shift;
    my ( @zones, %states_by_country );

    my $countries = Interchange6::Schema::Populate::CountryLocale->new->records;

    my $states = Interchange6::Schema::Populate::StateLocale->new(
        { generate_states_id      => 1,
          states_id_initial_value => $self->states_id_initial_value,
        } )->records;

    foreach my $state (@$states) {
        $states_by_country{ $state->{country_iso_code} }
          { $state->{state_iso_code} } = $state;
    }

    # one zone per country

    foreach my $country (@$countries) {

        my $country_name = $country->{'name'};
        my $country_code = $country->{'country_iso_code'};

        push @zones,
          {
            zone           => $country_name,
            zone_countries => [ { country_iso_code => $country_code } ],
          };

        # one zone per state

        if ( exists $states_by_country{$country_code} ) {

            foreach
              my $state_code ( keys %{ $states_by_country{$country_code} } )
            {

                my $state = $states_by_country{$country_code}{$state_code};

                my $zone = $country_name . " - " . $state->{'name'};

                push @zones,
                  {
                    zone           => $zone,
                    zone_countries => [ { country_iso_code => $country_code } ],
                    zone_states    => [ { states_id => $state->{'states_id'} } ],
                  };
            }
        }
    }

    # US lower 48 includes all 51 from US except for Alaska and Hawaii
    push @zones,
      {
        zone           => 'US lower 48',
        zone_countries => [ { country_iso_code => 'US' } ],
        zone_states    => [
            map { { 'states_id' => $states_by_country{US}{$_}->{'states_id'} } }
            grep { !/(AK|HI)/ } keys %{ $states_by_country{US} }
        ],
      };

    # EU member states
    push @zones, {
        zone           => 'EU member states',
        zone_countries => [
            map { { 'country_iso_code' => $_ } }
              qw ( BE BG CZ DK DE EE GR ES FR HR IE IT CY LV LT LU HU MT
              NL AT PL PT RO SI SK FI SE GB )
        ],
    };

    # EU VAT countries = EU + Isle of Man
    push @zones, {
        zone           => 'EU VAT countries',
        zone_countries => [
            map { { 'country_iso_code' => $_ } }
              qw ( BE BG CZ DK DE EE GR ES FR HR IE IT CY LV LT LU HU MT
              NL AT PL PT RO SI SK FI SE GB IM )
        ],
    };

    return \@zones;
}

1;
