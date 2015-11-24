use utf8;

package Interchange6::Schema::Result::NavigationProduct;

=head1 NAME

Interchange6::Schema::Result::NavigationProduct

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 product_id

Foreign constraint on L<Interchange6::Schema::Result::Product/id>
via L</product> relationship.

=cut

column product_id => { data_type => "integer" };

=head2 navigation_id

Foreign constraint on L<Interchange6::Schema::Result::Navigation/navigation_id>
via L</navigation> relationship.

=cut

column navigation_id => { data_type => "integer" };

=head2 type

Can be used to cache the value held in
L<Interchange6::Schema::Result::Navigation/type> though usually ignored.

Column is nullable.

=cut

column type =>
  { data_type => "varchar", is_nullable => 1, size => 16 };

=head2 priority

Priority (higher number is higher priority) is used to define which category
(or other L<Interchange6::Schema::Result::Navigation/type>) should be used
when constructing L<Interchange6::Schema::Result::Product/path>.

Default is 0.

=cut

column priority => { data_type => "integer", default_value => 0 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</product_id>

=item * L</navigation_id>

=back

=cut

primary_key "product_id", "navigation_id";

=head1 RELATIONS

=head2 navigation

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

belongs_to
  navigation => "Interchange6::Schema::Result::Navigation",
  "navigation_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "product_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
