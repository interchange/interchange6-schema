use utf8;

package Interchange6::Schema::Result::NavigationProduct;

=head1 NAME

Interchange6::Schema::Result::NavigationProduct

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 };

=head2 navigation_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column navigation_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 16

=cut

column type =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 16 };

=head1 PRIMARY KEY

=over 4

=item * L</sku>

=item * L</navigation_id>

=back

=cut

primary_key "sku", "navigation_id";

=head1 RELATIONS

=head2 navigation

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

belongs_to
  navigation => "Interchange6::Schema::Result::Navigation",
  "navigation_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 _product_with_selling_price

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ProductWithSellingPrice>

The related object is a view which requires a number of bind values. This
relationship is normally only accessed using the method
L<Interchange6::Schema::ResultSet::NavigationProduct/product_with_selling_price>
which passes the required bind values.

=cut

belongs_to
  _product_with_selling_price =>
  "Interchange6::Schema::Result::ProductWithSellingPrice",
  "sku";

1;
