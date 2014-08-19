use utf8;

package Interchange6::Schema::Result::Orderline;

=head1 NAME

Interchange6::Schema::Result::Orderline

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 orderlines_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'orderlines_orderlines_id_seq'
  primary key

=cut

primary_column orderlines_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "orderlines_orderlines_id_seq",
};

=head2 orders_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column orders_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 order_position

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column order_position =>
  { data_type => "integer", default_value => 0, is_nullable => 0 };

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 };

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column name => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 short_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

=cut

column short_description => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 500
};

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

column description => { data_type => "text", is_nullable => 0 };

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,3]

=cut

column weight => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 3 ]
};

=head2 quantity

  data_type: 'integer'
  is_nullable: 1

=cut

column quantity => { data_type => "integer", is_nullable => 1 };

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column price => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ],
};

=head2 subtotal

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=cut

column subtotal => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 11, 2 ],
};

=head2 shipping

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=cut

column shipping => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 11, 2 ],
};

=head2 handling

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=cut

column handling => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 11, 2 ],
};

=head2 salestax

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=cut

column salestax => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 11, 2 ],
};

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 24

=cut

column status =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 24 };

=head1 RELATIONS

=head2 order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

belongs_to
  order => "Interchange6::Schema::Result::Order",
  "orders_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 orderlines_shipping

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderlinesShipping>

=cut

has_many
  orderlines_shipping => "Interchange6::Schema::Result::OrderlinesShipping",
  "orderlines_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 addresses

Type: many_to_many

Composing rels: L</orderlines_shipping> -> address

=cut

many_to_many addresses => "orderlines_shipping", "address";

1;
