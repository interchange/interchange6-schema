use utf8;

package Interchange6::Schema::Result::UserRole;

=head1 NAME

Interchange6::Schema::Result::UserRole

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 user_id

FK on L<Interchange6::Schema::Result::User/id>.

=cut

column user_id => { data_type => "integer" };

=head2 role_id

FK on L<Interchange6::Schema::Result::Role/id>.

=cut

column role_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=item * L</role_id>

=back

=cut

primary_key "user_id", "role_id";

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

belongs_to
  role => "Interchange6::Schema::Result::Role",
  "role_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  user => "Interchange6::Schema::Result::User",
  "user_id";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
