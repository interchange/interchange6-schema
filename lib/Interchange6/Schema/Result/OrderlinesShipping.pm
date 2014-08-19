use utf8;

package Interchange6::Schema::Result::OrderlinesShipping;

=head1 NAME

Interchange6::Schema::Result::OrderlinesShipping

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 orderlines_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column orderlines_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 addresses_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column addresses_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 shipments_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column shipments_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head1 PRIMARY KEY

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
  "addresses_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 orderline

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

belongs_to
  orderline => "Interchange6::Schema::Result::Orderline",
  "orderlines_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Shipment>

=cut

belongs_to
  shipment => "Interchange6::Schema::Result::Shipment",
  "shipments_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
