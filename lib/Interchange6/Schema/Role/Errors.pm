use utf8;

package Interchange6::Schema::Role::Errors;

=head1 NAME

Interchange6::Schema::Role::Errors

=cut

use strict;
use warnings;

use Moo::Role;
use MooX::Types::MooseLike;
use MooX::Types::MooseLike::Base qw/ArrayRef/;
use MooX::HandlesVia;

use namespace::clean;

=head2 errors

Returns an arrayref of errors. If there are no errors then the arrayref will be empty.

=head2 clear_errors

Clears all errors.

=head2 error_count

Returns the number of errors.

=head2 has_error

Returns 0 if no errors or a positive integer if there are errors (this is actually an alias for error_count).

=head2 add_error

Takes a simple scalar as arg containing the text of the error to be added.

  $self->add_error('Some error text')

=cut

has errors => (
    is          => 'ro',
    isa         => ArrayRef,
    default     => sub { [] },
    handles_via => 'Array',
    handles     => {
        clear_errors => 'clear',
        error_count  => 'count',
        has_error    => 'count',
        add_error   => 'push',
    }
);

1;
