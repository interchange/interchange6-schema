use utf8;
package Interchange6::Schema::Result::OrderlinesShipping;

=head1 NAME

Interchange6::Schema::Result::OrderlinesShipping

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<orderlines_shipping>

=cut

__PACKAGE__->table("orderlines_shipping");

=head1 ACCESSORS

=head2 orderlines_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 addresses_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 shipments_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "orderlines_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "addresses_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "shipments_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },

);

=head1 PRIMARY KEY

=over 4

=item * L</orderlines_id>

=item * L</addresses_id>

=back

=cut

__PACKAGE__->set_primary_key("orderlines_id", "addresses_id");

=head1 RELATIONS

=head2 address

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "address",
  "Interchange6::Schema::Result::Address",
  { addresses_id => "addresses_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 orderline

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

__PACKAGE__->belongs_to(
  "orderline",
  "Interchange6::Schema::Result::Orderline",
  { orderlines_id => "orderlines_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 shipment

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Shipment>

=cut

__PACKAGE__->belongs_to(
  "shipment",
  "Interchange6::Schema::Result::Shipment",
  { shipments_id => "shipments_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
