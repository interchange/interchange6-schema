use utf8;
package Interchange6::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 users_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_users_id_seq'

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 first_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 last_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 last_login

  data_type: 'timestamp'
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  is_nullable: 0

=head2 last_modified

  data_type: 'timestamp'
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "users_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_users_id_seq",
  },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "password",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "first_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "last_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "last_login",
  { data_type => "timestamp", is_nullable => 0 },
  "created",
  { data_type => "timestamp", is_nullable => 0 },
  "last_modified",
  { data_type => "timestamp", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</users_id>

=back

=cut

__PACKAGE__->set_primary_key("users_id");

=head1 RELATIONS

=head2 addresses

Type: has_many

Related object: L<Interchange6::Schema::Result::Address>

=cut

__PACKAGE__->has_many(
  "addresses",
  "Interchange6::Schema::Result::Address",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 carts

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

__PACKAGE__->has_many(
  "carts",
  "Interchange6::Schema::Result::Cart",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "Interchange6::Schema::Result::Order",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttribute>

=cut

__PACKAGE__->has_many(
  "user_attributes",
  "Interchange6::Schema::Result::UserAttribute",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Interchange6::Schema::Result::UserRole",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8lfuxYQvCHVW0GTmbVAf6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
