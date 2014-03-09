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

=head2 media_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 media_types_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "media_displays_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "media_displays_media_displays_id_seq",
  },
  "media_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sku",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 0, size => 64 },
  "media_types_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</media_displays_id>

=back

=cut

__PACKAGE__->set_primary_key("media_displays_id");

=head1 RELATIONS

=head2 Media

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Media>

=cut

__PACKAGE__->belongs_to(
  "Media",
  "Interchange6::Schema::Result::Media",
  { media_id => "media_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 MediaType

Type: belongs_to

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

__PACKAGE__->belongs_to(
  "MediaType",
  "Interchange6::Schema::Result::MediaType",
  { media_types_id => "media_types_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "Product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Jm7mhhbQxruLODUabFusXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
