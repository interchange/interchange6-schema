use utf8;

package Interchange6::Schema::Result::ShipmentCarrier;

=head1 NAME

Interchange6::Schema::Result::ShipmentCarrier

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id =>
  { data_type => "integer", is_auto_increment => 1 };

=head2 name

Short name of carrier, e.g.: USPS.

=cut

column name => {
    data_type     => "varchar",
    size          => 255
};

=head2 title

Full title of carrier.

Defaults to empty string.

=cut

column title => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 account_number

Account number with carrier.

Defaults to empty string.

=cut

column account_number => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 active

Whether carrier is active. Defaults to 1 (true).

=cut

column active =>
  { data_type => "boolean", default_value => 1 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 shipment_methods

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

has_many
  shipment_methods => "Interchange6::Schema::Result::ShipmentMethod",
  "shipment_carrier_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
