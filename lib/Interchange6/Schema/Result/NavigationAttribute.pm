use utf8;
package Interchange6::Schema::Result::NavigationAttribute;

=head1 NAME

Interchange6::Schema::Result::NavigationAttribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<navigation_attributes>

=cut

__PACKAGE__->table("navigation_attributes");

=head1 ACCESSORS

=head2 navigation_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 navigation_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "navigation_attributes_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_attributes_user_attributes_id_seq",
  },
  "navigation_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</navigation_attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("navigation_attributes_id");

=head1 RELATIONS

=head2 Navigation

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

__PACKAGE__->belongs_to(
  "Navigation",
  "Interchange6::Schema::Result::Navigation",
  { navigation_id => "navigation_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

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

=head2 NavigationAttributeValue

Type: belongs_to

Related object: L<Interchange6::Schema::Result::NavigationAttributeValue>

=cut

__PACKAGE__->has_many(
  "NavigationAttributeValue",
  "Interchange6::Schema::Result::NavigationAttributeValue",
  { "foreign.navigation_attributes_id" => "self.navigation_attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


1;
