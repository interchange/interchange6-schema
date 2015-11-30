use utf8;

package Interchange6::Schema::Result::Message;

=head1 NAME

Interchange6::Schema::Result::Message

=cut

use Interchange6::Schema::Candy -components =>
  [qw(Tree::AdjacencyList InflateColumn::DateTime TimeStamp)];

use Moo;
use namespace::clean;

=head1 DESCRIPTION

Shared messages table for blog, order comments, reviews, bb, etc.

=head1 ACCESSORS

=head2 type

A short-cut accessor which takes a message type name (L<Interchange6::Schema::Result::MessageType/name>) as argument and sets L</message_type_id> to the appropriate value. This is write-only.

=cut

#__PACKAGE__->mk_group_accessors( 'simple' => 'type' );
has type => ( is => 'ro', );

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 title

The title of the message.

=cut

column title => {
    data_type         => "varchar",
    default_value     => "",
    size              => 255
};

=head2 message_type_id

Foreign key constraint on L<Interchange6::Schema::Result::MessageType/id>
via L</message_type> relationship.

=cut

column message_type_id => {
    data_type         => "integer",
};

=head2 uri

The uri of the message data.

=cut

column uri => {
    data_type         => "varchar",
    is_nullable       => 1,
    size              => 255
};

=head2 format

The format of the text held in L</content>, e.g. plain, html or markdown.
Defaults to 'plain'.

=cut

column format => {
    data_type => "varchar",
    size      => 32,
    default_value => "plain",
};

=head2 content

Content for the message.

=cut

column content => {
    data_type         => "text"
};

=head2 summary

Summary/teaser for L</content>.

Defaults to empty string.

=cut

column summary => {
    data_type     => "varchar",
    size          => 1024,
    default_value => '',
};

=head2 author_user_id

Foreign key constraint on L<Interchange6::Schema::Result::User/id>
via L</author> relationship. Is nullable.

=cut

column author_user_id => {
    data_type         => "integer",
    is_nullable       => 1
};

=head2 rating

Numeric rating of the message by a user.

=cut

column rating => {
    data_type         => "numeric",
    default_value     => 0,
    size              => [ 4, 2 ],
};

=head2 recommend

Do you recommend the message? Default is no. Is nullable.

=cut

column recommend => {
    data_type         => "boolean",
    is_nullable       => 1
};

=head2 public

Is this public viewable?  Default is no.

=cut

column public => {
    data_type         => "boolean",
    default_value     => 0,
};

=head2 approved

Has this been approved by someone with proper rights?

=cut

column approved => {
    data_type         => "boolean",
    default_value     => 0,
};

=head2 approved_by_user_id

Foreign key constraint on L<Interchange6::Schema::Result::User/id>
via L</approved_by> relationship. Is nullable

=cut

column approved_by_user_id => {
    data_type         => "integer",
    is_nullable       => 1
};

=head2 parent_id

For use by L<DBIx::Class::Tree::AdjacencyList> this defines the L</id>
of the parent of this message (if any).

=cut

column parent_id => { data_type => "integer", is_nullable => 1 };

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type         => "datetime",
    set_on_create     => 1,
};

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type         => "datetime",
    set_on_create     => 1,
    set_on_update     => 1,
};

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 uri website_id

=cut

unique_constraint [ 'uri', 'website_id' ];

=head1 RELATIONS

=head2 author

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  author => 'Interchange6::Schema::Result::User',
  'author_user_id',
  { join_type => 'left' };

=head2 approved_by

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  approved_by => 'Interchange6::Schema::Result::User',
  'approved_by_user_id',
  { join_type => 'left' };

=head2 message_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MessageType>

=cut

belongs_to
  message_type => 'Interchange6::Schema::Result::MessageType',
  'message_type_id';

=head2 order_comment

Type: might_have

Related object: L<Interchange6::Schema::Result::OrderComment>

=cut

might_have
  order_comment => 'Interchange6::Schema::Result::OrderComment',
  'message_id';

=head2 orders

Type: many_to_many

Accessor to related Product results.

=cut

many_to_many orders => "order_comment", "order";

=head2 product_review

Type: might_have

Related object: L<Interchange6::Schema::Result::ProductReview>

=cut

might_have
  product_review => 'Interchange6::Schema::Result::ProductReview',
  'message_id',
  { join_type => 'inner' };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

=head2 products

Type: many_to_many

Accessor to related Product results.

=cut

many_to_many products => "product_review", "product";

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

=head1 METHODS

=head2 FOREIGNBUILDARGS

Overload new to multi-create L</message_type> if L</type> is supplied.

=cut

sub FOREIGNBUILDARGS {
    my ( $self, $attrs ) = @_;

    delete $attrs->{type};

    return $attrs;
}

=head2 insert

=cut

sub insert {
    my $self = shift;
    if ( $self->type ) {
        $self->throw_exception(
            "Message->insert cannot take both type and message_types_id as args"
        ) if $self->message_type_id;

        my $message_type_id =
          $self->result_source->schema->restricted_by_current_website
          ->resultset('MessageType')->search(
            {
                name => $self->type,
            }
          );
        $self->message_type_id($message_type_id);
    }
    $self->next::method();
}

1;
