use utf8;
package Interchange6::Schema::Result::Attribute;

=head1 NAME

Interchange6::Schema::Result::Attribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<attributes>

=cut

__PACKAGE__->table("attributes");

=head1 ACCESSORS

=head2 attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

Attribute name, e.g. color or size.

  data_type: 'varchar'
  is_nullable: 0

=head2 type

Attribute type.

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0

=head2 title

Displayed title for attribute name, e.g. Color or Size.

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0

=head2 dynamic

Flag to designate the attribute as being dynamic.

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 priority

Display order priority.

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "attributes_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0},
  "type",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "title",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "dynamic",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("attributes_id");

=head1 RELATIONS

=head2 AttributeValue

Type: has_many

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

__PACKAGE__->has_many(
  "AttributeValue",
  "Interchange6::Schema::Result::AttributeValue",
  { "foreign.attributes_id" => "self.attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ProductAttribute

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

__PACKAGE__->has_many(
  "ProductAttribute",
  "Interchange6::Schema::Result::ProductAttribute",
  { "foreign.attributes_id" => "self.attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 NavigationAttribute

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

__PACKAGE__->has_many(
  "NavigationAttribute",
  "Interchange6::Schema::Result::NavigationAttribute",
  { "foreign.attributes_id" => "self.attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
