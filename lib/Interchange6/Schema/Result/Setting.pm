use utf8;
package Interchange6::Schema::Result::Setting;

=head1 NAME

Interchange6::Schema::Result::Setting

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<settings>

=cut

__PACKAGE__->table("settings");

=head1 ACCESSORS

=head2 settings_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'settings_settings_id_seq'

=head2 scope

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 site

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 value

  data_type: 'text'
  is_nullable: 0

=head2 category

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

__PACKAGE__->add_columns(
  "settings_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "settings_settings_id_seq",
  },
  "scope",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "site",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "value",
  { data_type => "text", is_nullable => 0 },
  "category",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
);

=head1 PRIMARY KEY

=over 4

=item * L</settings_id>

=back

=cut

__PACKAGE__->set_primary_key("settings_id");

1;
