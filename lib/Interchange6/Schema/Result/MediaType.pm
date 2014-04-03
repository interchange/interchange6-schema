use utf8;
package Interchange6::Schema::Result::MediaType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::MediaType

=head1 SYNOPSIS

This table holds the available media types to use in
L<Interchange6::Schema::Result::MediaDisplay>.

Some examples could be: C<image_detail>, C<image_cart>,
C<image_listing>, C<video>.

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<media_types>

=cut

__PACKAGE__->table("media_types");

=head1 ACCESSORS

=head2 media_types_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'media_types_media_types_id_seq'

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "media_types_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_types_media_types_id_seq",
  },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_types_id>

=back

=cut

__PACKAGE__->set_primary_key("media_types_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<media_types_type_key>

=over 4

=item * L</type>

The available type of media.

=back

=cut

__PACKAGE__->add_unique_constraint("media_types_type_key", ["type"]);

=head1 RELATIONS

=head2 MediaDisplay

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaDisplay>

=cut

__PACKAGE__->has_many(
  "MediaDisplay",
  "Interchange6::Schema::Result::MediaDisplay",
  { "foreign.media_types_id" => "self.media_types_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oEjoEPcwbdQFWJbgKxD4wQ

__PACKAGE__->many_to_many(products => MediaDisplay => 'Product');
__PACKAGE__->many_to_many(media    => MediaDisplay => 'Media');


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
