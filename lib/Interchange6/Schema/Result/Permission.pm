use utf8;

package Interchange6::Schema::Result::Permission;

=head1 NAME

Interchange6::Schema::Result::Permission

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 permissions_id

Primary key.

=cut

primary_column permissions_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    sequence          => "permissions_id_seq"
};

=head2 roles_id

FK on L<Interchange6::Schema::Result::Role/roles_id>.

=cut

column roles_id =>
  { data_type => "integer" };

=head2 perm

Permission name.

=cut

column perm => {
    data_type     => "varchar",
    size          => 255
};

=head2 website_id

The id of the website/shop this attribute value belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

belongs_to
  role => "Interchange6::Schema::Result::Role",
  "roles_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
