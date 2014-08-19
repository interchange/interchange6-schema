use utf8;

package Interchange6::Schema::Result::ShipmentDestination;

=head1 NAME

Interchange6::Schema::Result::ShipmentDestination

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 shipment_destinations_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column shipment_destinations_id =>
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0, };

=head2 zones_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column zones_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 shipment_methods_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column shipment_methods_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column active =>
  { data_type => "boolean", default_value => 1, is_nullable => 0 };

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

belongs_to
  zone => "Interchange6::Schema::Result::Zone",
  "zones_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment_method

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

belongs_to
  shipment_method => "Interchange6::Schema::Result::ShipmentMethod",
  "shipment_methods_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
