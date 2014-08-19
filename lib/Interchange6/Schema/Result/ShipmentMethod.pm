use utf8;

package Interchange6::Schema::Result::ShipmentMethod;

=head1 NAME

Interchange6::Schema::Result::ShipmentMethod

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 shipment_methods_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column shipment_methods_id =>
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0, };

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
    size          => 255
};

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column title => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 min_weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column min_weight => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ]
};

=head2 max_weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column max_weight => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ]
};

=head2 shipment_carriers_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column shipment_carriers_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column active =>
  { data_type => "boolean", default_value => 1, is_nullable => 0 };

=head1 RELATIONS

=head2 shipment_carrier

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentCarrier>

=cut

belongs_to
  shipment_carrier => "Interchange6::Schema::Result::ShipmentCarrier",
  "shipment_carriers_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment_rates

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentRate>

=cut

has_many
  shipment_rates => "Interchange6::Schema::Result::ShipmentRate",
  "shipment_methods_id",
  { cascade_copy => 0, cascade_delete => 0 };

1;
