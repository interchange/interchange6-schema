use utf8;

package Interchange6::Schema::Result::MerchandisingAttribute;

=head1 NAME

Interchange6::Schema::Result::MerchandisingAttribute

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

=head2 merchandising_product_id

FK on L<Interchange6::Schema::Result::MerchandisingProduct/id>.

=cut

column merchandising_product_id => { data_type => "integer" };

=head2 name

Name.

=cut

column name => { data_type => "varchar", size => 32 };

=head2 value

Value.

=cut

column value => { data_type => "text" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 merchandising_product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

belongs_to
  merchandising_product => "Interchange6::Schema::Result::MerchandisingProduct",
  "merchandising_product_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
