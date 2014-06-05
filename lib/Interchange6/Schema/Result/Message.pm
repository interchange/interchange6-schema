use utf8;

package Interchange6::Schema::Result::Message;

=head1 NAME

Interchange6::Schema::Result::Message

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<messages>

=cut

__PACKAGE__->table("messages");

=head1 DESCRIPTION

Shared messages table for blog, order comments, reviews, bb, etc.

=head1 ACCESSORS

=head2 messages_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 slug

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 users_id

  is_foreign_key: 1
  is_nullable: 0

=head2 rating

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [4,2]

=head2 recommend

  data_type: 'boolean'
  is_nullable: 1

=head2 public

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 approved

  data_type: 'boolean'
  default_value: false
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
    "messages_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "title",
    {
        data_type     => "varchar",
        default_value => "",
        is_nullable   => 0,
        size          => 255
    },
    "slug",
    { data_type => "varchar", is_nullable => 1, size => 255 },
    "content",
    { data_type => "text", is_nullable => 0 },
    "users_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    "rating",
    {
        data_type     => "numeric",
        default_value => 0.0,
        is_nullable   => 0,
        size          => [ 4, 2 ]
    },
    "recommend",
    { data_type => "boolean", is_nullable => 1 },
    "public",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "approved",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "created",
    { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
    "last_modified",
    {
        data_type     => "datetime",
        set_on_create => 1,
        set_on_update => 1,
        is_nullable   => 0
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</messages_id>

=back

=cut

__PACKAGE__->set_primary_key("messages_id");

=head1 RELATIONS

=head2 User

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
    "User",
    "Interchange6::Schema::Result::User",
    { users_id      => "users_id" },
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Review

Type: has_many

Related object: L<Interchange6::Schema::Result::Review>

Review is a link table for Product reviews. Name kept for backwards compatibility.

=cut

__PACKAGE__->has_many(
    "Review",
    "Interchange6::Schema::Result::Review",
    "messages_id"
);

=head2 products

Type: many_to_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->many_to_many( "products", "Review", "sku" );

1;
