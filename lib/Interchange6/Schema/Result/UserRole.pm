use utf8;
package Interchange6::Schema::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::UserRole

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_roles>

=cut

__PACKAGE__->table("user_roles");

=head1 ACCESSORS

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 roles_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "roles_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</users_id>

=item * L</roles_id>

=back

=cut

__PACKAGE__->set_primary_key("users_id", "roles_id");

=head1 RELATIONS

=head2 Role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "Role",
  "Interchange6::Schema::Result::Role",
  { roles_id => "roles_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KJ/o/LECYkgdKhOSAn5HVA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
