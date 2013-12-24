package Interchange6::Schema::Populate::CountryLocale;

=head1 NAME

Interchange6::Schema::Populate::CountryLocale

=head1 DESCRIPTION

This module provides population capabilities for the Country schema

=cut

use strict;
use warnings;

use Moo;
use Locale::SubCountry;

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per country,
ready to use with populate schema method.

=cut

sub records {
    my ( $has_state, $countries );
    my @countries_with_states = qw(US CA); # United States, Canada
    my @countries;
    my $world = new Locale::SubCountry::World;
    my %all_country_keyed_by_code = $world->code_full_name_hash;

    # populate countries hash
    foreach my $country_code ( sort keys %all_country_keyed_by_code ){
        #need regex to clean up records containing 'See (*)'
        my $country_name = $all_country_keyed_by_code{$country_code};
        if ( grep( /^$country_code$/, @countries_with_states ) ) {
            $has_state = '1';
        } else {
            $has_state = '0';
        }
        push @countries, {'country_iso_code' => $country_code, 'name' => $country_name, 'show_states' => $has_state};
    }

    return \@countries;
}

1;
