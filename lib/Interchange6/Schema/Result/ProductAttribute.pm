use utf8;

package Interchange6::Schema::Result::ProductAttribute;

=head1 NAME

Interchange6::Schema::Result::ProductAttribute

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 product_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column product_attributes_id =>
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0, };

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 };

=head2 attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column attributes_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 canonical

Determines whether this attribute requires his own product.

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column canonical =>
  { data_type => "boolean", default_value => 1, is_nullable => 0 };

=head1 RELATIONS

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Attribute>

=cut

belongs_to
  attribute => "Interchange6::Schema::Result::Attribute",
  "attributes_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttributeValue>

=cut

has_many
  product_attribute_values =>
  "Interchange6::Schema::Result::ProductAttributeValue",
  "product_attributes_id",
  { cascade_copy => 0, cascade_delete => 0 };

1;
