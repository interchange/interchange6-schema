use utf8;
package Interchange6::Schema::Result::Address;

=head1 NAME

Interchange6::Schema::Result::Address

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<addresses>

=cut

__PACKAGE__->table("addresses");

=head1 ACCESSORS

=head2 addresses_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'addresses_addresses_id_seq'

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 16

=head2 archived

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=head2 first_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 last_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 company

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 address

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 address_2

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 postal_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 city

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 phone

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 states_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 country_iso_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 2

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "addresses_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "addresses_addresses_id_seq",
  },
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 16 },
  "archived",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "first_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "last_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "company",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "address",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "address_2",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "postal_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "city",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "phone",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "states_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "country_iso_code",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 2 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</addresses_id>

=back

=cut

__PACKAGE__->set_primary_key("addresses_id");

=head1 RELATIONS

=head2 orderlines_shipping

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderlinesShipping>

=cut

__PACKAGE__->has_many(
  "orderlines_shipping",
  "Interchange6::Schema::Result::OrderlinesShipping",
  { "foreign.addresses_id" => "self.addresses_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "Interchange6::Schema::Result::Order",
  { "foreign.billing_addresses_id" => "self.addresses_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Interchange6::Schema::Result::User",
  { users_id => "users_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 state

Type: belongs_to

Related object: L<Interchange6::Schema::Result::State>

=cut

__PACKAGE__->belongs_to(
  "state",
  "Interchange6::Schema::Result::State",
  { states_id => "states_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
  "country",
  "Interchange6::Schema::Result::Country",
  { country_iso_code => "country_iso_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 orderlines

Type: many_to_many

Composing rels: L</orderlines_shipping> -> orderline

=cut

__PACKAGE__->many_to_many("orderlines", "orderlines_shipping", "orderline");

1;
