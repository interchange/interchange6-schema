use utf8;
package Interchange6::Schema::Result::Navigation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Navigation

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<navigation>

=cut

__PACKAGE__->load_components(qw(Tree::AdjacencyList));

__PACKAGE__->table("navigation");

=head1 ACCESSORS

=head2 navigation_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'navigation_navigation_id_seq'

=head2 uri

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 scope

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 template

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 alias

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1

=head2 priority

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 product_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 entered

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "navigation_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "navigation_navigation_id_seq",
  },
  "uri",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "scope",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "template",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "alias",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "parent_id",
  { data_type => "integer", is_nullable => 1 },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "product_count",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "entered",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</navigation_id>

=back

=cut

__PACKAGE__->set_primary_key("navigation_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<navigation_uri_key>

=over 4

=item * L</uri>

=back

=cut

__PACKAGE__->add_unique_constraint("navigation_uri_key", ["uri"]);

# define parent column

__PACKAGE__->parent_column('parent_id');

=head1 RELATIONS

=head2 navigation_products

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationProduct>

=cut

__PACKAGE__->has_many(
  "navigation_products",
  "Interchange6::Schema::Result::NavigationProduct",
  { "foreign.navigation_id" => "self.navigation_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xBMAUxqS73SFXRskBbIMwQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
