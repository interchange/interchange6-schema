use utf8;

package Interchange6::Schema::Result::NavigationAttribute;

=head1 NAME

Interchange6::Schema::Result::NavigationAttribute

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 navigation_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column navigation_attributes_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
};

=head2 navigation_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column navigation_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column attributes_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head1 RELATIONS

=head2 navigation

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

belongs_to
  navigation => "Interchange6::Schema::Result::Navigation",
  "navigation_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Attribute>

=cut

belongs_to
  attribute => "Interchange6::Schema::Result::Attribute",
  "attributes_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 navigation_attribute_values

Type: belongs_to

Related object: L<Interchange6::Schema::Result::NavigationAttributeValue>

=cut

has_many
  navigation_attribute_values =>
  "Interchange6::Schema::Result::NavigationAttributeValue",
  "navigation_attributes_id",
  { cascade_copy => 0, cascade_delete => 0 };

1;
