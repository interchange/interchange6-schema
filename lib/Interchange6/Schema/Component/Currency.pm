package Interchange6::Schema::Component::Currency;

=head1 NAME

Interchange6::Schema::Component::Currency

=head1 DESCRIPTION

Adds L</as_currency> method to consuming class which returns
L<Interchange6::Schema::Currency> objects.

=head1 SYNOPSIS

 package My::Schema::Result::Thing;
 
 __PACKAGE__->load_components(
    qw( +Interchange6::Schema::Component::Currency ));
  
 sub price_as_currency {
     return $self->as_currency( $self->price, $self->currency_iso_code );
 }

=cut

use strict;
use warnings;

use base 'DBIx::Class';
use Interchange6::Schema::Currency;

=head1 METHODS

=head2 as_currency $value, $currency_iso_code?

Creates and returns a new L<Interchange6::Currency> object. 

If C<$currency_iso_code> is not supplied then
L<Interchange6::Schema/currency_iso_code> is used. The locale of the Currency
object is taken from L<Interchange6::Schema/locale>

=cut

sub as_currency {
    my ( $self, $value, $code ) = @_;

    $self->throw_exception("value not supplied to as_currency")
      unless defined $value;

    my $schema = $self->result_source->schema;

    return Interchange6::Schema::Currency->new(
        schema        => $schema,
        locale        => $schema->locale,
        currency_code => $code || $schema->currency_iso_code,
        value         => $value,
    );
}

1;
