package Interchange6::Currency::Converter;

=head1 NAME

Interchange6::Currency::Converter

=cut

use Moo;
use Safe::Isa;

=head1 METHODS

=head2 convert $currency_obj, $new_code

=cut

sub convert {
    my ( $self, $value, $old_code, $new_code ) = @_;

    if ( defined wantarray ) {

        # called in list or scalar context
        $currency_obj = $currency_obj->clone( currency_code => $new_code );
    }
    else {

        # void context
        $currency_obj->currency_code($new_code);
    }

    $currency_obj->multiply(1);

    return $currency_obj;
}

1;
