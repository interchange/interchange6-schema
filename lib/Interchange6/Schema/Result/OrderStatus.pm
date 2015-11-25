use utf8;

package Interchange6::Schema::Result::OrderStatus;

=head1 NAME

Interchange6::Schema::Result::OrderStatus

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 order_id

FK on L<Interchange6::Schema::Result::Order/id>.

=cut

column order_id => { data_type => "integer" };

=head2 status

Status of the order, e.g.: picking, complete, shipped, cancelled

=cut

column status => { data_type => "varchar", size => 32 };

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => { data_type => "datetime", set_on_create => 1 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 order

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Order>

=cut

belongs_to order => "Interchange6::Schema::Result::Order", "order_id";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
