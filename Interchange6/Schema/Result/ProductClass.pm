use utf8;
package Interchange6::Schema::Result::ProductClass;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::ProductClass

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<product_classes>

=cut

__PACKAGE__->table("product_classes");

=head1 ACCESSORS

=head2 sku_class

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 manufacturer

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 128

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 short_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 uri

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sku_class",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "manufacturer",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 128 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "short_description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "uri",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 500 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sku_class>

=back

=cut

__PACKAGE__->set_primary_key("sku_class");

=head1 RELATIONS

=head2 products

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->has_many(
  "products",
  "Interchange6::Schema::Result::Product",
  { "foreign.sku_class" => "self.sku_class" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JDfcFsy25T+PweNiqYb7gw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
