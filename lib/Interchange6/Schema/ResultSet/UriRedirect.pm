use utf8;

package Interchange6::Schema::ResultSet::UriRedirect

=head1 NAME

Interchange6::Schema::ResultSet::UriRedirect

=cut

=head1 SYNOPSIS

Provides extra accessor methods for L<Interchange6::Schema::Result::UriRedirect

=cut

use strict;
use warnings;

use parent 'Interchange6::Schema::ResultSet';

=head1 METHODS

=head2 with_status

Adds C<status> column which is available to order_by clauses and
whose value can be retrieved via
L<Interchange6::Schema::Result::Order/status>.

=cut

sub with_status {
    my $self = shift;

    my $me = $self->me;

    return $self->search(
        undef,
        {
            '+columns' => {
                status => $self->correlate('statuses')->rows(1)
                  ->order_by('!created,!order_status_id')->get_column('status')
                  ->as_query,
            },
        }
    );
}

1;
