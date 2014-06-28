use utf8;
package Interchange6::Schema::Result::ProductAttributeValue;

=head1 NAME

Interchange6::Schema::Result::ProductAttributeValue

=cut

use strict;
use warnings;
use base 'DBIx::Class::Core';

=head1 TABLE: C<products_attributes_values>

=cut

__PACKAGE__->table("products_attributes_values");

=head1 ACCESSORS

=head2 product_attributes_values_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 product_attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 attribute_values_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_attributes_values_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "product_attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
  "attribute_values_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
);

=head1 PRIMARY KEY

=over 4

=item * L</product_attributes_values_id>

=back

=cut

__PACKAGE__->set_primary_key("product_attributes_values_id");

=head1 RELATIONS

=head2 product_attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

__PACKAGE__->belongs_to(
  "product_attribute",
  "Interchange6::Schema::Result::ProductAttribute",
  { product_attributes_id => "product_attributes_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 attribute_value

Type: belongs_to

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

__PACKAGE__->belongs_to(
  "attribute_value",
  "Interchange6::Schema::Result::AttributeValue",
  { attribute_values_id => "attribute_values_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
