use utf8;

package Interchange6::Schema::Result::WebsiteCurrency;

=head1 NAME

Interchange6::Schema::Result::WebsiteCurrency - link table website currencies

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 website_id

FK on L<Interchange6::Schema::Result::Website/id>.

=cut

column website_id => { data_type => "integer" };

=head2 currency_iso_code

FK on L<Interchange6::Schema::Result::Currency/iso_code>.

=cut

column currency_iso_code => { data_type => "char", size => 3 };

=head2 active

Whether this currency is currently active (available) for this site.

Boolean defaults to true.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head1 PRIMARY KEY

=over 4

=item * L</website_id>

=item * L</currency_iso_code>

=back

=cut

primary_key "website_id", "currency_iso_code";

=head1 RELATIONS

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

=head2 currency

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Currency>

=cut

belongs_to
  currency => "Interchange6::Schema::Result::Currency",
  "currency_iso_code";

1;
