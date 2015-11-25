use utf8;

package Interchange6::Schema::Result::MessageType;

=head1 NAME

Interchange6::Schema::Result::MessageType

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

Lookup table for L<Interchange6::Schema::Result::Message/type>

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1
};

=head2 name

Name of the message type. Must be unique.

=cut

unique_column name => {
    data_type         => "varchar",
    size              => 255
};

=head2 active

Is the message type active. Default is yes.

=cut

column active => {
    data_type         => "boolean",
    default_value     => 1
};

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

Is nullable. A null value indicates that the message type is available to all
websites.

=cut

column website_id => { data_type => "integer", is_nullable => 1 };

=head1 RELATIONS

=head2 messages

Type: has_many

Related object: L<Interchange6::Schema::Result::Message>

=cut

has_many
  messages => 'Interchange6::Schema::Result::Message',
  'message_type_id';

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id",
  { join_type => 'left' };

1;
