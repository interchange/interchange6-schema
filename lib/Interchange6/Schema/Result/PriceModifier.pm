use utf8;

package Interchange6::Schema::Result::PriceModifier;

=head1 NAME

Interchange6::Schema::Result::PriceModifier

=head1 DESCRIPTION

Use cases:

=over

=item * group pricing based on L<roles|Interchange6::Schema::Result::Role>

=item * tier pricing (volume discounts)

=item * promotion/action pricing using L</start_date> and L</end_date>

=back

=cut

use Interchange6::Schema::Candy
  -components => [qw(InflateColumn::DateTime)];

=head1 ACCESSORS

=head2 price_modifiers_id

Primary key.

=cut

primary_column price_modifiers_id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 sku

FK on L<Interchange6::Schema::Result::Product/sku>.

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, size => 64 };

=head2 quantity

Minimum quantity at which price modifier applies (tier pricing).

Defaults to 0.

=cut

column quantity =>
  { data_type => "integer", default_value => 0 };

=head2 roles_id

FK on L<Interchange6::Schema::Result::Role/roles_id>.

Can be used for role-based pricing.

Is nullable.

=cut

column roles_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 };

=head2 price

Price.

=cut

column price => {
    data_type     => "numeric",
    size          => [ 10, 2 ],
};

=head2 percent

Percent rate of discount. This is an alternative to setting L</price> directly.

B<NOTE:> It is not possible to create a new C<PriceModifier> record with both
L</price> and </percent> set in new/insert.

When L</percent> is set or updated the value of L</price> will be updated
accordingly based on the related L<Interchange6::Schema::Result::Product/price>.

Is nullable.

=cut

column 

=head2 start_date

The first date from which this modified price is valid.
Automatic inflation/deflation to/from L<DateTime>.

Is nullable.

=cut

column start_date => {
    data_type     => "date",
    is_nullable   => 1,
};

=head2 end_date

The last date on which this modified price is valid.
Automatic inflation/deflation to/from L<DateTime>.

Is nullable.

=cut

column end_date => {
    data_type     => "date",
    is_nullable   => 1,
};

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Role>

=cut

belongs_to
  role => "Interchange6::Schema::Result::Role",
  "roles_id", { join_type => 'left', is_deferrable => 1 };

=head2 product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  product => "Interchange6::Schema::Result::Product",
  "sku", { is_deferrable => 1 };

1;
