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

=head2 uri

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 author

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

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

=head2 approved_by

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

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
    "uri",
    { data_type => "varchar", is_nullable => 1, size => 255 },
    "content",
    { data_type => "text", is_nullable => 0 },
    "author",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "recommend",
    { data_type => "boolean", is_nullable => 1 },
    "public",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "approved",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "approved_by",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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

=head2 author

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
    author => 'Interchange6::Schema::Result::User',
    { 'foreign.users_id' => 'self.author' },
    { join_type => 'left' }
);

=head2 approved_by

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
    approved_by => 'Interchange6::Schema::Result::User',
    { 'foreign.users_id' => 'self.approved_by' },
    { join_type => 'left' }
);

1;
