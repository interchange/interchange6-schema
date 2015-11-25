use utf8;

package Interchange6::Schema::Result::ProductAttribute;

=head1 NAME

Interchange6::Schema::Result::ProductAttribute

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id =>
  { data_type => "integer", is_auto_increment => 1 };

=head2 product_id

FK on L<Interchange6::Schema::Result::Product/id>.

=cut

column product_id => { data_type => "integer" };

=head2 attribute_id

FK on L<Interchange6::Schema::Result::Attribute/id>.

=cut

column attribute_id => { data_type => "integer" };

=head2 canonical

Determines whether this attribute requires his own product.

Defaults to 1 (true).

=cut

column canonical =>
  { data_type => "boolean", default_value => 1 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 product_id attribute_id

=cut

unique_constraint [qw/product_id attribute_id/];

=head1 RELATIONS

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "product_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Attribute>

=cut

belongs_to
  attribute => "Interchange6::Schema::Result::Attribute",
  "attribute_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttributeValue>

=cut

has_many
  product_attribute_values =>
  "Interchange6::Schema::Result::ProductAttributeValue",
  "product_attribute_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
