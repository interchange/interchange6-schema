use utf8;
package Interchange6::Schema::Result::ShipmentRate;

=head1 NAME

Interchange6::Schema::Result::ShipmentRate;

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<shipment_rates>

=cut

__PACKAGE__->table("shipment_rates");

=head1 ACCESSORS

=head2 shipment_rates_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 zones_id 

  type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

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
  "shipment_rates_id",
  {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "zones_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "weight",
  { data_type => "numeric", default_value => "0.0", is_nullable => 0, size => [10, 2] },
  "price",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [10, 2],
  },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</shipment_rates_id>

=back

=cut

__PACKAGE__->set_primary_key("shipment_rates_id");

=head1 RELATIONS

=head2 Zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

__PACKAGE__->belongs_to(
  "Zone",
  "Interchange6::Schema::Result::Zone",
  { shipment_zones_id => "shipment_zones_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


1;
