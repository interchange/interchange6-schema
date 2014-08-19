use utf8;

package Interchange6::Schema::Result::Permission;

=head1 NAME

Interchange6::Schema::Result::Permission

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 permissions_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'permissions_id_seq'
  primary key

=cut

primary_column permissions_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "permissions_id_seq"
};

=head2 roles_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column roles_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 perm

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column perm => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

belongs_to
  role => "Interchange6::Schema::Result::Role",
  "roles_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
