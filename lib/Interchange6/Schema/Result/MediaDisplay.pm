use utf8;

package Interchange6::Schema::Result::MediaDisplay;

=head1 NAME

Interchange6::Schema::Result::MediaDisplay

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 media_displays_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'media_displays_media_displays_id_seq'
  primary key

=cut

primary_column media_displays_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_displays_media_displays_id_seq",
};

=head2 media_types_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

column media_types_id =>
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 };

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 255

Examples: C<image_cart>, C<image_detail>, C<image_thumb>, C<video_full>.

=cut

column type => { data_type => "varchar", is_nullable => 0, size => 255 };

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

column name => { data_type => "varchar", is_nullable => 1, size => 255 };

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

Each display should have his own path, and it's listed here: E.g.
/images/thumbs/ or /video/full/

It's used by the Product class to create the uri for each display.

=cut

column path => { data_type => "varchar", is_nullable => 1, size => 255 };

=head2 size

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

column size => { data_type => "varchar", is_nullable => 1, size => 255 };

=head1 UNIQUE CONSTRAINTS

=head2 C<media_types_id_type_unique>

=over 4

=item * L</media_types_id>

=item * L</type>

=back

=cut

unique_constraint media_types_id_type_unique => [ "media_types_id", "type" ];

=head1 RELATIONS

=head2 media_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

belongs_to
  media_type => "Interchange6::Schema::Result::MediaType",
  "media_types_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
