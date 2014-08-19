use utf8;

package Interchange6::Schema::Result::Navigation;

=head1 NAME

Interchange6::Schema::Result::Navigation

=cut

use base 'Interchange6::Schema::Base::Attribute';

use Interchange6::Schema::Candy -components =>
  [qw(Tree::AdjacencyList InflateColumn::DateTime TimeStamp)];

=head1 DESCRIPTION

Navigation is where all navigation, category and static page details are stored.  In addition
information such as page title can be linked to these records as attributes.

=over 4

=item B<Attribute>

Common attribute names for a Navigation records include these examples.

meta_title
meta_description
meta_keywords
head_js
head_css

=back

=cut

=head1 SYNOPSIS

NOTE: with items such as head_css which may contain more than one record you must set the priority of the record.
This ensures each record has a unique value and also allows for proper ordering.

    $nav->add_attribute({name => 'head_css', priority => '1'}, '/css/main.css');
    $nav->add_attribute({name => 'head_css', priority => '2'}, '/css/fancymenu.css');

=head1 ACCESSORS

=head2 navigation_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'navigation_navigation_id_seq'
  primary key

=cut

primary_column navigation_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "navigation_navigation_id_seq",
};

=head2 uri

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255
  unique constraint

=cut

unique_column uri => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column type =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 scope

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column scope =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

column name => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 255
};

=head2 description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 1024

=cut

column description => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 1024
};

=head2 alias

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column alias =>
  { data_type => "integer", default_value => 0, is_nullable => 0 };

=head2 parent_id

  data_type: 'integer'
  is_nullable: 1

=cut

column parent_id => { data_type => "integer", is_nullable => 1 };

=head2 priority

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column priority =>
  { data_type => "integer", default_value => 0, is_nullable => 0 };

=head2 product_count

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column product_count =>
  { data_type => "integer", default_value => 0, is_nullable => 0 };

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column created =>
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 };

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable   => 0
};

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column active =>
  { data_type => "boolean", default_value => 1, is_nullable => 0 };

=head1 METHODS

Attribute methods are provided by the L<Interchange6::Schema::Base::Attribute> class.

=head1 INHERITED METHODS

=head2 DBIx::Class::Tree::AdjacencyList

=over 4

=item *

L<parent|DBIx::Class::Tree::AdjacencyList/parent>

=item *

L<ancestors|DBIx::Class::Tree::AdjacencyList/ancestors>

=item *

L<as_descendant|DBIx::Class::Tree::AdjacencyList/as_descendant>

=item *

L<parents|DBIx::Class::Tree::AdjacencyList/parents>

=item *

L<children|DBIx::Class::Tree::AdjacencyList/children>

=item *

L<attach_child|DBIx::Class::Tree::AdjacencyList/attach_child>

=item *

L<siblings|DBIx::Class::Tree::AdjacencyList/siblings>

=item *

L<attach_sibling|DBIx::Class::Tree::AdjacencyList/attach_sibling>

=item *

L<is_leaf|DBIx::Class::Tree::AdjacencyList/is_leaf>

=item *

L<is_root|DBIx::Class::Tree::AdjacencyList/is_root>

=item *

L<is_branch|DBIx::Class::Tree::AdjacencyList/is_branch>

=back

=cut

# define parent column

__PACKAGE__->parent_column('parent_id');

=head1 RELATIONS

=head2 navigation_products

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationProduct>

=cut

has_many
  navigation_products => "Interchange6::Schema::Result::NavigationProduct",
  "navigation_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 navigation_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

has_many
  navigation_attributes => "Interchange6::Schema::Result::NavigationAttribute",
  "navigation_id",
  { cascade_copy => 0, cascade_delete => 0 };

1;
