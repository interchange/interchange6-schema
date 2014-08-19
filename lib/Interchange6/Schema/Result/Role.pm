use utf8;

package Interchange6::Schema::Result::Role;

=head1 NAME

Interchange6::Schema::Result::Role

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 roles_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'roles_roles_id_seq'
  primary key

=cut

primary_column roles_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "roles_roles_id_seq",
};

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

column name => { data_type => "varchar", is_nullable => 0, size => 32 };

=head2 label

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

column label => { data_type => "varchar", is_nullable => 0, size => 255 };

=head1 RELATIONS

=head2 group_pricing

Type: has_many

Related object: L<Interchange6::Schema::Result::GroupPricing>

=cut

has_many
  group_pricing => "Interchange6::Schema::Result::GroupPricing",
  "roles_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 permissions

Type: has_many

Related object: L<Interchange6::Schema::Result::Permission>

=cut

has_many
  permissions => "Interchange6::Schema::Result::Permission",
  "roles_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 user_roles

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

has_many
  user_roles => "Interchange6::Schema::Result::UserRole",
  "roles_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 users

Type: many_to_many

Composing rels: L</user_roles> -> user

=cut

many_to_many users => "user_roles", "user";

1;
