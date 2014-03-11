use utf8;
package Interchange6::Schema::Result::CartProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::CartProduct

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<cart_products>

=cut

__PACKAGE__->table("cart_products");

=head1 ACCESSORS

=head2 carts_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 cart_position

  data_type: 'integer'
  is_nullable: 0

=head2 quantity

  data_type: 'integer'
  default_value: 1
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "carts_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
  "cart_position",
  { data_type => "integer", is_nullable => 0 },
  "quantity",
  { data_type => "integer", default_value => 1, is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sku>

=item * L</carts_id>

=back

=cut

__PACKAGE__->set_primary_key(qw(carts_id sku));

=head1 RELATIONS

=head2 Cart

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Cart>

=cut

__PACKAGE__->belongs_to(
  "Cart",
  "Interchange6::Schema::Result::Cart",
  { carts_id => "carts_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "Product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XHZxLKJ/eQQ4CV3eu3PYUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
