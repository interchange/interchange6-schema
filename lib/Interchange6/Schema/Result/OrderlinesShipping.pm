use utf8;
package Interchange6::Schema::Result::OrderlinesShipping;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

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

=head2 Address

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "Address",
  "Interchange6::Schema::Result::Address",
  { addresses_id => "addresses_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Orderline

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

__PACKAGE__->belongs_to(
  "Orderline",
  "Interchange6::Schema::Result::Orderline",
  { orderlines_id => "orderlines_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Shipment

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Shipment>

=cut

__PACKAGE__->belongs_to(
  "Shipment",
  "Interchange6::Schema::Result::Shipment",
  { shipments_id => "shipments_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:D0qg3iY/8nKtj1gkV255FA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
