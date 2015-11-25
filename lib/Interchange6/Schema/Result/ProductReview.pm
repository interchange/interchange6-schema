use utf8;

package Interchange6::Schema::Result::ProductReview;

=head1 NAME

Interchange6::Schema::Result::ProductReview

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

Link table between Product and Message for product reviews.

=cut

=head1 ACCESSORS

=head2 message_id

Foreign key constraint on L<Interchange6::Schema::Result::Message/id>
via L</message> relationship.

=cut

column message_id => { data_type => "integer" };

=head2 product_id

Foreign key constraint on L<Interchange6::Schema::Result::Product/id>
via L</product> relationship.

=cut

column product_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</message_id>

=item * L</product_id>

=back

=cut

primary_key "message_id", "product_id";

=head1 RELATIONS

=head2 message

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Message>

=cut

belongs_to
  message => "Interchange6::Schema::Result::Message",
  "message_id",
  { cascade_delete => 1 };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to product => "Interchange6::Schema::Result::Product", "product_id";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
