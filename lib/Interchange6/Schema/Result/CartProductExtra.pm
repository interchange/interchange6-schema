use utf8;
package Interchange6::Schema::Result::CartProductExtra;

=head1 NAME

Interchange6::Schema::Result::CartProductExtra

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<cart_product_extras>

=cut

__PACKAGE__->table("cart_product_extras");

=head1 ACCESSORS

=head2 cart_product_extras_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'cart_product_extras_cart_product_extras_id_seq'

=head2 cart_products_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 value

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

__PACKAGE__->add_columns(
  "cart_product_extras_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "cart_product_extras_cart_product_extras_id_seq",
  },
  "cart_products_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar", size => 255, default_value => "", is_nullable => 0 },
  "value",
  { data_type => "varchar", size => 255, default_value => "", is_nullable => 0 },
  "price",
  { data_type => "numeric", default_value => "0.0", is_nullable => 0, size => [10, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</cart_product_extras_id>

=back

=cut

__PACKAGE__->set_primary_key("cart_product_extras_id");

=head1 RELATIONS

=head2 cart_product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::CartProduct>

=cut

__PACKAGE__->belongs_to(
  "cart_product",
  "Interchange6::Schema::Result::CartProduct",
  { cart_products_id => "cart_products_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
