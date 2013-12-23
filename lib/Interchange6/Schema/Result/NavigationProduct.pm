use utf8;
package Interchange6::Schema::Result::NavigationProduct;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::NavigationProduct

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<navigation_products>

=cut

__PACKAGE__->table("navigation_products");

=head1 ACCESSORS

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 32

=head2 navigation_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 16

=cut

__PACKAGE__->add_columns(
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 32 },
  "navigation_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sku>

=item * L</navigation_id>

=back

=cut

__PACKAGE__->set_primary_key("sku", "navigation_id");

=head1 RELATIONS

=head2 Navigation

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

__PACKAGE__->belongs_to(
  "Navigation",
  "Interchange6::Schema::Result::Navigation",
  { navigation_id => "navigation_id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mW0RpNQhE7UdH/5TFXOHHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
