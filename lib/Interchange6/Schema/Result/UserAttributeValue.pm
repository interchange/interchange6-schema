use utf8;
package Interchange6::Schema::Result::UserAttributeValue;

=head1 NAME

Interchange6::Schema::Result::UserAttributeValue

=cut

use strict;
use warnings;
use base 'DBIx::Class::Core';

=head1 TABLE: C<users_attributes_values>

=cut

__PACKAGE__->table("users_attributes_values");

=head1 ACCESSORS

=head2 user_attributes_values_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 attribute_values_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_attributes_values_id",
  { 
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
  },
  "user_attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
  "attribute_values_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0},
);

=head1 PRIMARY KEY

=over 4

=item * L</user_attributes_values_id>

=back

=cut

__PACKAGE__->set_primary_key("user_attributes_values_id");

=head1 RELATIONS

=head2 user_attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::UserAttribute>

=cut

__PACKAGE__->belongs_to(
  "user_attribute",
  "Interchange6::Schema::Result::UserAttribute",
  { user_attributes_id => "user_attributes_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 attribute_value

Type: belongs_to

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

__PACKAGE__->belongs_to(
  "attribute_value",
  "Interchange6::Schema::Result::AttributeValue",
  { attribute_values_id => "attribute_values_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
