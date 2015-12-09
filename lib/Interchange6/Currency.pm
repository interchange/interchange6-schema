package Interchange6::Currency;

=head1 NAME

Interchange6::Currency - Currency objects

=cut

use Moo;
extends 'CLDR::Number::Format::Currency';

use Carp;
use Math::BigFloat;
use MooseX::CoverableModifiers;
use Safe::Isa;
use Types::Standard qw/InstanceOf Str/;
use namespace::clean;
use overload
  '0+'  => sub { shift->value },
  '""'  => sub { shift->as_string },
  '+'   => \&_add,
  '-'   => \&_subtract,
  '*'   => \&_multiply,
  '/'   => \&_divide,
  '%'   => \&modulo,
  '<=>' => \&cmp_value,
  'cmp' => \&cmp,
  ;

=head1 DESCRIPTION

Extends L<CLDR::Number::Format::Currency> with accurate calculation functions
using L<Math::BigFloat>.

Many useful standard operators are overloaded and return currency objects
if appropriate.

=head1 ATTRIBUTES

=head2 value

Value as simple decimal, e.g.: 3.45

All values are coerced into L<Math::BigFloat>.

=cut

has value => (
    is       => 'ro',
    required => 1,
    coerce   => sub {
        $_[0]->$_isa("Math::BigFloat") ? $_[0] : Math::BigFloat->new( $_[0] );
    },
);

=head2 as_string

Stringified formatted currency, e.g.: $3.45

=cut

has as_string => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
    clearer  => 1,
);

sub _build_as_string {
    return $_[0]->format( $_[0]->value );
}

after 'add', 'subtract', 'multiply', 'divide' => sub {
    shift->clear_as_string;
};

# check for currency objects with different currency codes and if arg
# is a currency object return its value
sub _clean_other {
    my ( $self, $other ) = @_;

    # uncoverable branch true
    croak "_clean_other is a class method" unless $self->$_isa(__PACKAGE__);

    if ( $other->$_isa(__PACKAGE__) ) {
        croak "Cannot perform calculation when currencies do not match"
          if $self->currency_code ne $other->currency_code;
        return $other->value;
    }
    return $other;
}

=head1 METHODS

=head2 BUILD

Sets precision for automatic rounding of L</value> to 
L<CLDR::Number::Format::Currency/maximum_fraction_digits>.

=cut

# FIXME: this should use a method in CLDR::* somewhere but I'm damned
# if I can find it.
sub BUILD {
    my $self       = shift;
    my $currencies = $CLDR::Number::Data::Currency::CURRENCIES;
    my $currency_data =
      exists $currencies->{ $self->currency_code }
      ? $currencies->{ $self->currency_code }
      : $currencies->{DEFAULT};

    $self->minimum_fraction_digits( $currency_data->{digits} );
    $self->maximum_fraction_digits( $currency_data->{digits} );
    $self->value->precision( -$currency_data->{digits} );
}

=head2 add $arg

Add C<$arg> to L</value> in place.

=cut

sub add {
    my ( $self, $other ) = @_;
    $self->value->badd( $self->_clean_other($other) );
}

# for overloaded '+'
sub _add {
    my ( $self, $other ) = @_;
    return __PACKAGE__->new(
        value => $self->value->copy->badd( $self->_clean_other($other) ),
        currency_code => $self->currency_code,
        locale        => $self->locale,
    );
}

=head2 subtract $arg

Subtract C<$arg> from L</value> in place.

=cut

sub subtract {
    my ( $self, $other ) = @_;
    $self->value->bsub( $self->_clean_other($other) );
}

# for overloaded '-'
sub _subtract {
    my ( $self, $other, $swap ) = @_;
    my $result = $self->value->copy->bsub( $self->_clean_other($other) );
    return __PACKAGE__->new(
        value => $swap ? $result->bneg : $result,
        currency_code => $self->currency_code,
        locale        => $self->locale,
    );
}

=head2 multiply $arg

Multiply L</value> by C<$arg> in place.

=cut

sub multiply {
    my ( $self, $other ) = @_;
    $self->value->bmul( $self->_clean_other($other) );
}

# for overloaded '*'
sub _multiply {
    my ( $self, $other ) = @_;
    return __PACKAGE__->new(
        value => $self->value->copy->bmul( $self->_clean_other($other) ),
        currency_code => $self->currency_code,
        locale        => $self->locale,
    );
}

=head2 divide $arg

Divide L</value> by C<$arg> in place.

=cut

sub divide {
    my ( $self, $other ) = @_;
    $self->value->bdiv( $self->_clean_other($other) );
}

# for overloaded '/'
sub _divide {
    my ( $self, $other, $swap ) = @_;
    my $result;
    if ($swap) {
        $result =
          Math::BigFloat->new( $self->_clean_other($other) )
          ->bdiv( $self->value );
    }
    else {
        $result = $self->value->copy->bdiv( $self->_clean_other($other) );
    }
    return __PACKAGE__->new(
        value         => $result,
        currency_code => $self->currency_code,
        locale        => $self->locale,
    );
}

=head2 modulo $arg

Return L</value> C<%> C<$arg> as currency object.

=cut

sub modulo {
    my ( $self, $other, $swap ) = @_;
    my $result;
    if ($swap) {
        $result = Math::BigFloat->new( $self->_clean_other($other) )
          ->bmod( $self->value );
    }
    else {
        $result = $self->value->copy->bmod( $self->_clean_other($other) );
    }
    return __PACKAGE__->new(
        value         => $result,
        currency_code => $self->currency_code,
        locale        => $self->locale,
    );
}

=head2 cmp_value $arg

Equivalent to L</value> C<< <=> >> C<$arg>.

=cut

sub cmp_value {
    my ( $self, $other, $swap ) = @_;
    if ($swap) {
        return Math::BigFloat->new( $self->_clean_other($other) )
          ->bcmp( $self->value );
    }
    else {
        return $self->value->bcmp( $self->_clean_other($other) );
    }
}

=head2 cmp $arg

String comparison.

Not always useful in itself since string comparison of stringified currency
objects might not produce what you expect depending on locale and currency
code.

=cut

sub cmp {
    my ( $self, $other, $swap ) = @_;
    if ($swap) {
        return "$other" cmp "$self";
    }
    else {
        return "$self" cmp "$other";
    }
}

1;
