use utf8;

package Interchange6::Schema::Result::NavigationAttribute;

=head1 NAME

Interchange6::Schema::Result::NavigationAttribute

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

Linker table for connecting the L<Interchange6::Schema::Result::Navigation>
class to the L<Interchange6::Schema::Result::Attribute> class.

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 navigation_id

Foreign key constraint on L<Interchange6::Schema::Result::Navigation/id>
via L</navigation> relationship.

=cut

column navigation_id => { data_type => "integer" };

=head2 attribute_id

Foreign key constraint on L<Interchange6::Schema::Result::Attribute/id>
via L</attribute> relationship.

=cut

column attribute_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 navigation_id attribute_id
=cut

unique_constraint [qw/navigation_id attribute_id/];

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
  "attribute_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 navigation_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttributeValue>

=cut

has_many
  navigation_attribute_values =>
  "Interchange6::Schema::Result::NavigationAttributeValue",
  "navigation_attribute_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
