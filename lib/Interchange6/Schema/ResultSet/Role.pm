use utf8;

package Interchange6::Schema::ResultSet::Role;

=head1 NAME

Interchange6::Schema::ResultSet::Role

=cut

use strict;
use warnings;

use parent 'Interchange6::Schema::ResultSet';

=head1 METHODS

=head2 delete

Override delete to call C<delete_all> so that we can restrict which roles
a user is allowed to delete via L<Interchange6::Schema::Result::Role/delete>.

=cut

sub delete {
    $_[0]->delete_all;
}

1;
