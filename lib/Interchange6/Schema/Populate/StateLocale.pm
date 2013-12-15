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

sub records {
    my @states;
    my $countries = Interchange6::Schema::Populate::CountryLocale->new->records;

    for my $country_object (@$countries) {
        if ($country_object->{'show_states'} == 1){
        my $country_code = $country_object->{'country_iso_code'};
        my $country = new Locale::SubCountry( $country_object->{'country_iso_code'} );
        my %country_states_keyed_by_code = $country->code_full_name_hash;

            foreach my $state_code ( sort keys %country_states_keyed_by_code ){
                my $state_name = $country_states_keyed_by_code{$state_code};
                # revode (Junk) from some records
                $state_name =~ s/\s*\([^)]*\)//g;
                push @states, {'name' => $state_name, 'state_iso_code' => $state_code, 'country_iso_code' => $country_code};
            }
        }
    }
    
    return \@states;
}

1;
