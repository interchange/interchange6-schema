use utf8;
package Interchange6::Schema::Result::MerchandisingProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::MerchandisingProduct

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<merchandising_products>

=cut

__PACKAGE__->table("merchandising_products");

=head1 ACCESSORS

=head2 merchandising_products_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'merchandising_products_merchandising_products_id_seq'

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 32

=head2 sku_related

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 32

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "merchandising_products_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "merchandising_products_merchandising_products_id_seq",
  },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 32 },
  "sku_related",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 32 },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</merchandising_products_id>

=back

=cut

__PACKAGE__->set_primary_key("merchandising_products_id");

=head1 RELATIONS

=head2 MerchandisingAttributes

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingAttribute>

=cut

__PACKAGE__->has_many(
  "MerchandisingAttribute",
  "Interchange6::Schema::Result::MerchandisingAttribute",
  {
    "foreign.merchandising_products_id" => "self.merchandising_products_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "Product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 ProductRelated

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "ProductRelated",
  "Interchange6::Schema::Result::Product",
  { sku => "sku_related" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gPVs1ml13+jp6iPicaOYhw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
