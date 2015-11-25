use utf8;

package Interchange6::Schema::Result::ProductAttributeValue;

=head1 NAME

Interchange6::Schema::Result::ProductAttributeValue

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id =>
  { data_type => "integer", is_auto_increment => 1 };

=head2 product_attribute_id

FK on L<Interchange6::Schema::Result::ProductAttribute/id>.

=cut

column product_attribute_id => { data_type => "integer" };

=head2 attribute_value_id

FK on L<Interchange6::Schema::Result::AttributeValue/id>.

=cut

column attribute_value_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 product_attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

belongs_to
  product_attribute => "Interchange6::Schema::Result::ProductAttribute",
  "product_attribute_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 attribute_value

Type: belongs_to

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

belongs_to
  attribute_value => "Interchange6::Schema::Result::AttributeValue",
  "attribute_value_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
