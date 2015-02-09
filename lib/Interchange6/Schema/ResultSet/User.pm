use utf8;

package Interchange6::Schema::ResultSet::User;

=head1 NAME

Interchange6::Schema::ResultSet::User

=cut

=head1 SYNOPSIS

Provides extra accessor methods for L<Interchange6::Schema::Result::User>

=cut

use strict;
use warnings;

use parent 'Interchange6::Schema::ResultSet';

=head1 METHODS

=head2 find_user_with_reset_token( $token );

Where $token is the combined <Interchange6::Schema::Result::User/reset_token>
and <Interchange6::Schema::Result::User/reset_token_checksum> as would be
returned by <Interchange6::Schema::Result::User/reset_token_generate>.

Returns an <Interchange6::Schema::Result::User> object if $token is found and
is valid. On failure returns undef.

=cut

sub find_user_with_reset_token {
    my ( $self, $arg ) = @_;

    my ( $token, $checksum ) = split(/_/, $arg);

    $self->throw_exception("Bad argument to find_user_with_reset_token")
      unless ( $token && $checksum );

    my $users = $self->search({reset_token => $token});

    while ( my $user = $users->next ) {
        return $user if $user->reset_token_verify( $arg );
    }

    return undef;
}

1;
