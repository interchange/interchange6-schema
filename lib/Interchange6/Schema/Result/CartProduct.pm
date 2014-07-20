use utf8;
package Interchange6::Schema::Result::CartProduct;

=head1 NAME

Interchange6::Schema::Result::CartProduct

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<cart_products>

=cut

__PACKAGE__->table("cart_products");

=head1 ACCESSORS

=head2 cart_products_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'cart_product_cart_products_id_seq'

=head2 carts_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 cart_position

  data_type: 'integer'
  is_nullable: 0

=head2 quantity

  data_type: 'integer'
  default_value: 1
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
  "cart_products_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "cart_product_cart_products_id_seq",
  },
  "carts_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
  "cart_position",
  { data_type => "integer", is_nullable => 0 },
  "quantity",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cart_products_id>

=back

=cut

__PACKAGE__->set_primary_key(qw(cart_products_id));

=head1 RELATIONS

=head2 cart

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Cart>

=cut

__PACKAGE__->belongs_to(
  "cart",
  "Interchange6::Schema::Result::Cart",
  { carts_id => "carts_id" },
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

=head2 product_cart_extras

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductCartExtra>

=cut

__PACKAGE__->has_many(
  "product_cart_extras",
  "Interchange6::Schema::Result::ProductCartExtras",
  { "foreign.cart_products_id" => "self.cart_products_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
