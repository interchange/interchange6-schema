use utf8;

package Interchange6::Schema::Result::CartProduct;

=head1 NAME

Interchange6::Schema::Result::CartProduct

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 cart_products_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'cart_product_cart_products_id_seq'
  primary key

=cut

primary_column cart_products_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "cart_product_cart_products_id_seq",
};

=head2 carts_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column carts_id => {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
};

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

column sku => {
    data_type      => "varchar",
    is_foreign_key => 1,
    is_nullable    => 0,
    size           => 64,
};

=head2 cart_position

  data_type: 'integer'
  is_nullable: 0

=cut

column cart_position => {
    data_type   => "integer",
    is_nullable => 0,
};

=head2 quantity

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=cut

column quantity => {
    data_type     => "integer",
    default_value => 1,
    is_nullable   => 0,
};

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column created => {
    data_type     => "datetime",
    set_on_create => 1,
    is_nullable   => 0,
};

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable   => 0,
};

=head1 RELATIONS

=head2 cart

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Cart>

=cut

belongs_to
  cart => "Interchange6::Schema::Result::Cart",
  { carts_id      => "carts_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  { sku           => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
