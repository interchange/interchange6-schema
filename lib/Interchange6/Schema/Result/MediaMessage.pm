use utf8;

package Interchange6::Schema::Result::MediaMessage;

=head1 NAME

Interchange6::Schema::Result::MediaMessage

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

Linker table for connecting the L<Interchange6::Schema::Result::Media> class
to the <Interchange6::Schema::Result::Message> class records.

=head1 ACCESSORS

=head2 media_id

Foreign key constraint on L<Interchange6::Schema::Result::Media/media_id>
via L</media_id> relationship.

=cut

column media_id => {
    data_type         => "integer",
    is_foreign_key    => 1
};

=head2 messages_id

Foreign key constraint on L<Interchange6::Schema::Result::Message/messages_id>
via L</message> relationship.

=cut

column messages_id => {
    data_type         => "integer",
    is_foreign_key    => 1
};

=head1 PRIMARY KEY

=over 4

=item * L</media_id>

=item * L</messages_id>

=back

=cut

primary_key "media_id", "messages_id";

=head1 RELATIONS

=head2 media

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Media>

=cut

belongs_to
  media => "Interchange6::Schema::Result::Media",
  "media_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 message

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Message>

=cut

belongs_to
  message => "Interchange6::Schema::Result::Message",
  "messages_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

1;
