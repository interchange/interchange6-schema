use utf8;
package Interchange6::Schema::Result::PaymentOrder;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::PaymentOrder

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<payment_orders>

=cut

__PACKAGE__->table("payment_orders");

=head1 ACCESSORS

=head2 payment_orders_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'payment_orders_payment_orders_id_seq'

=head2 payment_mode

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 payment_action

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 payment_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 auth_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 sessions_id

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 255

=head2 orders_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 amount

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 payment_sessions_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 payment_error_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 payment_error_message

  data_type: 'text'
  default_value: (empty string)
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
  "payment_orders_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "payment_orders_payment_orders_id_seq",
  },
  "payment_mode",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "payment_action",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "payment_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "auth_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "sessions_id",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 255 },
  "orders_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1  },
  "amount",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "status",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "payment_sessions_id",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "payment_error_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "payment_error_message",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</payment_orders_id>

=back

=cut

__PACKAGE__->set_primary_key("payment_orders_id");

=head1 RELATIONS

=head2 Order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

__PACKAGE__->belongs_to(
  "Order",
  "Interchange6::Schema::Result::Order",
  { orders_id => "orders_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 User

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "User",
  "Interchange6::Schema::Result::User",
  { users_id => "users_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Session

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Session>

=cut

__PACKAGE__->belongs_to(
  "Session",
  "Interchange6::Schema::Result::Session",
  { sessions_id => "sessions_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:425f4STRGcuJCStJOYH1uA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
