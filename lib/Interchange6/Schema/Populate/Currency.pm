package Interchange6::Schema::Populate::Currency;

=head1 NAME

Interchange6::Schema::Populate::Currency

=head1 DESCRIPTION

This module provides population capabilities for the Currency class

=cut

use Moo;
use Locale::Currency;

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per currency,
ready to use with populate schema method.

=cut

sub records {
    my @codes = all_currency_codes();
    my @currencies =
      map { +{ iso_code => $_, name => code2currency($_) } } @codes;
    return \@currencies;
}

1;
