use utf8;

package Interchange6::Schema::Result::Currency;

=head1 NAME

Interchange6::Schema::Result::Currency - currencies from around the world

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 iso_code

ISO 4217 three letter upper-case code for the currency.

=cut

column iso_code => { data_type => "char", size => 3 };

=head2 name

Currency name

=cut

column name => { data_type => "varchar", size => 64 };

=head2 active

Whether this currency is currently active (available) for this site.

Boolean defaults to true.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head2 website_id

FK on L<Interchange6::Schema::Result::Website/id>.

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 iso_code website_id

=cut

unique_constraint ['iso_code', 'website_id'];

=head1 RELEATIONS

=head2 products

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

has_many
  products => "Interchange6::Schema::Result::Product",
  "currency_id";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
