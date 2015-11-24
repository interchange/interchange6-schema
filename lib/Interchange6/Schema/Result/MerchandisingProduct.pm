use utf8;

package Interchange6::Schema::Result::MerchandisingProduct;

=head1 NAME

Interchange6::Schema::Result::MerchandisingProduct

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 product_id

FK on L<Interchange6::Schema::Result::Product/id>

=cut

column product_id => { data_type => "integer" };

=head2 related_product_id

FK on L<Interchange6::Schema::Result::Product/id>

=cut

column related_product_id => { data_type => "integer" };

=head2 type

Type, e.g.: related, also_viewed, also_bought.

=cut

column type =>
  { data_type => "varchar", default_value => "", size => 32 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 product_id related_product_id type

=cut

unique_constraint [qw/product_id related_product_id type/];

=head1 RELATIONS

=head2 merchandising_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingAttribute>

=cut

has_many
  merchandising_attributes =>
  "Interchange6::Schema::Result::MerchandisingAttribute",
  "merchandising_product_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "product_id",
  {
    is_deferrable => 1,
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  };

=head2 related_product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  related_product => "Interchange6::Schema::Result::Product",
  "related_product_id",
  {
    is_deferrable => 1,
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
