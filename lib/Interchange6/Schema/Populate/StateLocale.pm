package Interchange6::Schema::Populate::StateLocale;

=head1 NAME

Interchange6::Schema::Populate::StateLocale

=head1 DESCRIPTION

This module provides population capabilities for the State schema

=cut

use strict;
use warnings;

use Moo;
use Locale::SubCountry;

sub records {
    my $states;
    my %countries = Interchange6::Schema::Populate::CountryLocale->records();

    # populate states hash
    foreach my $country ( sort keys %countries ) {
    if (exists $countries{'show_states' => '1'}) {
    my $country_code = new Locale::SubCountry($country);
    my %country_states_keyed_by_code = $sub_country_code->code_full_name_hash;

        foreach my $state_code ( sort keys %country_states_keyed_by_code ){
        my $state_name = $country_states_keyed_by_code{$state_code};
        # remode (Junk) from some records
        $state_name =~ s/\s*\([^)]*\)//g;
        $states{$state_name} = {'state_iso_code' => $state_code, 'country_iso_code' => $country_code};
        }
    }
    return %states;
}

1;
