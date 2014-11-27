use utf8;

package Interchange6::Schema::Result::PriceModifier;

=head1 NAME

Interchange6::Schema::Result::PriceModifier

=head1 DESCRIPTION

Use cases:

=over

=item * group pricing based on L<roles|Interchange6::Schema::Result::Role>

=item * tier pricing (volume discounts)

=item * promotion/action pricing using L<start_date> and L<end_date>

=back

=cut

use Interchange6::Schema::Candy
  -components => [qw(InflateColumn::DateTime)];

=head1 ACCESSORS

=head2 price_modifiers_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column price_modifiers_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
};

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=cut

column sku =>
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 };

=head2 quantity

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column quantity =>
  { data_type => "integer", default_value => 0, is_nullable => 0 };

=head2 roles_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

column roles_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 };

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column price => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ],
};

=head2 start_date

  data_type: 'date'
  is_nullable: 1

=cut

column start_date => {
    data_type     => "date",
    is_nullable   => 1,
};

=head2 end_date

  data_type: 'date'
  is_nullable: 1

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
