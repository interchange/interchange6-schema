use utf8;
package Interchange6::Schema::Result::Orderline;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Orderline

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<orderlines>

=cut

__PACKAGE__->table("orderlines");

=head1 ACCESSORS

=head2 orderlines_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'orderlines_orderlines_id_seq'

=head2 orders_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 order_position

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 short_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

=head2 description

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,3]

=head2 quantity

  data_type: 'integer'
  is_nullable: 1

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=head2 subtotal

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 shipping

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 handling

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 salestax

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 24

=cut

__PACKAGE__->add_columns(
  "orderlines_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "orderlines_orderlines_id_seq",
  },
  "orders_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "order_position",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "short_description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 500 },
  "description",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "weight",
  { data_type => "numeric", default_value => "0.0", is_nullable => 0, size => [10,3] },
  "quantity",
  { data_type => "integer", is_nullable => 1 },
  "price",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [10, 2],
  },
  "subtotal",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "shipping",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "handling",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "salestax",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "status",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 24 },
);

=head1 PRIMARY KEY

=over 4

=item * L</orderlines_id>

=back

=cut

__PACKAGE__->set_primary_key("orderlines_id");

=head1 RELATIONS

=head2 Order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

__PACKAGE__->belongs_to(
  "Order",
  "Interchange6::Schema::Result::Order",
  { orders_id => "orders_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 OrderlinesShipping

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderlinesShipping>

=cut

__PACKAGE__->has_many(
  "OrderlinesShipping",
  "Interchange6::Schema::Result::OrderlinesShipping",
  { "foreign.orderlines_id" => "self.orderlines_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "Product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 addresses

Type: many_to_many

Composing rels: L</OrderlinesShipping> -> Address

=cut

__PACKAGE__->many_to_many("addresses", "OrderlinesShipping", "Address");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3+tUSeYl2Xp0a2lIU3z4TQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
