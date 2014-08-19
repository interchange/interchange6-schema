use utf8;

package Interchange6::Schema::Result::ShipmentRate;

=head1 NAME

Interchange6::Schema::Result::ShipmentRate

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 DESCRIPTION

In the context of shipment the rate is the value give for a shipping method based on
desination zone_id and weight.

=over 4

=item * Flat rate shipping

If min_weight and max_weight are set to 0 for a shipping method and zone flate rate will be
assumed.  If min_weight is set and max_weight is 0 max weight is assumed as infinite.

=back

=head1 ACCESSORS

=head2 shipment_rates_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column shipment_rates_id =>
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0, };

=head2 zones_id 

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column zones_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 shipment_methods_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column shipment_methods_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

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

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column price => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ],
};

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column created =>
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 };

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable   => 0
};

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

belongs_to
  zone => "Interchange6::Schema::Result::Zone",
  "zones_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment_method

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

belongs_to
  shipment_method => "Interchange6::Schema::Result::ShipmentMethod",
  "shipment_methods_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
