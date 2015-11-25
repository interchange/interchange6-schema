use utf8;

package Interchange6::Schema::Result::OrderComment;

=head1 NAME

Interchange6::Schema::Result::OrderComment

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

Link table between Order and Message for order comments.

=cut

=head1 ACCESSORS

=head2 message_id

Foreign key constraint on L<Interchange6::Schema::Result::Message/id>
via L</message> relationship.

=cut

column message_id => { data_type => "integer" };

=head2 order_id

Foreign key constraint on L<Interchange6::Schema::Result::Order/id>
via L</order> relationship.

=cut

column order_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 PRIMARY KEY

=over 4

=item * L</message_id>

=item * L</order_id>

=back

=cut

primary_key "message_id", "order_id";

=head1 RELATIONS

=head2 message

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Message>

=cut

belongs_to
  message => "Interchange6::Schema::Result::Message",
  "message_id",
  { cascade_delete => 1 };

=head2 order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

belongs_to
  order => "Interchange6::Schema::Result::Order",
  "order_id";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
