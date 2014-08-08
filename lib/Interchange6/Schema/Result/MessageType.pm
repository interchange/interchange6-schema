use utf8;

package Interchange6::Schema::Result::MessageType;

=head1 NAME

Interchange6::Schema::Result::MessageType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<message_types>

=cut

__PACKAGE__->table("message_types");

=head1 DESCRIPTION

Lookup table for L<Interchange6::Schema::Result::Message/type>

=head1 ACCESSORS

=head2 message_types_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    "message_types_id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "name",
    { data_type => "varchar", is_nullable => 0, size => 255 },
    "active",
    { data_type => "boolean", is_nullable => 0, default_value => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</message_types_id>

=back

=cut

__PACKAGE__->set_primary_key("message_types_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<message_types_name_unique>

L</name> should be unique

=cut

__PACKAGE__->add_unique_constraint( "message_types_name_unique", ["name"] );

=head1 RELATIONS

=head2 messages

Type: has_many

Related object: L<Interchange6::Schema::Result::Message>

=cut

__PACKAGE__->has_many(
    messages => 'Interchange6::Schema::Result::Message',
    'message_types_id',
);

1;
