use utf8;
package Interchange6::Schema::Result::Attribute;

=head1 NAME

Interchange6::Schema::Result::Attribute

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column attributes_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
};

=head2 name

Attribute name, e.g. color or size.

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

column name => {
    data_type   => "varchar",
    is_nullable => 0,
    size        => 255,
};

=head2 type

Attribute type.

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column type => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255,
};

=head2 title

Displayed title for attribute name, e.g. Color or Size.

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column title => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255,
};

=head2 dynamic

Flag to designate the attribute as being dynamic.

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=cut

column dynamic => {
    data_type     => "boolean",
    default_value => 0,
    is_nullable   => 0,
};

=head2 priority

Display order priority.

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column priority => {
    data_type     => "integer",
    default_value => 0,
    is_nullable   => 0,
};

=head1 RELATIONS

=head2 attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

has_many
  attribute_values => "Interchange6::Schema::Result::AttributeValue",
  { "foreign.attributes_id" => "self.attributes_id" },
  { cascade_copy            => 0, cascade_delete => 0 };

=head2 product_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

has_many
  product_attributes => "Interchange6::Schema::Result::ProductAttribute",
  { "foreign.attributes_id" => "self.attributes_id" },
  { cascade_copy            => 0, cascade_delete => 0 };

=head2 navigation_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

has_many
  navigation_attributes => "Interchange6::Schema::Result::NavigationAttribute",
  { "foreign.attributes_id" => "self.attributes_id" },
  { cascade_copy            => 0, cascade_delete => 0 };

1;
