use utf8;
package Interchange6::Schema::Result::MediaProduct;

=head1 NAME

Interchange6::Schema::Result::MediaProduct

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<media_products>

=cut

__PACKAGE__->table("media_products");

=head1 ACCESSORS

=head2 media_products_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'media_products_media_products_id_seq'

=head2 media_id

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
  "media_products_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_products_media_products_id_seq",
  },
  "media_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_products_id>

=back

=cut

__PACKAGE__->set_primary_key("media_products_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<media_id_sku_unique>

=over 4

=item * L</media_id>

=item * L</sku>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "media_id_sku_unique",
  ["media_id", "sku"],
);



=head1 RELATIONS

=head2 media

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Media>

=cut

__PACKAGE__->belongs_to(
  "media",
  "Interchange6::Schema::Result::Media",
  { media_id => "media_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
