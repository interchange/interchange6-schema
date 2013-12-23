use utf8;
package Interchange6::Schema::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Role

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<roles>

=cut

__PACKAGE__->table("roles");

=head1 ACCESSORS

=head2 roles_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'roles_roles_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 label

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "roles_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "roles_roles_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "label",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</roles_id>

=back

=cut

__PACKAGE__->set_primary_key("roles_id");

=head1 RELATIONS

=head2 GroupPricing

Type: has_many

Related object: L<Interchange6::Schema::Result::GroupPricing>

=cut

__PACKAGE__->has_many(
  "GroupPricing",
  "Interchange6::Schema::Result::GroupPricing",
  { "foreign.roles_id" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Permission

Type: has_many

Related object: L<Interchange6::Schema::Result::Permission>

=cut

__PACKAGE__->has_many(
  "Permission",
  "Interchange6::Schema::Result::Permission",
  { "foreign.roles_id" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 UserRole

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "UserRole",
  "Interchange6::Schema::Result::UserRole",
  { "foreign.roles_id" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 User

Type: many_to_many

Composing rels: L</UserRole> -> User

=cut

__PACKAGE__->many_to_many("User", "UserRoles", "User");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:91viFZi/tsl+9zPOsT1hYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
