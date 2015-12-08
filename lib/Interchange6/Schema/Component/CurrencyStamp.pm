package Interchange6::Schema::Component::CurrencyStamp;

=head1 NAME

Interchange6::Schema::Component::CurrencyStamp

=head1 DESCRIPTION

Result class helper to provide default values for
C<currency_iso_code> on record create.

=head1 SYNOPSIS

 package My::Schema::Result::Thing;
 
 __PACKAGE__->load_components(
    qw( +Interchange6::Schema::Component::CurrencyStamp ));
  
 __PACKAGE__->add_columns(
    thing_id => { data_type => 'integer' },
    currency_iso_code => {
      data_type => 'char', size => 3, set_currency_on_create => 1 },
 );

=cut

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/DynamicDefault/);

=head1 METHODS

=head2 add_columns

=cut

sub add_columns {
    my ( $self, @cols ) = @_;
    my @columns;

    while ( my $col = shift @cols ) {
        my $info = ref $cols[0] ? shift @cols : {};
        if ( delete $info->{set_currency_on_create} ) {
            $info->{dynamic_default_on_create} = 'get_currency_iso_code';
        }
        push @columns, $col => $info;
    }

    return $self->next::method(@columns);
}

=head2 get_currency_iso_code

Returns the value of L<Interchange6::Schema/currency_iso_code>.

=cut

sub get_currency_iso_code {
    return $_[0]->result_source->schema->currency_iso_code;
}

1;
