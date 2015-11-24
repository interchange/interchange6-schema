use utf8;

package Interchange6::Schema::Result::MediaType;

=head1 NAME

Interchange6::Schema::Result::MediaType

=head1 SYNOPSIS

This table holds the available media types to use in
L<Interchange6::Schema::Result::MediaDisplay>.

This table should hold only the "parent" type of a media, like
C<image> or C<video>.

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 type

Type of media, e.g.: image, video.

=cut

column type => { data_type => "varchar", size => 32 };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 type website_id

=cut

unique_constraint [ 'type', 'website_id' ];

=head1 RELATIONS

=head2 media_displays

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaDisplay>

=cut

has_many
  media_displays => "Interchange6::Schema::Result::MediaDisplay",
  "media_type_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 media

Type: has_many

Related object: L<Interchange6::Schema::Result::Media>

=cut

has_many
  media => "Interchange6::Schema::Result::Media",
  "media_type_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
