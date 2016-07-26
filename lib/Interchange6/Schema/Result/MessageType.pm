use utf8;

package Interchange6::Schema::Result::MessageType;

=head1 NAME

Interchange6::Schema::Result::MessageType

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

Lookup table for L<Interchange6::Schema::Result::Message/type>

=head1 ACCESSORS

=head2 message_types_id

Primary key.

=cut

primary_column message_types_id => {
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

The id of the website/shop this attribute value belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 messages

Type: has_many

Related object: L<Interchange6::Schema::Result::Message>

=cut

has_many
  messages => 'Interchange6::Schema::Result::Message',
  'message_types_id';

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
