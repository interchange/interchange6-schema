use utf8;
package Interchange6::Schema::Result::Shipment;

=head1 NAME

Interchange6::Schema::Result::Shipment;

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<shipments>

=cut

__PACKAGE__->table("shipments");

=head1 ACCESSORS

=head2 shipments_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tracking_number

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 shipment_carriers_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 shipment_method_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "shipments_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "tracking_number",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "shipment_carriers_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "shipment_methods_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipments_id>

=back

=cut

__PACKAGE__->set_primary_key("shipments_id");

=head1 RELATIONS

=head2 ShipmentCarrier

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentCarrier>

=cut

__PACKAGE__->belongs_to(
  "ShipmentCarrier",
  "Interchange6::Schema::Result::ShipmentCarrier",
  { shipment_carriers_id => "shipment_carriers_id" },
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
