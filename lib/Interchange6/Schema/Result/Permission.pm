use utf8;
package Interchange6::Schema::Result::Permission;

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

=head2 permissions_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'permissions_id_seq'

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
  "permissions_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "permissions_id_seq"
  },
  "roles_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "perm",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</permissions_id>

=back

=cut

__PACKAGE__->set_primary_key("permissions_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Interchange6::Schema::Result::Role",
  { roles_id => "roles_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
