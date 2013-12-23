use utf8;
package Interchange6::Schema::Result::ProductAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::ProductAttribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product_attributes>

=cut

__PACKAGE__->table("product_attributes");

=head1 ACCESSORS

=head2 product_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'product_attributes_product_attributes_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 value

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_attributes_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "product_attributes_product_attributes_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "value",
  { data_type => "text", default_value => "", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product_attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("product_attributes_id");

=head1 RELATIONS

=head2 ProductAttributes

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttributes>

=cut

__PACKAGE__->has_many(
  "ProductsAttributes",
  "Interchange6::Schema::Result::ProductAttributes",
  { "foreign.product_attributes_id" => "self.product_attributes_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 skus

Type: many_to_many

Composing rels: L</ProductAttributes> -> Product

=cut

__PACKAGE__->many_to_many("Product", "ProductAttributes", "Product");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U53TCTiOMvvkaDPEy3ZZCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
