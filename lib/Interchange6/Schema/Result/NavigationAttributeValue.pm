use utf8;

package Interchange6::Schema::Result::NavigationAttributeValue;

=head1 NAME

Interchange6::Schema::Result::NavigationAttributeValue

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 navigation_attribute_values_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column navigation_attribute_values_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
};

=head2 navigation_attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column navigation_attributes_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 attribute_values_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column attribute_values_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head1 RELATIONS

=head2 navigation_attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

belongs_to
  navigation_attribute => "Interchange6::Schema::Result::NavigationAttribute",
  "navigation_attributes_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 attribute_value

Type: belongs_to

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

belongs_to
  attribute_value => "Interchange6::Schema::Result::AttributeValue",
  "attribute_values_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
