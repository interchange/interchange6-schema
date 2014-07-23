use utf8;
package Interchange6::Schema::Result::ShipmentMethod;

=head1 NAME

Interchange6::Schema::Result::ShipmentMethod

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<shipment_methods>

=cut

__PACKAGE__->table("shipment_methods");

=head1 ACCESSORS

=head2 shipment_methods_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 shipment_carriers_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 zones_id

  type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "shipment_methods_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "shipment_carriers_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "zones_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipment_methods_id>

=back

=cut

__PACKAGE__->set_primary_key("shipment_methods_id");

=head1 RELATIONS

=head2 shipment_carrier

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentCarrier>

=cut

__PACKAGE__->belongs_to(
  "shipment_carrier",
  "Interchange6::Schema::Result::ShipmentCarrier",
  { shipment_carriers_id => "shipment_carriers_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

__PACKAGE__->belongs_to(
  "zone",
  "Interchange6::Schema::Result::Zone",
  { zones_id => "zones_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 shipment_rates

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentRate>

=cut

__PACKAGE__->has_many(
  "shipment_rates",
  "Interchange6::Schema::Result::ShipmentRate",
  { "foreign.shipment_methods_id" => "self.shipment_methods_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
