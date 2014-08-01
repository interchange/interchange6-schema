use utf8;

package Interchange6::Schema::Result::ProductReview;

=head1 NAME

Interchange6::Schema::Result::ProductReview

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product_reviews>

=cut

__PACKAGE__->table("product_reviews");

=head1 DESCRIPTION

Link table between Product and Message for product reviews.

=cut

=head1 ACCESSORS

=head2 messages_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  size: 64
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    "messages_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    "sku",
    { data_type => "varchar", size => 64, is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</messages_id>

=item * L</sku>

=back

=cut

__PACKAGE__->set_primary_key( "messages_id", "sku" );

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

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
    "product",
    "Interchange6::Schema::Result::Product",
    "sku",
);

1;
