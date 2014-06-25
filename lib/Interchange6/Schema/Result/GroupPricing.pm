use utf8;
package Interchange6::Schema::Result::GroupPricing;

=head1 NAME

Interchange6::Schema::Result::GroupPricing

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<group_pricing>

=cut

__PACKAGE__->table("group_pricing");

=head1 ACCESSORS

=head2 group_pricing_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'group_pricing_group_pricing_id_seq'

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 quantity

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 roles_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

__PACKAGE__->add_columns(
  "group_pricing_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "group_pricing_group_pricing_id_seq",
  },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
  "quantity",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "roles_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "price",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [10, 2],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</group_pricing_id>

=back

=cut

__PACKAGE__->set_primary_key("group_pricing_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Interchange6::Schema::Result::Role",
  { roles_id => "roles_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
