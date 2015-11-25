use utf8;

package Interchange6::Schema::Result::Shipment;

=head1 NAME

Interchange6::Schema::Result::Shipment

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id =>
  { data_type => "integer", is_auto_increment => 1 };

=head2 tracking_number

Tracking number. Defaults to empty string.

=cut

column tracking_number => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 shipment_carrier_id

FK on L<Interchange6::Schema::Result::ShipmentCarrier/id>.

=cut

column shipment_carrier_id => { data_type => "integer" };

=head2 shipment_method_id

FK on L<Interchange6::Schema::Result::ShipmentMethod/id>.

=cut

column shipment_method_id => { data_type => "integer" };

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created =>
  { data_type => "datetime", set_on_create => 1 };

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 shipment_carrier

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentCarrier>

=cut

belongs_to
  shipment_carrier => "Interchange6::Schema::Result::ShipmentCarrier",
  "shipment_carrier_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 shipment_method

Type: belongs_to

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

belongs_to
  shipment_method => "Interchange6::Schema::Result::ShipmentMethod",
  "shipment_method_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
