use utf8;
package Interchange6::Schema::Result::MediaDisplay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::MediaDisplay

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<media_displays>

=cut

__PACKAGE__->table("media_displays");

=head1 ACCESSORS

=head2 media_displays_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'media_displays_media_displays_id_seq'

=head2 media_types_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 size

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "media_displays_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_displays_media_displays_id_seq",
  },
  "media_types_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "path",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "size",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_displays_id>

=back

=cut

__PACKAGE__->set_primary_key("media_displays_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<media_types_id_type_unique>

=over 4

=item * L</media_types_id>

=item * L</type>

=back

=cut

__PACKAGE__->add_unique_constraint("media_types_id_type_unique", ["media_types_id", "type"]);

=head1 RELATIONS

=head2 media_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

__PACKAGE__->belongs_to(
  "media_type",
  "Interchange6::Schema::Result::MediaType",
  { media_types_id => "media_types_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-04-03 17:07:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0lYcSNLw2pKFxM1lq3zlSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
