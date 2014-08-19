use utf8;

package Interchange6::Schema::Result::MerchandisingAttribute;

=head1 NAME

Interchange6::Schema::Result::MerchandisingAttribute

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 merchandising_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'merchandising_attributes_merchandising_attributes_id_seq'
  primary key

=cut

primary_column merchandising_attributes_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence => "merchandising_attributes_merchandising_attributes_id_seq",
};

=head2 merchandising_products_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column merchandising_products_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

column name => { data_type => "varchar", is_nullable => 0, size => 32 };

=head2 value

  data_type: 'text'
  is_nullable: 0

=cut

column value => { data_type => "text", is_nullable => 0 };

=head1 RELATIONS

=head2 merchandising_product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

belongs_to
  merchandising_product => "Interchange6::Schema::Result::MerchandisingProduct",
  "merchandising_products_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
