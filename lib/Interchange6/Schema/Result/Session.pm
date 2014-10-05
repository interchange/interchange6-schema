use utf8;
package Interchange6::Schema::Result::Session;

=head1 NAME

Interchange6::Schema::Result::Session

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<sessions>

=cut

__PACKAGE__->table("sessions");

=head1 ACCESSORS

=head2 sessions_id

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 session_data

  data_type: 'text'
  is_nullable: 0

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
  "sessions_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "session_data",
  { data_type => "text", is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sessions_id>

=back

=cut

__PACKAGE__->set_primary_key("sessions_id");

=head1 RELATIONS

=head2 carts

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

__PACKAGE__->has_many(
  "carts",
  "Interchange6::Schema::Result::Cart",
  { "foreign.sessions_id" => "self.sessions_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 payment_orders

Type: has_many

Related object: L<Interchange6::Schema::Result::PaymentOrder>

=cut

__PACKAGE__->has_many(
  "payment_orders",
  "Interchange6::Schema::Result::PaymentOrder",
  "sessions_id",
  { cascade_copy => 0, cascade_delete => 0 },
);

1;
