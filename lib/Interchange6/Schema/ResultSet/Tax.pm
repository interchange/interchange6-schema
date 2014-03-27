use utf8;

package Interchange6::Schema::ResultSet::Tax;

=head1 NAME

Interchange6::Schema::ResultSet::Tax

=cut

=head1 SYNOPSIS

Provides extra accessor methods for L<Interchange6::Schema::Result::Tax>

=cut

use strict;
use warnings;

use DateTime;

use base 'DBIx::Class::ResultSet';

=head1 METHODS

=head2 current_tax( $tax_name )

Given a valid tax_name will return the Tax row for the current date

=cut

sub current_tax {
    my ( $self, $tax_name ) = @_;

    return undef unless defined $tax_name;

    my $schema = $self->result_source->schema;
    my $dtf    = $schema->storage->datetime_parser;
    my $dt     = DateTime->today;

    my $rset = $self->search(
        {
            tax_name   => $tax_name,
            valid_from => { '<=', $dtf->format_datetime($dt) },
            valid_to   => [ undef, { '>=', $dtf->format_datetime($dt) } ],
        }
    );

    if ( $rset->count == 1 ) {
        return $rset->next;
    }
    else {
        return undef;
    }
}

1;
