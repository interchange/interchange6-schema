use utf8;

package Interchange6::Schema::Result::OrderComment;

=head1 NAME

Interchange6::Schema::Result::OrderComment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<order_comments>

=cut

__PACKAGE__->table("order_comments");

=head1 DESCRIPTION

Link table between Order and Message for order comments.

=cut

=head1 ACCESSORS

=head2 messages_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 orders_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    "messages_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    "orders_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</messages_id>

=item * L</orders_id>

=back

=cut

__PACKAGE__->set_primary_key( "messages_id", "orders_id" );

=head1 RELATIONS

=head2 message

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Message>

=cut

__PACKAGE__->belongs_to(
    "message",
    "Interchange6::Schema::Result::Message",
    "messages_id",
    { cascade_delete => 1 },
);

=head2 order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

__PACKAGE__->belongs_to(
    "order",
    "Interchange6::Schema::Result::Order",
    "orders_id",
);

1;
