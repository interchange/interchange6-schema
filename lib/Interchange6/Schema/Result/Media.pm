use utf8;
package Interchange6::Schema::Result::Media;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Media

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<media>

=cut

__PACKAGE__->table("media");

=head1 ACCESSORS

=head2 media_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'media_media_id_seq'

=head2 file

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 uri

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 mime_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 label

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 author_users_id

  data_type: 'integer'
  is_foreign_key: 0
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

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "media_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_media_id_seq",
  },
  "file",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "uri",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "mime_type",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "label",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "author_users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_id>

=back

=cut

__PACKAGE__->set_primary_key("media_id");

=head1 RELATIONS

=head2 Author

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "Author",
  "Interchange6::Schema::Result::User",
  { "foreign.users_id" => "self.author_users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 MediaDisplay

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaDisplay>

=cut

__PACKAGE__->has_many(
  "MediaDisplay",
  "Interchange6::Schema::Result::MediaDisplay",
  { "foreign.media_id" => "self.media_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 MediaProduct

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaProduct>

=cut

__PACKAGE__->has_many(
  "MediaProduct",
  "Interchange6::Schema::Result::MediaProduct",
  { "foreign.media_id" => "self.media_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pd9KCqSmJlsJH4gG4b3hJg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
