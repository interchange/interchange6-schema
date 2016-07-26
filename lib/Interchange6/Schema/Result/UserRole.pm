use utf8;

package Interchange6::Schema::Result::UserRole;

=head1 NAME

Interchange6::Schema::Result::UserRole

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 users_id

FK on L<Interchange6::Schema::Result::User/users_id>.

=cut

column users_id =>
  { data_type => "integer" };

=head2 roles_id

FK on L<Interchange6::Schema::Result::Role/roles_id>.

=cut

column roles_id =>
  { data_type => "integer" };

=head2 website_id

The id of the website/shop this attribute value belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</users_id>

=item * L</roles_id>

=back

=cut

primary_key "users_id", "roles_id";

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

belongs_to
  role => "Interchange6::Schema::Result::Role",
  "roles_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  user => "Interchange6::Schema::Result::User",
  "users_id";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
