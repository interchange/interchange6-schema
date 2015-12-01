use utf8;

package Interchange6::Schema::Result::ExchangeRate;

=head1 NAME

Interchange6::Schema::Result::ExchangeRate

=cut

use Interchange6::Schema::Candy -components =>
  [qw/ InflateColumn::DateTime TimeStamp /];

=head1 COMPONENTS

The following components are used:

=over

=item * DBIx::Class::InflateColumn::DateTime

=item * DBIx::Class::TimeStamp

=back

=head1 DESCRIPTION

This class stores exchange rates between different currencies.

=head1 ACCESSORS

=head2 exchange_rate_id

Primary key.

=cut

primary_column exchange_rate_id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 source_currency_iso_code

FK on L<Interchange6::Schema::Result::Currency/currency_iso_code>.

=cut

column source_currency_iso_code => { data_type => "char", size => 3 };

=head2 target_currency_iso_code

FK on L<Interchange6::Schema::Result::Currency/currency_iso_code>.

=cut

column target_currency_iso_code => { data_type => "char", size => 3 };

=head2 rate

The exchange rate multipler to convert from L</source_currency_iso_code>
to L</target_currency_iso_code>.

=cut

column rate => { data_type => "double" };

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type     => "datetime",
    set_on_create => 1
};

=head1 RELATIONS

=head2 source_currency

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Currency>

=cut

belongs_to
  source_currency => "Interchange6::Schema::Result::Currency",
  "source_currency_iso_code";

=head2 target_currency

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Currency>

=cut

belongs_to
  target_currency => "Interchange6::Schema::Result::Currency",
  "target_currency_iso_code";

1;
