use utf8;

package Interchange6::Schema::Result::ExchangeRate;

=head1 NAME

Interchange6::Schema::Result::ExchangeRate

=cut

use Interchange6::Schema::Candy -components => [
    qw(
      InflateColumn::DateTime TimeStamp
      +Interchange6::Schema::Component::CurrencyStamp
      )
];

=head1 COMPONENTS

The following components are used:

=over

=item * DBIx::Class::InflateColumn::DateTime

=item * DBIx::Class::TimeStamp

=item * Interchange6::Schema::Component::CurrencyStamp

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

Defaults to value set via L<Interchange6::Schema::Component::CurrencyStamp>

=cut

column source_currency_iso_code => {
    data_type              => "char",
    size                   => 3,
    set_currency_on_create => 1
};

=head2 target_currency_iso_code

FK on L<Interchange6::Schema::Result::Currency/currency_iso_code>.

=cut

column target_currency_iso_code => { data_type => "char", size => 3 };

=head2 rate

The exchange rate multiplier to convert from L</source_currency_iso_code>
to L</target_currency_iso_code>.

=cut

column rate => { data_type => "double" };

=head2 date

Date when this exchange rate is valid returned as L<DateTime> object.
Value is auto-set to the current date on insert if not supplied.

=cut

column date => {
    data_type     => "date",
    set_on_create => 1
};

=head1 UNIQUE CONSTRAINT

=head2 source_currency_iso_code target_currency_iso_code date

=cut

unique_constraint [ 'source_currency_iso_code', 'target_currency_iso_code',
    'date' ];

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

=head2 carts

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

has_many carts => "Interchange6::Schema::Result::Cart", "carts_id";

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

has_many orders => "Interchange6::Schema::Result::Order", "orders_id";

1;
