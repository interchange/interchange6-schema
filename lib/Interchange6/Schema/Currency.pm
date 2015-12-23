package Interchange6::Schema::Currency;

=head1 NAME

Interchange6::Schema::Currency - subclass of Interchange6::Currency with added schema

=cut

use Moo;
extends 'Interchange6::Currency';

=head1 ACCESSORS

=head2 schema

Required. An L<Interchange6::Schema> object (or subclass).

=cut

has schema => (
    is       => 'ro',
    required => 1,
);

sub _build_converter {
    my $self = shift;
    load_class( $self->converter_class );
    return $self->converter_class->new( schema => $self->schema );
}

1;
