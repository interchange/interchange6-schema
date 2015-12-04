package Interchange6::Currency;

=head1 NAME

Interchange6::Currency - Currency objects

=cut

use Moo;
use CLDR::Number::Format::Currency;
use Types::Standard qw/InstanceOf Str/;
use namespace::clean;
use overload
  '0+' => sub { shift->value },
  '""' => sub { shift->stringify },
  '+'  => \&add,
  '-'  => \&subtract,
  '*'  => \&multiply,
  '/'  => \&divide,
  ;

=head1 ATTRIBUTES

=head2 value

Value as simple decimal, e.g.: 3.45

=cut

has value => (
    is       => 'ro',
    required => 1,
);

=head2 currency_code

3 letter ISO currency code

=cut

has currency_code => (
    is  => 'ro',
    isa => Str & sub {
        length( $_[0] ) == 3
          ? $_[0]
          : die "currency_code must be 3 characters long";
    },
    required => 1,
);

=head2 locale

=cut

has locale => (
    is       => 'ro',
    required => 1,
);

=head2 stringify

Strigified formatted currency

=cut

has stringify => (
    is => 'lazy',
    isa => Str,
    init_arg => undef,
    clearer => 1,
);

sub _build_stringify {
    my $self = shift;
    return CLDR::Number::Format::Currency->new(
        locale        => $self->locale,
        currency_code => $self->currency_code
    )->format( $self->value );
}

=head1 METHODS

=head2 add

=cut

sub add {
}

=head2 subtract

=cut

sub subtract {
}

=head2 multiply

=cut

sub multiply {
}

=head2 divide

=cut

sub divide {
}

1;
