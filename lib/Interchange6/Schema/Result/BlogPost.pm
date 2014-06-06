use utf8;

package Interchange6::Schema::Result::BlogPost;

=head1 NAME

Interchange6::Schema::Result::BlogPost

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<blog_posts>

=cut

__PACKAGE__->table("blog_posts");

=head1 DESCRIPTION

Blog Posts. Uses L<Interchange6::Schema::Result::Message> for storage of most attributes.

=cut

=head1 ACCESSORS

=head2 blog_posts_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 messages_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 uri

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
    "blog_posts_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "messages_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    "uri",
    { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</blog_posts_id>

=back

=cut

__PACKAGE__->set_primary_key( "blog_posts_id" );

=head1 UNIQUE CONSTRAINTS

=over 4

=item * L</uri>

=back

=cut

__PACKAGE__->add_unique_constraint( blog_posts_unique_uri => [ "uri" ] );

=head1 RELATIONS

=head2 Message

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Message>

=cut

__PACKAGE__->belongs_to(
    "Message", "Interchange6::Schema::Result::Message",
    "messages_id",
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
