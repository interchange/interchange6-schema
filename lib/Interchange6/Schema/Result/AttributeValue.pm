use utf8;
package Interchange6::Schema::Result::AttributeValue;

=head1 NAME

Interchange6::Schema::Result::AttributeValue

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<attribute_values>

=cut

__PACKAGE__->table("attribute_values");

=head1 ACCESSORS

=head2 attribute_values_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 value

Value name, e.g. red or white.

  data_type: 'varchar'
  is_nullable: 0

=head2 title

Displayed title for attribute value, e.g. Red or White.

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0

=head2 priority

Display order priority.

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "attribute_values_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
  "value",
  { data_type => "varchar", is_nullable => 0},
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0 },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</attribute_values_id>

=back

=cut

__PACKAGE__->set_primary_key("attribute_values_id");

=head1 RELATIONS

=head2 Attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Attribute>

=cut

__PACKAGE__->belongs_to(
  "Attribute",
  "Interchange6::Schema::Result::Attribute",
  { attributes_id => "attributes_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 ProductAttributeValue

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttributeValue>

=cut

__PACKAGE__->has_many(
  "ProductAttributeValue",
  "Interchange6::Schema::Result::ProductAttributeValue",
  { "foreign.attribute_values_id" => "self.attribute_values_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 UserAttributeValue

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttributeValue>

=cut

__PACKAGE__->has_many(
  "UserAttributeValue",
  "Interchange6::Schema::Result::UserAttributeValue",
  { "foreign.attribute_values_id" => "self.attribute_values_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 NavigationAttributeValue

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttributeValue>

=cut

__PACKAGE__->has_many(
  "NavigationAttributeValue",
  "Interchange6::Schema::Result::NavigationAttributeValue",
  { "foreign.attribute_values_id" => "self.attribute_values_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
