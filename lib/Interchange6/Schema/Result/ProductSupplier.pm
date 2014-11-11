use utf8;
package Interchange6::Schema::Result::ProductSupplier;

=head1 NAME

Interchange6::Schema::Result::ProductSupplier

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 suppliers_id

  data_type: 'integer'
  is_foreign_key_constraint: 1
  is_nullable: 0

=cut

primary_column suppliers_id => {
    data_type         => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable       => 0,
};

=head2 sku

  data_type: 'varchar'
  is_foreign_key_constraint: 1
  is_nullable: 0

=cut

primary_column sku => {
    data_type         => "varchar",
    is_foreign_key_constraint   => 1,
    is_nullable       => 0,
};

=head1 RELATIONS

=head2 products

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  products => "Interchange6::Schema::Result::Product",
  { "foreign.sku" => "self.sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };
  
=head2 inventory_logs

Type: has_many

Related object: L<Interchange6::Schema::Result::InventoryLog>

=cut

has_many
  inventory_logs => "Interchange6::Schema::Result::InventoryLog",
  { "foreign.suppliers_id" => "self.suppliers_id",  "foreign.sku" => "self.sku"},
  { cascade_copy   => 0, cascade_delete => 0 };
  
  
=head2 product_suppliers

Type: has_many

Related object: L<Interchange6::Schema::Result::Supplier>

=cut

belongs_to
  product_suppliers => "Interchange6::Schema::Result::Supplier",
  { "foreign.suppliers_id" => "self.suppliers_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };


1;