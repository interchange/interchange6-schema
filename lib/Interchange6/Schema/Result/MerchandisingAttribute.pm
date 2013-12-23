use utf8;
package Interchange6::Schema::Result::MerchandisingAttribute;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::MerchandisingAttribute

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<merchandising_attributes>

=cut

__PACKAGE__->table("merchandising_attributes");

=head1 ACCESSORS

=head2 merchandising_attributes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'merchandising_attributes_merchandising_attributes_id_seq'

=head2 merchandising_products_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 value

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "merchandising_attributes_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "merchandising_attributes_merchandising_attributes_id_seq",
  },
  "merchandising_products_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "value",
  { data_type => "text", default_value => "", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</merchandising_attributes_id>

=back

=cut

__PACKAGE__->set_primary_key("merchandising_attributes_id");

=head1 RELATIONS

=head2 MerchandisingProduct

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

__PACKAGE__->belongs_to(
  "MerchandisingProduct",
  "Interchange6::Schema::Result::MerchandisingProduct",
  { merchandising_products_id => "merchandising_products_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Vr+/PTDCtKLsatQtDXeGug


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
