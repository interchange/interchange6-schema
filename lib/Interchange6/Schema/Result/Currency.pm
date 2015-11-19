use utf8;

package Interchange6::Schema::Result::Currency;

=head1 NAME

Interchange6::Schema::Result::Currency - currencies from around the world

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 iso_code

ISO 4217 three letter upper-case code for the currency.

Primary key.

=cut

primary_column iso_code => { data_type => "char", size => 3 };

=head2 name

Currency name

=cut

column name => { data_type => "varchar", 64 };

=head1 RELEATIONS

=head2 products

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

has_many
  products => "Interchange6::Schema::Result::Product",
  "currency_iso_code";

=head2 website_currencies

Relation to the Website <-> Currency link table

Type: has_many

Related object: L<Interchange6::Schema::Result::WebsiteCurrency>

=cut

has_many
  website_currencies => "Interchange6::Schema::Result::WebsiteCurrency",
  "currency_iso_code";

=head2 websites

Type: many_to_many

Composing rels: L</website_currencies> -> website

=cut

many_to_many websites => "website_currencies", "website";

1;
