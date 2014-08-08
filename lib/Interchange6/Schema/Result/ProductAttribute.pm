use utf8;
package Interchange6::Schema::Result::ProductAttribute;

=head1 NAME

Interchange6::Schema::Result::ProductAttribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product_attributes>

=cut

__PACKAGE__->table("product_attributes");

=head1 ACCESSORS

=head2 product_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 canonical

Determines whether this attribute requires his own product.

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_attributes_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
  "attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
  "canonical",
  { data_type => "boolean", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product_attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("product_attributes_id");

=head1 RELATIONS

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

=head2 attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Attribute>

=cut

__PACKAGE__->belongs_to(
  "attribute",
  "Interchange6::Schema::Result::Attribute",
  { attributes_id => "attributes_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttributeValue>

=cut

__PACKAGE__->has_many(
  "product_attribute_values",
  "Interchange6::Schema::Result::ProductAttributeValue",
  { "foreign.product_attributes_id" => "self.product_attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
