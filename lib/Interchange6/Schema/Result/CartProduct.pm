use utf8;

package Interchange6::Schema::Result::CartProduct;

=head1 NAME

Interchange6::Schema::Result::CartProduct

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 DESCRIPTION

Holds products for related L<Interchange6::Schema::Result::Cart> class and
links to the full product details held in
L<Interchange6::Schema::Result::Product>.

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 cart_id

Foreign key constraint on L<Interchange6::Schema::Result::Cart/id>
via L</cart> relationship.

=cut

column cart_id => {
    data_type      => "integer",
};

=head2 product_id

Foreign key constraint on L<Interchange6::Schema::Result::Product/id>
via L</product> relationship.

=cut

column product_id => {
    data_type => "integer",
};

=head2 cart_position

Integer cart position.

=cut

column cart_position => {
    data_type   => "integer",
};

=head2 quantity

The integer quantity of product in the cart. Defaults to 1.

=cut

column quantity => {
    data_type     => "integer",
    default_value => 1,
};

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type     => "datetime",
    set_on_create => 1,
};

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head2 website_id

The id of the website/shop this cart product belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 cart

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Cart>

=cut

belongs_to
  cart => "Interchange6::Schema::Result::Cart",
  "cart_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "product_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
