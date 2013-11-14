use utf8;
package Interchange6::Schema::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Session

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

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

=head2 session_hash

  data_type: 'text'
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  is_nullable: 0

=head2 last_modified

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "sessions_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "session_data",
  { data_type => "text", is_nullable => 0 },
  "session_hash",
  { data_type => "text", is_nullable => 0 },
  "created",
  { data_type => "timestamp", is_nullable => 0 },
  "last_modified",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
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
  { "foreign.sessions_id" => "self.sessions_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ddl3uVqCDeTK+ubd4RP9vw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
