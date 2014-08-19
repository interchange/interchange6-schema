use utf8;

package Interchange6::Schema::Result::ZoneCountry;

=head1 NAME

Interchange6::Schema::Result::ZoneCountry

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 zones_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column zones_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 country_iso_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 2

=cut

column country_iso_code =>
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 2 };

=head1 PRIMARY KEY

=over 4

=item * L</zones_id>

=item * L</country_iso_code>

=back

=cut

primary_key "zones_id", "country_iso_code";

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

belongs_to
  zone => "Interchange6::Schema::Result::Zone",
  "zones_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

belongs_to
  country => "Interchange6::Schema::Result::Country",
  "country_iso_code",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
