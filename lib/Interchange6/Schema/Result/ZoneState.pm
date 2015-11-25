use utf8;

package Interchange6::Schema::Result::ZoneState;

=head1 NAME

Interchange6::Schema::Result::ZoneState

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 zone_id

FK on L<Interchange6::Schema::Result::Zone/id>,

=cut

column zone_id => { data_type => "integer" };

=head2 state_id

FK on L<Interchange6::Schema::Result::Zone/id>,

=cut

column state_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</zone_id>

=item * L</state_id>

=back

=cut

primary_key "zone_id", "state_id";

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

belongs_to
  zone => "Interchange6::Schema::Result::Zone",
  "zone_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 state

Type: belongs_to

Related object: L<Interchange6::Schema::Result::State>

=cut

belongs_to
  state => "Interchange6::Schema::Result::State",
  "state_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
