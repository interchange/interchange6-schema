use utf8;

package Interchange6::Schema::Result::OrderlinesShipping;

=head1 NAME

Interchange6::Schema::Result::OrderlinesShipping

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Foreign key constraint on
L<Interchange6::Schema::Result::Orderline/orderline_id> via L</orderline>
relationship.

=cut

column orderline_id => { data_type => "integer" };

=head2 address_id

Foreign key constraint on L<Interchange6::Schema::Result::Address/id>
via L</address> relationship.

=cut

column address_id => { data_type => "integer" };

=head2 shipment_id

Foreign key constraint on L<Interchange6::Schema::Result::Shipment/shipments_id>
via L</shipment> relationship.

=cut

column shipment_id => { data_type => "integer" };

=head1 PRIMARY KEY

Each unique combination of L</orderline> and L</address> can have multiple
related L</shipments> in case an L</orderline> needs to be shipped in more
than one consignment.

=over 4

=item * L</orderlines_id>

=item * L</addresses_id>

=back

=cut

primary_key "orderlines_id", "addresses_id";

=head1 RELATIONS

=head2 address

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Address>

=cut

belongs_to
  address => "Interchange6::Schema::Result::Address",
  "address_id";

=head2 orderline

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

belongs_to
  orderline => "Interchange6::Schema::Result::Orderline",
  "orderline_id";

=head2 shipment

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Shipment>

=cut

belongs_to
  shipment => "Interchange6::Schema::Result::Shipment",
  "shipment_id";

=head1 METHODS

=head2 delete

Rows in this table should not be deleted so we overload
L<DBIx::Class::Row/delete> to throw an exception.

=cut

sub delete {
    shift->result_source->schema->throw_exception(
        "OrderlinesShipping rows cannot be deleted");
}

1;
