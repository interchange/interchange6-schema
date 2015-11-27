package Interchange6::Schema::Component::DynamicDefaults;

=head1 NAME

Interchange6::Schema::Component::DynamicDefaults;

=head1 DESCRIPTION

Result class helper to provide default values for C<website_id> and
C<currency_iso_code> on record create.

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
        if ( $col eq 'currency_id' ) {
            $info->{dynamic_default_on_create} = 'get_currency_id';
        }
        elsif ( $col eq 'website_id' ) {
            $info->{dynamic_default_on_create} = 'get_website_id';
        }
        push @columns, $col => $info;
    }

    return $self->next::method(@columns);
}

=head2 get_currency_iso_code

=cut

sub get_currency_id {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    if ( $schema->primary_currency ) {
        return $schema->primary_currency->id;
    }
}

=head2 get_website_id

=cut

sub get_website_id {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    if ( $schema->current_website ) {
        return $schema->current_website->id;
    }
}

1;
