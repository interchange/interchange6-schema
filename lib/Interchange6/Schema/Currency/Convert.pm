package Interchange6::Schema::Currency::Convert;

=head1 NAME

Interchange6::Schema::Currency::Convert - Simple currency converter class for use with Interchange6::Currency

=cut

use Moo;

=head1 DESCRIPTION

Uses the most recent L<Interchange6::Schema::Result::ExchangeRate/rate> where
L<Interchange6::Schema::Result::ExchangeRate/valid_from> is not in the future
to L</convert> from C<$source_currency_iso_code> to
C<$target_currency_iso_code>.

Returns undef if no rate is found.

=head1 ACCESSORS

=head2 schema

Required. An L<Interchange6::Schema> object (or subclass).

=cut

has schema => (
    is       => 'ro',
    required => 1,
);

=head1 METHODS

=head2 convert $value, $source_currency_iso_code, $target_currency_iso_code

=cut

sub convert {
    my ( $self, $value, $source_currency_code, $target_currency_code ) = @_;

    my $schema = $self->schema;

    my $exchange_rate = $schema->resultste('ExchangeRate')->search(
        {
            source_currency_iso_code => $source_currency_code,
            target_currency_iso_code => $target_currency_code,
            valid_from => { '<=' => $schema->format_datetime( DateTime->now ) },
        },
        {
            order_by => { -desc => valid_from },
            rows     => 1,
        }
    )->first;

    return $exchange_rate ? $value * $exchange_rate->rate : undef;
}

1;

