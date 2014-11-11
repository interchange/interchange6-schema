use utf8;
package Interchange6::Schema::Result::Supplier;

=head1 NAME

Interchange6::Schema::Result::Supplier

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 suppliers_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column suppliers_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
};

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column name => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255,
};

=head2 addresses_id

  data_type: 'integer'
  is_foreign_key_constraint: 1
  is_nullable: 0

=cut

column addresses_id => {
    data_type         => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable       => 0,
};

=head2 tax_id

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 45

=cut

column tax_id => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 45,
};

=head2 phone

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 45

=cut

column phone => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 45,
};

=head2 email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 45

=cut

column email => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 45,
};

=head1 RELATIONS

=head2 product_suppliers

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductSupplier>

=cut

has_many
  product_suppliers => "Interchange6::Schema::Result::ProductSupplier",
  { "foreign.suppliers_id" => "self.suppliers_id" },
  { cascade_copy   => 0, cascade_delete => 0 };
  
=head2 addresses

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Address>

=cut

belongs_to
  addresses => "Interchange6::Schema::Result::Address",
  { "foreign.addresses_id" => "self.addresses_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };
  
1;