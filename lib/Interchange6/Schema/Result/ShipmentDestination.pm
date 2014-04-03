use utf8;
package Interchange6::Schema::Result::ShipmentDestination;

=head1 NAME

Interchange6::Schema::Result::ShipmentDestination;

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<shipment_destinations>

=cut

__PACKAGE__->table("shipment_destinations");

=head1 ACCESSORS

=head2 shipment_destinations

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 zones_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 shipment_methods_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "shipment_destinations_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "zones_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "shipment_methods_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipment_destinations_id>

=back

=cut

__PACKAGE__->set_primary_key("shipment_destinations_id");

=head1 RELATIONS

=head2 Zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

__PACKAGE__->belongs_to(
  "Zone",
  "Interchange6::Schema::Result::Zone",
  { zones_id => "zones_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 ShipmentMethod

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

__PACKAGE__->belongs_to(
  "ShipmentMethod",
  "Interchange6::Schema::Result::ShipmentMethod",
  { shipment_methods_id => "shipment_methods_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


1;
