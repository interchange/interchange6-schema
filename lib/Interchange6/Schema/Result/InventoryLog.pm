use utf8;
package Interchange6::Schema::Result::InventoryLog;

=head1 NAME

Interchange6::Schema::Result::InventoryLog

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 inventory_logs_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column inventory_logs_id => {
    data_type         => "integer",
    is_auto_increment => 1,
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

=head2 datetime

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column datetime => {
    data_type     => "datetime",
    set_on_create => 1,
    is_nullable   => 0
};

=head2 quantity

  data_type: 'decimal'
  size: [9,2],
  is_nullable: 0,
  default_value: '0.00',

=cut

primary_column quantity => {
    data_type      => 'decimal',
    size           => [9,2],
    is_nullable    => 0,
    default_value  => '0.00',
};

=head2 locations_id

  data_type: 'integer'
  is_foreign_key_constraint: 1
  is_nullable: 0

=cut

primary_column locations_id => {
    data_type         => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable       => 0,
};

=head2 suppliers_id

  data_type: 'integer'
  is_foreign_key_constraint: 1
  is_nullable: 0

=cut

primary_column product_suppliers_id => {
    data_type         => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable       => 0,
};

=head1 RELATIONS

=head2 location

Type: has_many

Related object: L<Interchange6::Schema::Result::Location>

=cut

belongs_to
  locations => "Interchange6::Schema::Result::Location",
  { "foreign.locations_id" => "self.locations_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };
  
=head2 products

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  products => "Interchange6::Schema::Result::Product",
  { "foreign.sku" => "self.sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };
  
=head2 product_supplier

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductSupplier>

=cut

belongs_to
  product_suppliers => "Interchange6::Schema::Result::ProductSupplier",
  { "foreign.product_suppliers_id" => "self.product_suppliers_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;