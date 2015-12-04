use utf8;

package Interchange6::Schema::Result::Currency;

=head1 NAME

Interchange6::Schema::Result::Currency - currencies from around the world

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 currency_iso_code

ISO 4217 three letter upper-case code for the currency.

Primary key.

=cut

primary_column currency_iso_code => { data_type => "char", size => 3 };

=head2 name

Currency name

=cut

column name => { data_type => "varchar", size => 64 };

=head2 active

Whether this currency is currently active (available) for this site.

Boolean defaults to true.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head1 RELATIONS

=head2 carts

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

has_many carts => "Interchange6::Schema::Result::Cart", "currency_iso_code";

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

has_many orders => "Interchange6::Schema::Result::Order", "currency_iso_code";

=head2 payments

Type: has_many

Related object: L<Interchange6::Schema::Result::PaymentOrder>

=cut

has_many
  payments => "Interchange6::Schema::Result::PaymentOrder",
  "currency_iso_code";

=head2 payment_fees

Type: has_many

Related object: L<Interchange6::Schema::Result::PaymentOrder>

=cut

has_many
  payment_fees => "Interchange6::Schema::Result::PaymentOrder",
  "payment_fee_currency_iso_code";

=head2 source_exchange_rates

Type: has_many

Related object: L<Interchange6::Schema::Result::ExchangeRate>

=cut

has_many
  source_exchange_rates => "Interchange6::Schema::Result::ExchangeRate",
  "source_currency_iso_code";

=head2 target_exchange_rates

Type: has_many

Related object: L<Interchange6::Schema::Result::ExchangeRate>

=cut

has_many
  target_exchange_rates => "Interchange6::Schema::Result::ExchangeRate",
  "target_currency_iso_code";

1;
