use utf8;
package Interchange6::Schema::Result::ProductAttributes;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::ProductAttributes

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<products_attributes>

=cut

__PACKAGE__->table("products_attributes");

=head1 ACCESSORS

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 32

=head2 product_attributes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 32 },
  "product_attributes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sku>

=item * L</product_attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("sku", "product_attributes_id");

=head1 RELATIONS

=head2 product_attribute

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

__PACKAGE__->belongs_to(
  "product_attribute",
  "Interchange6::Schema::Result::ProductAttribute",
  { product_attributes_id => "product_attributes_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 sku

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L8pPX5/aDOP5ZQQpjmsYkQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
