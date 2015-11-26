use utf8;

package Interchange6::Schema::Result::ZoneCountry;

=head1 NAME

Interchange6::Schema::Result::ZoneCountry

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 zone_id

FK on L<Interchange6::Schema::Result::Zone/id>.

=cut

column zone_id => { data_type => "integer" };

=head2 country_id

FK on L<Interchange6::Schema::Result::Country/id>.

=cut

column country_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</zone_id>

=item * L</country_id>

=back

=cut

primary_key "zone_id", "country_id";

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

belongs_to
  zone => "Interchange6::Schema::Result::Zone",
  "zone_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

belongs_to
  country => "Interchange6::Schema::Result::Country",
  "country_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
