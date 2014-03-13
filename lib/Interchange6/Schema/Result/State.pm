use utf8;
package Interchange6::Schema::Result::State;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::State

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<states>

=cut

=head1 DESCRIPTION

ISO 3166-2 codes for sub_country identification "states"

B<scope:> Internal sorting field.

B<country_iso_code:> Two letter country code such as 'SI' = Slovenia.

<state_iso_code:> Alpha state code such as 'NY' = New York.

B<name:>  Full state name.

B<priority:>  Display sorting.

B<active:>  Is this state a shipping destination?  Default is true.

=cut

__PACKAGE__->table("states");

=head1 ACCESSORS

=head2 states_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 scope

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 country_iso_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0

=head2 state_iso_code

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 6

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 priority

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "states_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "scope",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "country_iso_code",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0 },
  "state_iso_code",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 6 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</states_id>

=back

=cut

__PACKAGE__->set_primary_key("states_id");

=head1 RELATIONS

=head2 Country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
  "Country",
  "Interchange6::Schema::Result::Country",
  { country_iso_code => "country_iso_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-12-06 07:40:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4ycBkFKPUPXEOv3/IfNayw
