use utf8;

package Interchange6::Schema::Result::Inventory;

=head1 NAME

Interchange6::Schema::Result::Inventory

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

The Inventory class is used to store current stock levels for products.

=head1 ACCESSORS

=head2 sku

The SKU of the product.

Primary key and foreign constraint on
L<Interchange6::Schema::Result::Product/sku> via L</product> relationship.

=cut

primary_column sku =>
  { data_type => "varchar", is_foreign_key => 1, size => 64 };

=head2 quantity

This is the quantity currently held in stock.

Defaults to 0.

=cut

column quantity => { data_type => "integer", default_value => 0 };

=head1 RELATIONS

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
