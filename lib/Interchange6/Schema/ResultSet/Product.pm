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
    return $_[0]->search({ $_[0]->me.'active' => 1 });
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

=item * C<selling_price>

The lowest of L<Interchange6::Schema::Result::PriceModifier/price> and L<Interchange6::Schema::Result::Product/price>

For products with variants this is the lowest variant price with or without modifiers.

=item * C<inventory>

From L<Interchange6::Schema::Result::Inventory/quantity>

For products with variants this is the total inventory for all variants.

=item * C<discount_percent>

Based on difference between C<price> and C<selling_price>

=item * C<average_rating>

From L<Interchange6::Schema::Result::Message/rating> where L<Interchange6::Schema::Result::Message/public> is C<true> and L<Interchange6::Schema::Result::Message/approved> is C<true> to one decimal place.

=item * C<has_variants>

Returns 1 if product has variants and 0 if not.

=back

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

    my $me = $self->me;
    my @columns = map { $me . $_ } (qw/sku name uri price short_description/);

    return $self->search(
        {
            -or => [
                -and => [
                    'message.approved' => 1,
                    'message.public'   => 1,
                ],
                'message.messages_id' => undef
            ]
        },
        {
            columns => \@columns,
            '+columns' => [
                { has_variants => \"
                    CASE
                      WHEN COUNT(variants.sku) > 0 THEN 1
                      ELSE 0
                    END"
                },
                {
                    selling_price => \"
                    CASE
                      WHEN COUNT(variants.sku) > 0 THEN
                        CASE WHEN 
                          COALESCE(
                            MIN( current_price_modifiers_2.price ),
                            MIN( variants.price )
                          ) < MIN( variants.price )
                        THEN
                          COALESCE(
                            MIN( current_price_modifiers_2.price ),
                            MIN( variants.price )
                          )
                        ELSE
                          MIN( variants.price )
                        END
                      ELSE
                        COALESCE(
                          MIN( current_price_modifiers.price ),
                          ${me}price
                        )
                    END AS selling_price"
                },
                {
                    inventory => \
                      "SUM(inventory.quantity + inventory_2.quantity)"
                },
                {
                    discount_percent => \"ROUND (
                      ( ${me}price
                        - MIN( current_price_modifiers.price )
                      ) / ${me}price * 100 - 0.5
                    )"
                },
                {
                    average_rating => \"
                    COALESCE(
                      CASE
                        WHEN ${me}canonical_sku IS NULL THEN
                          ROUND(AVG( message.rating )*10)/10
                        ELSE
                          ROUND(AVG( message_2.rating )*10)/10
                      END,
                      0
                    ) AS average_rating"
                },
            ],
            join => [
                'current_price_modifiers',
                { _product_reviews => 'message' },
                'inventory',
                { canonical => { _product_reviews => 'message' } },
                { variants => [ 'current_price_modifiers', 'inventory', ], },
            ],
            bind => [
                [ end_date => $today ],
                [ quantity => $args->{quantity} ],
                [ { sqlt_datatype => "integer" } => $args->{users_id} ],
                [ start_date => $today ],
                [ end_date   => $today ],
                [ quantity   => $args->{quantity} ],
                [ { sqlt_datatype => "integer" } => $args->{users_id} ],
                [ start_date => $today ],
            ],
            group_by => [ @columns, 'inventory.quantity' ],
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        }
    );
}

=head2 with_average_rating

Adds C<average_rating> column which is available to order_by clauses and
whose value can be retrieved via
L<Interchange6::Schema::Result::Product/average_rating>.

This is the average rating across all public and approved product reviews or
undef if there are no reviews. Product reviews are only related to canonical
products so for variants the value returned is that of the canonical product.

=cut

sub with_average_rating {
    my $self = shift;

    my $me = $self->me;

    print STDERR "* foo *\n";
    my $self = $self->search(
        {
#            -or => [
#                -and => [
                    'message.approved' => 1,
                    'message.public'   => 1,
#                ],
#                'message.messages_id' => undef
#            ]
        },
        {
            '+select' => [
                {
#                    coalesce => [
#                        {
#                            avg => 'message_2.rating'
#                        },
#                        {
                            avg => 'message.rating',
#                        },
#                    ],
                    -as => 'average_rating'
                }
            ],
            '+as' => ['average_rating'],
            join => [
                { _product_reviews => 'message' },
#                { canonical => { _product_reviews => 'message' } },
            ],
            distinct => 1,
        }
    );
    use Data::Dumper::Concise;
    print STDERR Dumper($self->as_query);
    return $self;
}

=head2 with_inventory

=cut

sub with_inventory {
    return shift->search(
        undef,
        {
            prefetch => 'inventory'
        }
    );
}

=head2 with_price_modifiers

=cut

sub with_price_modifiers {
    return shift->search(
        undef,
        {
            prefetch => 'price_modifiers'
        }
    );
}

=head2 with_quantity_in_stock

=cut

sub with_quantity_in_stock {

    return shift->search(
        undef,
        {
            '+columns' => [ { quantity_in_stock => 'inventory.quantity' } ],
            join  => 'inventory',
        }
    );
}

=head2 with_selling_price

=cut

sub with_selling_price {
    my ( $self, $args ) = @_;

    if ( defined($args) ) {
        $self->throw_exception(
            "argument to listing must be a hash reference")
          unless ref($args) eq "HASH";
    }

    my $schema = $self->result_source->schema;

    $args->{quantity} = 1 unless defined $args->{quantity};

    my $roles_id = undef;
    my @roles_cond = ( undef );

    if ( $args->{users_id} ) {

        my $subquery =
          $schema->resultset('UserRole')
          ->search( { "role.users_id" => { '=' => \"?" } },
            { alias => 'role' } )->get_column('roles_id')->as_query;

        push @roles_cond, { -in => $subquery };
    }

    if ( $args->{roles} ) {

        $self->throw_exception(
            "Argument roles to selling price must be an array reference")
          unless ref( $args->{roles} ) eq 'ARRAY';

        my $subquery =
          $schema->resultset('Role')
          ->search( { "role.name" => { -in => \@{$args->{roles}} } },
            { alias => 'role' } )->get_column('roles_id')->as_query;

        push @roles_cond, { -in => $subquery };
    }

    my $today = $schema->format_datetime(DateTime->today);

    return $self->search(
        undef,
        {
            '+select' => [
                {
                    min => 'current_price_modifiers.price',
                    -as => 'selling_price'
                }
            ],
            '+as' => ['selling_price'],
            join  => 'current_price_modifiers',
            distinct => 1,
            bind => [
                [ end_date => $today ],
                [ quantity => $args->{quantity} ],
                [ { sqlt_datatype => "integer" } => $args->{users_id} ],
                [ start_date => $today ],
            ],
        }
    );
}

1;
