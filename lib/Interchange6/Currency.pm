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
use Types::Standard qw/InstanceOf Object Str/;
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
  '='   => \&clone,
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

# check for currency objects with different currency codes and if arg
# is a currency object return its value
sub _clean_arg {
    my ( $self, $arg ) = @_;

    # uncoverable branch true
    croak "_clean_arg is a class method" unless $self->$_isa(__PACKAGE__);

    if ( $arg->$_isa(__PACKAGE__) ) {
        croak "Cannot perform calculation when currencies do not match"
          if $self->currency_code ne $arg->currency_code;
        return $arg->value;
    }
    return $arg;
}

=head2 converter_class

Defaults to L<Interchange6::Currency::Converter>.

The class name which handles conversion to a new C<currency_code>. The
converter class must have a C<new> method which returns a vivified object
which we can access via L</converter>. It must also provide and a C<convert>
method which is passed two arguments: an L<Interchange6::Currency> object and
the new C<currency_code>. If C<convert> is called in void context then
the currency object should be updated in place otherwise the passed object
should not be modified and a new L<Interchange6::Currency> object should be
returned.

=cut

has converter_class => (
    is      => 'ro',
    isa     => Str,
    default => sub { "Interchange6::Currency::Converter" },
);

=head2 converter

Vivified L</converter_class>.

=cut

has converter => (
    is       => 'lazy',
    isa      => Object,
    init_arg => undef,
);

sub _build_converter {
    return $_[0]->converter_class->new;
    my $self = shift;
}

=head2 cash

See L<CLDR::Number::Format::Currency/cash>.

Precision of L</value> is reset whenever the value of L</cash> is updated.

=cut

#after 'cash', 'currency_code' => sub {
#after 'cash' => sub {
#    my ( $self, $arg ) = @_;
#    if ( defined $arg ) {
#        $self->value->precision( -$self->maximum_fraction_digits );
#    }
#};

=head1 METHODS

=head2 BUILD

Sets precision for automatic rounding of L</value> to 
L<CLDR::Number::Format::Currency/maximum_fraction_digits>.

=cut

sub BUILD {
    my $self = shift;
    $self->_trigger_cash;
    $self->value->precision( -$self->maximum_fraction_digits );
}

=head2 clone %new_attrs?

Returns clone of the currency object possibly with new attribute values (if
any are supplied).

=cut

sub clone {
    my ( $self, %new_attrs ) = @_;
    return __PACKAGE__->new(
        value         => $self->value,
        currency_code => $self->currency_code,
        locale        => $self->locale,
        %new_attrs,
    );
}

=head2 convert $new_corrency_code

Convert to new currency using L</converter>.

=cut

sub convert {
    my ( $self, $currency_code ) = @_;
    $self->converter->convert($currency_code);
}

=head2 as_string

Stringified formatted currency, e.g.: $3.45

=cut

sub as_string {
    return $_[0]->format( $_[0]->value );
}

=head2 stringify

Alias for L</as_string>.

=cut

sub stringify {
    return $_[0]->as_string;
}

=head2 add $arg

Add C<$arg> to L</value> in place.

=cut

sub add {
    my ( $self, $arg ) = @_;
    $self->value->badd( $self->_clean_arg($arg) );
}

# for overloaded '+'
sub _add {
    my ( $self, $arg ) = @_;
    $self->clone(
        value => $self->value->copy->badd( $self->_clean_arg($arg) ) );
}

=head2 subtract $arg

Subtract C<$arg> from L</value> in place.

=cut

sub subtract {
    my ( $self, $arg ) = @_;
    $self->value->bsub( $self->_clean_arg($arg) );
}

# for overloaded '-'
sub _subtract {
    my ( $self, $arg, $swap ) = @_;
    my $result = $self->value->copy->bsub( $self->_clean_arg($arg) );
    $self->clone( value => $swap ? $result->bneg : $result );
}

=head2 multiply $arg

Multiply L</value> by C<$arg> in place.

=cut

sub multiply {
    my ( $self, $arg ) = @_;
    $self->value->bmul( $self->_clean_arg($arg) );
}

# for overloaded '*'
sub _multiply {
    my ( $self, $arg ) = @_;
    $self->clone(
        value => $self->value->copy->bmul( $self->_clean_arg($arg) ) );
}

=head2 divide $arg

Divide L</value> by C<$arg> in place.

=cut

sub divide {
    my ( $self, $arg ) = @_;
    $self->value->bdiv( $self->_clean_arg($arg) );
}

# for overloaded '/'
sub _divide {
    my ( $self, $arg, $swap ) = @_;
    my $result;
    if ($swap) {
        $result =
          Math::BigFloat->new( $self->_clean_arg($arg) )->bdiv( $self->value );
    }
    else {
        $result = $self->value->copy->bdiv( $self->_clean_arg($arg) );
    }
    $self->clone( value => $result );
}

=head2 modulo $arg

Return L</value> C<%> C<$arg> as currency object.

=cut

sub modulo {
    my ( $self, $arg, $swap ) = @_;
    my $result;
    if ($swap) {
        $result =
          Math::BigFloat->new( $self->_clean_arg($arg) )->bmod( $self->value );
    }
    else {
        $result = $self->value->copy->bmod( $self->_clean_arg($arg) );
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
    my ( $self, $arg, $swap ) = @_;
    if ($swap) {
        return Math::BigFloat->new( $self->_clean_arg($arg) )
          ->bcmp( $self->value );
    }
    else {
        return $self->value->bcmp( $self->_clean_arg($arg) );
    }
}

=head2 cmp $arg

String comparison.

Not always useful in itself since string comparison of stringified currency
objects might not produce what you expect depending on locale and currency
code.

=cut

sub cmp {
    my ( $self, $arg, $swap ) = @_;
    if ($swap) {
        return "$arg" cmp "$self";
    }
    else {
        return "$self" cmp "$arg";
    }
}

1;
