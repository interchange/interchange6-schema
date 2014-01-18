use utf8;
package Interchange6::Schema::Result::UserAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::UserAttribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_attributes>

=cut

__PACKAGE__->table("user_attributes");

=head1 ACCESSORS

=head2 user_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'user_attributes_user_attributes_id_seq'

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_attributes_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_attributes_user_attributes_id_seq",
  },
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("user_attributes_id");

=head1 RELATIONS

=head2 User

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "User",
  "Interchange6::Schema::Result::User",
  { users_id => "users_id" },
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

=head2 UserAttributeValue

Type: belongs_to

Related object: L<Interchange6::Schema::Result::UserAttributeValue>

=cut

__PACKAGE__->has_many(
  "UserAttributeValue",
  "Interchange6::Schema::Result::UserAttributeValue",
  { "foreign.user_attributes_id" => "self.user_attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GFKvOlGzMEzzO73/yR9UIw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
