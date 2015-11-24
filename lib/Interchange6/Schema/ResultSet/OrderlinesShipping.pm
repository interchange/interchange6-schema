use utf8;

package Interchange6::Schema::ResultSet::OrderlinesShipping;

=head1 NAME

Interchange6::Schema::ResultSet::OrderlinesShipping

=cut

use strict;
use warnings;

use parent 'Interchange6::Schema::ResultSet';

=head1 METHODS

=head2 delete

Rows in this table should not be deleted so we overload
L<DBIx::Class::ResultSet/delete> to throw an exception.

=cut

sub delete {
    shift->result_source->schema->throw_exception(
        "OrderlinesShipping rows cannot be deleted");
}

1;
