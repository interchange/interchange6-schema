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

Primary key.

=cut

primary_column navigation_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    sequence          => "navigation_navigation_id_seq",
};

=head2 uri

Unique navigation uri. e.g. "fly-fishing-gear/fly-rods". * Required field

=cut

unique_column uri => {
    data_type         => "varchar",
    size              => 255
};

=head2 type

Navigation type. e.g. "menu". Default (empty string).

=cut

column type => {
    data_type         => "varchar",
    default_value     => "",
    size              => 32
};

=head2 scope

Internal sorting field. Default (empty string).

=cut

column scope => {
    data_type         => "varchar",
    default_value     => "",
    size              => 32
};

=head2 name

Navigation name. Default (empty string).

=cut

column name => {
    data_type         => "varchar",
    default_value     => "",
    size              => 255
};

=head2 description

Descriptor field for navigation route.  This field also be used to display meta
description in html head. Default (empty string).

=cut

column description => {
    data_type         => "varchar",
    default_value     => "",
    size              => 1024
};

=head2 alias_navigation_id

Foreign key constraint on L<Interchange6::Schema::Result::Navigation/navigation_id>
via L</alias_navigation> relationship.  Navigation route alias. Is nullable.
NOTE:When defined the route will ONLY use the NavigationProduct records of the aliased route.

=cut

column alias_navigation_id => {
    data_type         => "integer",
    is_foreign_key    => 1,
    is_nullable       => 1
};

=head2 parent_id

The navigation_id of a related parent. Is nullable.

=cut

column parent_id => {
    data_type         => "integer",
    is_nullable       => 1
};

=head2 priority

Display order priority.

=cut

column priority => {
    data_type         => "integer",
    default_value     => 0
};

=head2 product_count

Cache for the sum of all active items for a route.
NOTE: future proposed enhancement currently a manual process.

=cut

column product_count => {
    data_type         => "integer",
    default_value     => 0
};

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type         => "datetime",
    set_on_create     => 1
};

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type         => "datetime",
    set_on_create     => 1,
    set_on_update     => 1
};

=head2 active

Is this navigation route active? Default is yes.

=cut

column active => {
    data_type         => "boolean",
    default_value     => 1
};

=head1 METHODS

Attribute methods are provided by the L<Interchange6::Schema::Base::Attribute> class.

=head2 siblings_with_self

Similar to the inherited L<siblings|DBIx::Class::Tree::AdjacencyList/siblings> method but also returns the object itself in the result set/list.

=cut

sub siblings_with_self {
    my $self = shift;
    my $rs = $self->result_source->resultset->search(
        {
            parent_id => $self->parent_id,
        }
    );
    return $rs->all() if (wantarray());
    return $rs;
}

=head1 INHERITED METHODS

=head2 DBIx::Class::Tree::AdjacencyList

=over 4

=item *

L<parent|DBIx::Class::Tree::AdjacencyList/parent>

=item *

L<ancestors|DBIx::Class::Tree::AdjacencyList/ancestors>

=item *

L<has_descendant|DBIx::Class::Tree::AdjacencyList/has_descendant>

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

=head2 alias_navigation

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

belongs_to
  alias_navigation => "Interchange6::Schema::Result::Navigation",
  { 'foreign.navigation_id' => 'self.alias_navigation_id' };

=head2 navigation_products

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationProduct>

=cut

has_many
  navigation_products => "Interchange6::Schema::Result::NavigationProduct",
  "navigation_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 products

Type: many_to_many

Accessor to related product results ordered by priority and name.

=cut

many_to_many
  products => "navigation_products",
  "product", { order_by => [ 'product.priority', 'product.name' ] };

=head2 navigation_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

has_many
  navigation_attributes => "Interchange6::Schema::Result::NavigationAttribute",
  "navigation_id",
  { cascade_copy => 0, cascade_delete => 0 };

1;
