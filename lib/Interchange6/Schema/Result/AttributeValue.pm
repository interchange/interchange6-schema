use utf8;
package Interchange6::Schema::Result::AttributeValue;

=head1 NAME

Interchange6::Schema::Result::AttributeValue

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 attribute_id

Foreign key constraint on L<Interchange6::Schema::Result::Attribute/id>
via L</attribute> relationship.

=cut

column attribute_id => {
    data_type => "integer",
};

=head2 value

Value name, e.g. red or white.

Required.

=cut

column value => {
    data_type   => "varchar",
    size        => 255,
};

=head2 title

Displayed title for attribute value, e.g. Red or White.

Defaults to same value as L</value> via L</new> method.

=cut

column title => {
    data_type     => "varchar",
    size          => 255,
};

=head2 priority

Display order priority.

Defaults to 0.

=cut

column priority => {
    data_type     => "integer",
    default_value => 0,
};

=head2 website_id

The id of the website/shop this attribute value belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 attributes_id value

=cut

unique_constraint [qw/attributes_id value/];

=head1 RELATIONS

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
  "attribute_value_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 user_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttributeValue>

=cut

has_many
  user_attribute_values => "Interchange6::Schema::Result::UserAttributeValue",
  "attribute_value_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 navigation_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttributeValue>

=cut

has_many
  navigation_attribute_values =>
  "Interchange6::Schema::Result::NavigationAttributeValue",
  "attribute_value_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

=head1 METHODS

=head2 new

Set default value of L</title> to L</name>.

=cut

sub new {
    my ( $class, $attrs ) = @_;

    $attrs->{title} = $attrs->{value} unless defined $attrs->{title};

    my $new = $class->next::method($attrs);

    return $new;
}

1;
