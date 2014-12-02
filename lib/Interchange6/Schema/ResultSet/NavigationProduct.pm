use utf8;

package Interchange6::Schema::ResultSet::NavigationProduct;

=head1 NAME

Interchange6::Schema::ResultSet::NavigationProduct

=cut

use warnings;
use strict;

use base 'DBIx::Class::ResultSet';

=head1 DESCRIPTION

Additional result set methods for L<Interchange6::Schema::Result::NavigationProduct>.

=head1 METHODS

=head2 product_with_selling_price

Optional arguments are passed as a hashref using the keys C<quantity> and C<users_id>.

=cut

sub product_with_selling_price {
    my ( $self, $args ) = @_;

    if ($args) {
        $self->throw_exception(
            "Argument to product_with_selling_price must be a hash reference")
          unless ref($args) eq 'HASH';
    }

    # default value for quantity is 1
    $args->{quantity} = 1 unless defined $args->{quantity};

    my $dtf = $self->result_source->schema->storage->datetime_parser;
    my $today = $dtf->format_datetime(DateTime->today);

    return $self->search_related('_product_with_selling_price',
        undef,
        {
            bind => [
                [ { sqlt_datatype => "date" }    => $today ],
                [ { sqlt_datatype => "integer" } => $args->{quantity} ],
                [ { sqlt_datatype => "integer" } => $args->{users_id} ],
                [ { sqlt_datatype => "date" }    => $today ],
            ]
        }
    );
}

1;
