use utf8;

package Interchange6::Schema::Result::Media;

=head1 NAME

Interchange6::Schema::Result::Media

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 file

The image/video file.

Defaults to empty string.

=cut

unique_column file => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 uri

The image/video uri.

Defaults to empty string.

=cut

column uri => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 mime_type

Mime type.

Defaults to empty string.

=cut

column mime_type => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 label

Label.

Defaults to empty string.

=cut

column label => {
    data_type     => "varchar",
    default_value => "",
    size          => 255
};

=head2 author_user_id

FK on L<Interchange6::Schema::Result::User/id>.

=cut

column author_user_id => { data_type => "integer", is_nullable => 1 };

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created =>
  { data_type => "datetime", set_on_create => 1 };

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head2 active

Boolean whether media is active. Defaults to true (1).

=cut

column active => { data_type => "boolean", default_value => 1 };

=head2 media_type_id

FK on L<Interchange6::Schema::Result::MediaType/id>.

=cut

column media_type_id => { data_type => "integer" };

=head2 website_id

The id of the website/shop this media belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINTS

=head2 website_id media_type_id

=cut

unique_constraint [ "website_id", "media_type_id" ];

=head1 RELATIONS

=head2 author

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  author => "Interchange6::Schema::Result::User",
  "author_user_id",
  { join_type => "left" };

=head2 media_type

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

belongs_to
  media_type => "Interchange6::Schema::Result::MediaType",
  "media_type_id",
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 media_products

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaProduct>

=cut

has_many
  media_products => "Interchange6::Schema::Result::MediaProduct",
  "media_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

=head2 products

Type: many_to_many with product.

=cut

many_to_many products => "media_products", "product";

=head2 displays

Type: many_to_many with media_displays

=cut

many_to_many displays => "media_type", "media_displays";

=head1 METHODS

=head2 type

Return the media type looking into MediaDisplay and MediaType.

=cut

sub type {
    my $self = shift;

    # here we return just the first result. UNCLEAR if more are
    # needed, but has many... Either we
    return $self->media_type->type;
}

=head2 display_uris

Return a hashref with the media display type and the final uri.

=cut

sub display_uris {
    my $self = shift;
    my %uris;
    foreach my $d ( $self->displays ) {
        my $path = $d->path;
        $path =~ s!/$!!;    # remove eventual trailing slash
        $uris{ $d->type } = $path . '/' . $self->uri;
    }
    return \%uris;
}

=head2 display_uri('display_type')

Return the uri for the display type (or undef if not found).

=cut

sub display_uri {
    my ( $self, $type ) = @_;
    return $self->display_uris->{$type};
}

1;
