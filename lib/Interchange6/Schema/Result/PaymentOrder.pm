use utf8;

package Interchange6::Schema::Result::PaymentOrder;

=head1 NAME

Interchange6::Schema::Result::PaymentOrder

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 DESCRIPTION

The C<payment_sessions_id> is used to store the session id provided by the gateway.
For example, with L<Business::OnlinePayment::IPayment> you put the session id into
the HTML form for the silent CGI mode.

The C<sessions_id> is used here so we can track down payments without orders.
We usually turn a guest user into a real user after confirmation of a successful payment,
so we need the session information here in the case the payment is made but
the confirmation didn't reach the online shop.

=head1 ACCESSORS

=head2 payment_orders_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'payment_orders_payment_orders_id_seq'
  primary key

=cut

primary_column payment_orders_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "payment_orders_payment_orders_id_seq",
};

=head2 payment_mode

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column payment_mode =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 payment_action

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column payment_action =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 payment_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column payment_id =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 auth_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column auth_code => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

column users_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 };

=head2 sessions_id

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=cut

column sessions_id => {
    data_type      => "varchar",
    is_foreign_key => 1,
    is_nullable    => 1,
    size           => 255
};

=head2 orders_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

column orders_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 };

=head2 amount

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=cut

column amount => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 11, 2 ],
};

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column status =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 payment_sessions_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column payment_sessions_id => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 payment_error_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column payment_error_code =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 payment_error_message

  data_type: 'text'
  is_nullable: 1

=cut

column payment_error_message => { data_type => "text", is_nullable => 1 };

=head2 payment_fee

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

Some gateways (notably PayPal) charge a fee for each transaction. This
column should be used to store the transaction fee (if any).

=cut

column payment_fee => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 11, 2 ],
};

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column created =>
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 };

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable   => 0
};

=head1 RELATIONS

=head2 order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

belongs_to
  order => "Interchange6::Schema::Result::Order",
  "orders_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  user => "Interchange6::Schema::Result::User",
  "users_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 session

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Session>

=cut

belongs_to
  session => "Interchange6::Schema::Result::Session",
  "sessions_id",
  { join_type => 'left', on_delete => 'SET NULL' };

1;
