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

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column message_types_id =>
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 };

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255
  unique constraint

=cut

unique_column name => { data_type => "varchar", is_nullable => 0, size => 255 };

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column active =>
  { data_type => "boolean", is_nullable => 0, default_value => 1 };

=head1 RELATIONS

=head2 messages

Type: has_many

Related object: L<Interchange6::Schema::Result::Message>

=cut

has_many
  messages => 'Interchange6::Schema::Result::Message',
  'message_types_id';

1;
