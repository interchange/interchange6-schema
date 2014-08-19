use utf8;

package Interchange6::Schema::Result::MediaProduct;

=head1 NAME

Interchange6::Schema::Result::MediaProduct

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 media_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column media_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 };

=head1 PRIMARY KEY

=over 4

=item * L</media_id>

=item * L</sku>

=back

=cut

primary_key "media_id", "sku";

=head1 RELATIONS

=head2 media

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Media>

=cut

belongs_to
  media => "Interchange6::Schema::Result::Media",
  "media_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
