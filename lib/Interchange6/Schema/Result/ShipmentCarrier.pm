use utf8;
package Interchange6::Schema::Result::ShipmentCarrier;

=head1 NAME

Interchange6::Schema::Result::ShipmentCarrier

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<shipment_carriers>

=cut

__PACKAGE__->table("shipment_carriers");

=head1 ACCESSORS

=head2 shipment_carriers_id

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

=head2 account_number

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "shipment_carriers_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "account_number",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "active",
  { data_type => "boolean", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipment_carriers_id>

=back

=cut

__PACKAGE__->set_primary_key("shipment_carriers_id");

=head1 RELATIONS

=head2 shipment_methods

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

__PACKAGE__->has_many(
  "shipment_methods",
  "Interchange6::Schema::Result::ShipmentMethod",
  { "foreign.shipment_carriers_id" => "self.shipment_carriers_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
