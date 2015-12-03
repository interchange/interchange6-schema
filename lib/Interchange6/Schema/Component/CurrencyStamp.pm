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

This is the method which provides the default value C<currency_iso_code>.

If L<Interchange6::Schema/currency_iso_code> is set then return it.

Otherwise perform the following query to try to find the currency:

    my $currency_iso_code = $schema->resultset('Setting')->find(
        {
            scope    => 'global',
            name     => 'currency_iso_code',
            category => '',
        }
    );

On failure a default value of 'EUR' is used.

L<Interchange6::Schema/currency_iso_code> is then set and returned.

=cut

sub get_currency_iso_code {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    if ( !$schema->currency_iso_code ) {
        my $currency_iso_code = $schema->resultset('Setting')->find(
            {
                scope    => 'global',
                name     => 'currency_iso_code',
                category => '',
            }
        );
        $schema->set_currency_iso_code(
            $currency_iso_code ? $currency_iso_code->value : 'EUR' );
    }
    return $schema->currency_iso_code;
}

1;
