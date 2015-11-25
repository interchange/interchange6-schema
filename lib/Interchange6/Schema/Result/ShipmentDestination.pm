use utf8;

package Interchange6::Schema::Result::ShipmentDestination;

=head1 NAME

Interchange6::Schema::Result::ShipmentDestination

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id =>
  { data_type => "integer", is_auto_increment => 1 };

=head2 zone_id

FK on L<Interchange6::Schema::Result::Zone/id>.

=cut

column zone_id => { data_type => "integer" };

=head2 shipment_method_id

FK on L<Interchange6::Schema::Result::ShipmentMethod/id>.

=cut

column shipment_method_id => { data_type => "integer" };

=head2 active

Whether this shipment destination record is active. Defaults to 1 (true).

=cut

column active =>
  { data_type => "boolean", default_value => 1 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

belongs_to
  zone => "Interchange6::Schema::Result::Zone",
  "zone_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment_method

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

belongs_to
  shipment_method => "Interchange6::Schema::Result::ShipmentMethod",
  "shipment_method_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
