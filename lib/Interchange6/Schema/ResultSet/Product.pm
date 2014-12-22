use utf8;

package Interchange6::Schema::ResultSet::Product;

=head1 NAME

Interchange6::Schema::ResultSet::Product

=cut

=head1 SYNOPSIS

Provides extra accessor methods for L<Interchange6::Schema::Result::Product>

=cut

use strict;
use warnings;

use parent 'Interchange6::Schema::ResultSet';

=head1 METHODS

See also L<DBIx::Class::Helper::ResultSet::Shortcut> which is loaded by this
result set.

=head2 active

Returns all rows where L<Interchange6::Schema::Result::Product/active> is true.

=cut

sub active {
    return shift->search({ active => 1 });
}

=head2 listing

Returns a result set which has been inflated using
L<DBIx::Class::ResultClass::HashRefInflator> ready for use by a product listing
page.

Accepts a hashref of the following optional arguments:

=over

=item * quantity => minimum value of L<Interchange6::Schema::Result::PriceModifier/quantity>

=item * users_id => L<Interchange6::Schema::Result::User/users_id>

=back

Returned columns are:

=over

=item * L<Interchange6::Schema::Result::Product/sku>

=item * L<Interchange6::Schema::Result::Product/name>

=item * L<Interchange6::Schema::Result::Product/uri>

=item * L<Interchange6::Schema::Result::Product/price>

=item * C<selling_price> from L<Interchange6::Schema::Result::PriceModifier/price>

=item * C<inventory> from L<Interchange6::Schema::Result::Inventory/quantity>

=item * C<discount_percent> based on difference between C<price> and C<selling_price>

=back

Since the last three columns are normally only available via
->get_column('column_name') it is suggested that any returned result set is
inflated into hash references using L<DBIx::Class::ResultClass::HashRefInflator>
to make these values easily accessible.

NOTE: it is NOT necessarily safe to chain on the end of this method due to its
use of the relationship
L<Interchange6::Schema::Result::Product/current_price_modifiers> which requires
bind values to be passed so test very carefully. It is certainly NOT possible
to call ->count on the returned result set as it will either throw an
exception or give you a completely unexpected result. If you need to count
the result set then do that before calling this method.

=cut

sub listing {
    my ( $self, $args ) = @_;

    if ( defined($args) ) {
        $self->throw_exception(
            "argument to listing must be a hash reference")
          unless ref($args) eq "HASH";
    }

    $args->{quantity} = 1 unless defined $args->{quantity};

    my $schema = $self->result_source->schema;
    my $dtf = $schema->storage->datetime_parser;
    my $today = $dtf->format_datetime(DateTime->today);

    return $self->search(
        undef,
        {
            alias   => 'product',
            columns => [
                qw/
                  product.sku product.name product.uri product.price
                  product.short_description
                  /
            ],
            '+columns' => [
                { selling_price => \ "COALESCE(
                    MIN( current_price_modifiers.price ), product.price )"
                },
                { inventory => 'inventory.quantity' },
                { discount_percent => \ "ROUND (
                    ( product.price - MIN( current_price_modifiers.price ) )
                    / product.price * 100 - 0.5 )"
                },
            ],
            join => [
                'current_price_modifiers', { _product_reviews => 'message' },
                'inventory'
            ],
            bind => [
                [ end_date => $today ],
                [ quantity => $args->{quantity} ],
                [ { sqlt_datatype => "integer" } => $args->{users_id} ],
                [ start_date => $today ],
            ],
            group_by => [ 'product.sku', 'inventory.quantity' ],
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    );
}

1;
