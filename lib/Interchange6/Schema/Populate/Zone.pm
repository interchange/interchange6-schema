package Interchange6::Schema::Populate::Zone;

=head1 NAME

Interchange6::Schema::Populate::Zone

=head1 DESCRIPTION

This module provides population capabilities for the Zone schema

=cut

use Moo::Role;

=head1 METHODS

=head2 populate_zones

Returns array reference containing one hash reference per zone ready to use with populate schema method.

=cut

sub populate_zones {
    my $self   = shift;
    my $schema = $self->schema;

    my $countries =
      $schema->resultset('Country')->search( undef, { prefetch => 'states' } );

    my $zones = $schema->resultset('Zone');

    # one zone per country

    while ( my $country = $countries->next ) {

        $zones->create(
            {
                zone           => $country->name,
                zone_countries => [ { country_id => $country->id } ],
            }
        );

        # one zone per state

        my $states = $country->states;

        while ( my $state = $states->next ) {

            my $name = $country->name . " - " . $state->name;

            $zones->create(
                {
                    zone           => $name,
                    zone_countries => [ { country_id => $country->id } ],
                    zone_states    => [ { state_id => $state->id } ],
                }
            );
        }
    }

    # US lower 48 includes all 51 from US except for Alaska and Hawaii

    my $usa = $countries->search(
        {
            'me.iso_code'     => 'US',
            'states.iso_code' => { -not_in => [qw/ AK HI /] }
        }
    )->first;

    $zones->create(
        {
            zone           => 'US lower 48',
            zone_countries => [ { country_id => $usa->id } ],
            zone_states    => [
                map { { 'state_id' => $_ } }
                  $usa->states->get_column('id')->all
            ],
        }
    );

    # EU member states

    my @eu_country_ids = $schema->resultset('Country')->search(
        {
            iso_code => {
                -in => [
                    qw ( BE BG CZ DK DE EE GR ES FR HR IE IT CY LV LT LU HU MT
                      NL AT PL PT RO SI SK FI SE GB )
                ]
            }
        }
    )->get_column('id')->all;

    $zones->create(
        {
            zone => 'EU member states',
            zone_countries =>
              [ map { { 'country_id' => $_ } } @eu_country_ids ],
        }
    );

    # EU VAT countries = EU + Isle of Man

    my @eu_vat_country_ids = $schema->resultset('Country')->search(
        {
            iso_code => {
                -in => [
                    qw ( BE BG CZ DK DE EE GR ES FR HR IE IT CY LV LT LU HU MT
                      NL AT PL PT RO SI SK FI SE GB IM )
                ]
            }
        }
    )->get_column('id')->all;

    $zones->create(
        {
            zone => 'EU VAT countries',
            zone_countries =>
              [ map { { 'country_id' => $_ } } @eu_vat_country_ids ],
        }
    );
}

1;
