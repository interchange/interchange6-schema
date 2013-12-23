use utf8;
package Interchange6::Schema::Result::Permission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Permission

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<permissions>

=cut

__PACKAGE__->table("permissions");

=head1 ACCESSORS

=head2 roles_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 perm

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "roles_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "perm",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jmpKbl811MvsZsAo7/uhJw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
