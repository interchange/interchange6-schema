package Interchange6::Schema::Populate::StateLocale;

=head1 NAME

Interchange6::Schema::Populate::StateLocale

=head1 DESCRIPTION

This module provides population capabilities for the State schema

=cut

use strict;
use warnings;

use Moo;
use Interchange6::Schema::Populate::CountryLocale;
use Locale::SubCountry;

=head1 ATTRIBUTES

=head2 generate_states_id

Boolean specifiying whether the L</records> method should add states_id. Defaults to 0.

=cut

has generate_states_id => (
    is      => 'ro',
    default => 0,
);

=head2 states_id_initial_value

The initial value of the states_id sequence (only used if generate_states_id is 1). Default is 1.

=cut

has states_id_initial_value => (
    is      => 'ro',
    default => 1,
);

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per state,
ready to use with populate schema method.

=cut

sub records {
    my $self      = shift;
    my $states_id = $self->states_id_initial_value;

    my @states;
    my $countries = Interchange6::Schema::Populate::CountryLocale->new->records;

    for my $country_object (@$countries) {
        if ( $country_object->{'show_states'} == 1 ) {
            my $country_code = $country_object->{'iso_code'};
            my $country = Locale::SubCountry->new( $country_code );

            next unless $country->has_sub_countries;

            my %country_states_keyed_by_code = $country->code_full_name_hash;

            foreach my $state_code ( sort keys %country_states_keyed_by_code ) {

                # some US 'states' are not actually states of the US
                next
                  if ( $country_code eq 'US'
                    && $state_code =~ /(AS|GU|MP|PR|UM|VI)/ );

                my $state_name = $country_states_keyed_by_code{$state_code};

                # remove (Junk) from some records
                $state_name =~ s/\s*\([^)]*\)//g;
                if ( $self->generate_states_id == 1 ) {
                    push @states,
                      {
                        'states_id'        => $states_id++,
                        'name'             => $state_name,
                        'iso_code'         => $state_code,
                        'country_iso_code' => $country_code
                      };
                }
                else {
                    push @states,
                      {
                        'name'             => $state_name,
                        'iso_code'         => $state_code,
                        'country_iso_code' => $country_code
                      };
                }
            }
        }
    }

    return \@states;
}

1;
