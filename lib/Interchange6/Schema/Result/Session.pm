use utf8;
package Interchange6::Schema::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Session

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<sessions>

=cut

__PACKAGE__->table("sessions");

=head1 ACCESSORS

=head2 sessions_id

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 session_data

  data_type: 'text'
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sessions_id",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "session_data",
  { data_type => "text", is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sessions_id>

=back

=cut

__PACKAGE__->set_primary_key("sessions_id");

=head1 RELATIONS

=head2 Cart

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

__PACKAGE__->has_many(
  "Cart",
  "Interchange6::Schema::Result::Cart",
  { "foreign.sessions_id" => "self.sessions_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 PaymentOrder

Type: has_many

Related object: L<Interchange6::Schema::Result::PaymentOrder>

=cut

__PACKAGE__->has_many(
  "PaymentOrder",
  "Interchange6::Schema::Result::PaymentOrder",
  { "foreign.sessions_id" => "self.sessions_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head1 RESULTSET

=head2 L<Interchange6::Schema::ResultSet::Session>

=cut

__PACKAGE__->resultset_class('Interchange6::Schema::ResultSet::Session');

# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ddl3uVqCDeTK+ubd4RP9vw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
