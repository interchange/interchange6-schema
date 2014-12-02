package Interchange6::Schema::Result::ProductWithSellingPrice;

=head1 NAME

Interchange6::Schema::Result::ProductWithSellingPrice

=cut

use warnings;
use strict;

use base qw/Interchange6::Schema::Result::Product/;
use Interchange6::Schema::Result::Product;
use Interchange6::Schema::Candy -components => [qw(InflateColumn::DateTime)];
 
=head1 DESCRIPTION

This is a virtual view which inherits from L<Interchange6::Schema::Result::Product> and adds two columns. See the parent object for more details.

This view requires the following bind values in this order:

=over

=item * start_date (L<Interchange6::Schema::Result::PriceModifier/start_date>)

=item * quantity (L<Interchange6::Schema::Result::PriceModifier/quantity>)

=item * users_id (L<Interchange6::Schema::Result::User/users_id>)

=item * end_date (L<Interchange6::Schema::Result::PriceModifier/end_date>)

=back

These are given in the args to the query, e.g.:

  my $dtf = $schema->storage->datetime_parser;
  my $today = $dtf->format_datetime(DateTime->today);

  my $rset = $schema->resultset('ProductWithSellingPrice')->search(
      {
          active => 1
      },
      {
          bind => [
              [ { sqlt_datatype => "date" }    => $today ],
              [ { sqlt_datatype => "integer" } => $args->{quantity} ],
              [ { sqlt_datatype => "integer" } => $args->{users_id} ],
              [ { sqlt_datatype => "date" }    => $today ],
          ]
      }
  );

=cut

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
 
__PACKAGE__->table('product_view');
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(q(

  SELECT products.*,
   COALESCE( MIN( price_modifiers.price ), products.price ) AS selling_price,
   ROUND (( products.price - MIN( price_modifiers.price ) )
     / products.price * 100 - 0.5 ) AS discount_percent
  FROM products
  LEFT JOIN price_modifiers
    ON (
      ( price_modifiers.end_date IS NULL OR price_modifiers.end_date >= ? )
      AND price_modifiers.quantity <= ?
      AND (
        price_modifiers.roles_id IS NULL
        OR price_modifiers.roles_id IN
          ( SELECT roles_id FROM user_roles WHERE ( user_roles.users_id = ? ) )
      )
      AND price_modifiers.sku = products.sku
      AND (
        price_modifiers.start_date IS NULL OR price_modifiers.start_date <= ? )
    )
  GROUP BY

) . join( ", ", map { "products." . $_ }
          Interchange6::Schema::Result::Product->columns )
);

=head1 ACCESSORS

In addition to L<Interchange6::Schema::Result::Product/ACCESSORS> this view
adds the following columns:

=head2 selling_price

This is derived from L<Interchange6::Schema::Result::PriceModifier/price>

Returns undef if no modified price is available.

=cut

column selling_price => {
    data_type => "numeric",
    size      => [ 10, 2 ],
};

=head2 discount_percent

The integer percentage discount based on the difference between
L<Interchange6::Schema::Result::Product/price> and L</selling_price>.

Returns undef when selling_price is undef.

=cut

column discount_percent => { data_type => "integer" };

1;
