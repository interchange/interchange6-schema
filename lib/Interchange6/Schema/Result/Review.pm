use utf8;

package Interchange6::Schema::Result::Review;

=head1 NAME

Interchange6::Schema::Result::Review

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<reviews>

=cut

__PACKAGE__->table("reviews");

=head1 DESCRIPTION

User product reviews. Link table between Product and Message.

=cut

=head1 ACCESSORS

=head2 messages_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

__PACKAGE__->add_columns(
    "messages_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    "sku",
    {
        data_type      => "varchar",
        is_foreign_key => 1,
        is_nullable    => 0,
        size           => 64
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</messages_id>

=item * L</sku>

=back

=cut

__PACKAGE__->set_primary_key( "messages_id", "sku" );

=head1 RELATIONS

=head2 Message

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Message>

=cut

__PACKAGE__->belongs_to(
    "Message", "Interchange6::Schema::Result::Message",
    "messages_id",
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
    "Product", "Interchange6::Schema::Result::Product",
    "sku",
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
