use utf8;
package Interchange6::Schema::Result::NavigationAttributeValue;

=head1 NAME

Interchange6::Schema::Result::NavigationAttributeValue

=cut

use strict;
use warnings;
use base 'DBIx::Class::Core';

=head1 TABLE: C<navigation_attributes_values>

=cut

__PACKAGE__->table("navigation_attributes_values");

=head1 ACCESSORS

=head2 navigation_attributes_values_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 navigtaion_attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 attribute_values_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "navigation_attributes_values_id",
  { 
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "navigation_attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
  "attribute_values_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
);

=head1 PRIMARY KEY

=over 4

=item * L</navigation_attributes_values_id>

=back

=cut

__PACKAGE__->set_primary_key("navigation_attributes_values_id");

=head1 RELATIONS

=head2 NavigationAttribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

__PACKAGE__->belongs_to(
  "NavigationAttribute",
  "Interchange6::Schema::Result::NavigationAttribute",
  { navigation_attributes_id => "navigation_attributes_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 AttributeValue

Type: belongs_to

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

__PACKAGE__->belongs_to(
  "AttributeValue",
  "Interchange6::Schema::Result::AttributeValue",
  { attribute_values_id => "attribute_values_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
