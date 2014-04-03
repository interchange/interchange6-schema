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

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 media_types_id

  data_type: 'integer'
  is_foreign_key: 1
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
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "media_types_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_id>

=back

=cut

__PACKAGE__->set_primary_key("media_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<media_id_media_types_id_unique>

=over 4

=item * L</media_id>

=item * L</media_types_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "media_id_media_types_id_unique",
  ["media_id", "media_types_id"],
);

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

=head2 media_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

__PACKAGE__->belongs_to(
  "media_type",
  "Interchange6::Schema::Result::MediaType",
  { media_types_id => "media_types_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
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

=head2 products

Type: many_to_many with Product.

=cut

__PACKAGE__->many_to_many("products", "MediaProduct", "Product");

=head2 type

Return the media type looking into MediaDisplay and MediaType.

=cut

sub type {
    my $self = shift;
    # here we return just the first result. UNCLEAR if more are
    # needed, but has many... Either we 
    return $self->media_type->type;
}


1;
