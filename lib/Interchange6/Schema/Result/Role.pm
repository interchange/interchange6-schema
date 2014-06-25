use utf8;
package Interchange6::Schema::Result::Role;

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

=head2 group_pricing

Type: has_many

Related object: L<Interchange6::Schema::Result::GroupPricing>

=cut

__PACKAGE__->has_many(
  "group_pricing",
  "Interchange6::Schema::Result::GroupPricing",
  { "foreign.roles_id" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 permissions

Type: has_many

Related object: L<Interchange6::Schema::Result::Permission>

=cut

__PACKAGE__->has_many(
  "permissions",
  "Interchange6::Schema::Result::Permission",
  { "foreign.roles_id" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Interchange6::Schema::Result::UserRole",
  { "foreign.roles_id" => "self.roles_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users

Type: many_to_many

Composing rels: L</user_role> -> user

=cut

__PACKAGE__->many_to_many("users", "user_role", "user");

1;
