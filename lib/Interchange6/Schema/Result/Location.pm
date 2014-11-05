use utf8;
package Interchange6::Schema::Result::Location;

=head1 NAME

Interchange6::Schema::Result::Location

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 locations_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column locations_id => {
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
    size          => 45,
};

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1

=cut

column parent_id => {
    data_type     => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable   => 1,
};


=head2 addresses_id

  data_type: 'integer'
  is_nullable: 0

=cut

column addresses_id => {
    data_type     => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable   => 0,
};

=head2 location_types_id

  data_type: 'integer'
  is_nullable: 0

=cut

column location_types_id => {
    data_type     => "integer",
    is_foreign_key_constraint   => 1,
    is_nullable   => 0,
};

=head1 RELATIONS

=head2 address

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Adress>

=cut

belongs_to
  address => "Interchange6::Schema::Result::Address",
  { "foreign.addresses_id" => "self.addresses_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 children

Type: has_many

Related object: L<Interchange6::Schema::Result::Location>

=cut

has_many
  children => "Interchange6::Schema::Result::Location",
  { "foreign.parent_id" => "self.locations_id" },
  { cascade_copy  => 0, cascade_delete => 0 };

=head2 parent

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Location>

=cut

belongs_to
  parent => "Interchange6::Schema::Result::Location",
  { "foreign.locations_id" => "self.parent_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };
  
=head2 location_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::LocationType>

=cut

belongs_to
  location_types => "Interchange6::Schema::Result::LocationType",
  { "foreign.location_types_id" => "self.location_types_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 inventory_log

Type: has_many

Related object: L<Interchange6::Schema::Result::InventoryLog>

=cut

has_many
  inventory_logs => "Interchange6::Schema::Result::InventoryLog",
  { "foreign.locations_id" => "self.locations_id" },
  { cascade_copy  => 0, cascade_delete => 0 };
  
1;