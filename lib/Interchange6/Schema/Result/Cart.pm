use utf8;

package Interchange6::Schema::Result::Cart;

=head1 NAME

Interchange6::Schema::Result::Cart

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 DESCRIPTION

The Cart class (table) is used for storing shopping carts with products in the
cart held in the related L<Interchange6::Schema::Result::CartProduct> class.

=head1 ACCESSORS

=head2 carts_id

Primary key.

=cut

primary_column carts_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    sequence          => "carts_carts_id_seq",
};

=head2 name

The name of the cart. You might perhaps have a "main" cart that is used by
default for the current shopping session and also a "wishlist" cart. Other
uses might be "saved_items" so a user can save things for another time or
maybe on logout all cart items are moved to "previous_session" cart.

=cut

column name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 users_id

Foreign key constraint on L<Interchange6::Schema::Result::User/users_id>
via L</user> relationship.

=cut

column users_id => {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
};

=head2 sessions_id

Foreign key constraint on L<Interchange6::Schema::Result::Session/sessions_id>
via L</session> relationship. Is nullable.

=cut

column sessions_id => {
    data_type      => "varchar",
    is_foreign_key => 1,
    is_nullable    => 1,
    size           => 255,
};

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type     => "datetime",
    set_on_create => 1,
};

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head2 approved

Whether the cart has been approved.

=cut

column approved => {
    data_type   => "boolean",
    is_nullable => 1,
};

=head2 status

Cart status.

=cut

column status => {
    data_type     => "varchar",
    default_value => "",
    size          => 32,
};

=head1 UNIQUE CONSTRAINTS

=head2 carts_name_sessions_id

On ( name, sessions_id )

=cut

unique_constraint carts_name_sessions_id => [qw/ name sessions_id /];

=head1 RELATIONS

=head2 cart_products

Type: has_many

Related object: L<Interchange6::Schema::Result::CartProduct>

=cut

has_many
  cart_products => "Interchange6::Schema::Result::CartProduct",
  { "foreign.carts_id" => "self.carts_id" },
  { cascade_copy       => 0, cascade_delete => 0 };

=head2 session

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Session>

=cut

belongs_to
  session => "Interchange6::Schema::Result::Session",
  { sessions_id   => "sessions_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  user => "Interchange6::Schema::Result::User",
  { users_id      => "users_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
