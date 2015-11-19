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

primary column iso_code => { data_type => "char", size => 3 };

=head2 name

Currency name

=cut

column name => { data_type => "varchar", 64 };

1;
