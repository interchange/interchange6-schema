use utf8;
package Interchange6::Schema::Result::Cart;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Cart

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<carts>

=cut

__PACKAGE__->table("carts");

=head1 ACCESSORS

=head2 carts_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'carts_carts_id_seq'

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 users_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 sessions_id

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=head2 approved

  data_type: 'boolean'
  is_nullable: 1

=head2 status

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "carts_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "carts_carts_id_seq",
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "sessions_id",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
  "approved",
  { data_type => "boolean", is_nullable => 1 },
  "status",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</carts_id>

=back

=cut

__PACKAGE__->set_primary_key("carts_id");

=head1 RELATIONS

=head2 CartProduct

Type: has_many

Related object: L<Interchange6::Schema::Result::CartProduct>

=cut

__PACKAGE__->has_many(
  "CartProduct",
  "Interchange6::Schema::Result::CartProduct",
  { "foreign.carts_id" => "self.carts_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Session

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Session>

=cut

__PACKAGE__->belongs_to(
  "Session",
  "Interchange6::Schema::Result::Session",
  { sessions_id => "sessions_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 User

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "User",
  "Interchange6::Schema::Result::User",
  { users_id => "users_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4uLIorY8RfRLKUgXO9L4oQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
