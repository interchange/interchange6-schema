use utf8;
package Interchange6::Schema::Result::Order;

=head1 NAME

Interchange6::Schema::Result::Order

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime));

=head1 TABLE: C<orders>

=cut

__PACKAGE__->table("orders");

=head1 ACCESSORS

=head2 orders_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'orders_orders_id_seq'

=head2 order_number

  data_type: 'varchar'
  is_nullable: 0
  size: 24

=head2 order_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 shipping_addresses_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 billing_addresses_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,3]

=head2 payment_method

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 payment_number

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 payment_status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 shipping_method

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 subtotal

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 shipping

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 handling

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 salestax

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 total_cost

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [11,2]

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 24

=cut

__PACKAGE__->add_columns(
  "orders_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "orders_orders_id_seq",
  },
  "order_number",
  { data_type => "varchar", is_nullable => 0, size => 24 },
  "order_date",
  { data_type => "timestamp", is_nullable => 1 },
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "shipping_addresses_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "billing_addresses_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "weight",
  { data_type => "numeric", default_value => "0.0", is_nullable => 0, size => [11,3]  },
  "payment_method",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "payment_number",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "payment_status",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "shipping_method",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "subtotal",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "shipping",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "handling",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "salestax",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "total_cost",
  {
    data_type => "numeric",
    default_value => "0.0",
    is_nullable => 0,
    size => [11, 2],
  },
  "status",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 24 },
);

=head1 PRIMARY KEY

=over 4

=item * L</orders_id>

=back

=cut

__PACKAGE__->set_primary_key("orders_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<orders_order_number_key>

=over 4

=item * L</order_number>

=back

=cut

__PACKAGE__->add_unique_constraint("orders_order_number_key", ["order_number"]);

=head1 RELATIONS

=head2 shipping_address

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "shipping_address",
  "Interchange6::Schema::Result::Address",
  { addresses_id => "shipping_addresses_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 billing_address

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "billing_address",
  "Interchange6::Schema::Result::Address",
  { addresses_id => "billing_addresses_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 orderlines

Type: has_many

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

__PACKAGE__->has_many(
  "orderlines",
  "Interchange6::Schema::Result::Orderline",
  { "foreign.orders_id" => "self.orders_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 payment_orders

Type: has_many

Related object: L<Interchange6::Schema::Result::PaymentOrder>

=cut

__PACKAGE__->has_many(
  "payment_orders",
  "Interchange6::Schema::Result::PaymentOrder",
  { "foreign.orders_id" => "self.orders_id" },
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

=head2 order_comments

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderComment>

=cut

__PACKAGE__->has_many(
    'order_comments',
    'Interchange6::Schema::Result::OrderComment',
    'orders_id',
);

=head2 _comments

Type: many_to_many

This is considered a private method. Please see public L</comments> and L</add_to_comments> methods.

=cut

__PACKAGE__->many_to_many( "_comments", "order_comments", "message" );

=head1 METHODS

=head2 comments

=over 4
 
=item Arguments: none

=item Return Value: L<Interchange6::Schema::Result::Message> resultset.

=back
 
=cut

sub comments {
    return shift->_comments(@_);
}


=head2 add_to_comments

=over 4
 
=item Arguments: \%col_data
 
=item Return Value: L<Interchange6::Schema::Result::Message>
 
=back

=cut

# much of this was cargo-culted from DBIx::Class::Relationship::ManyToMany

sub add_to_comments {
    my $self = shift;
    @_ > 0 or $self->throw_exception(
        "add_to_comments needs an object or hashref"
    );
    my $rset_message = $self->result_source->schema->resultset("Message");
    my $obj;
    if (ref $_[0]) {
        if (ref $_[0] eq 'HASH') {
            $_[0]->{type} = "order_comment";
            $obj = $rset_message->create($_[0]);
        } else {
            $obj = $_[0];
            unless ( my $type = $obj->message_type->name eq "order_comment" ) {
                $self->throw_exception(
                    "cannot add message type $type to comments"
                );
            }
        }
    }
    else {
        push @_, type => "order_comment";
        $obj = $rset_message->create({@_});
    }
    $self->create_related('order_comments', { messages_id => $obj->id } );
    return $obj;
}


=head2 delete

Overload delete to force removal of any order comments.

=cut

# FIXME: (SysPete) There ought to be a way to force this with cascade delete.

sub delete {
    my ( $self, @args ) = @_;
    my $guard = $self->result_source->schema->txn_scope_guard;
    $self->order_comments->delete_all;
    $self->next::method(@args);
    $guard->commit;
}

1;
