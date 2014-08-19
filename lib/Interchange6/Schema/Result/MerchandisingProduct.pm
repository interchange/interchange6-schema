use utf8;

package Interchange6::Schema::Result::MerchandisingProduct;

=head1 NAME

Interchange6::Schema::Result::MerchandisingProduct

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 merchandising_products_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'merchandising_products_merchandising_products_id_seq'
  primary key

=cut

primary_column merchandising_products_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "merchandising_products_merchandising_products_id_seq",
};

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 64

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 64 };

=head2 sku_related

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 64

=cut

column sku_related =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 64 };

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column type =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head1 RELATIONS

=head2 merchandising_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingAttribute>

=cut

has_many
  merchandising_attributes =>
  "Interchange6::Schema::Result::MerchandisingAttribute",
  "merchandising_products_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku",
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  };

=head2 product_related

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product_related => "Interchange6::Schema::Result::Product",
  { sku => "sku_related" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  };

1;
