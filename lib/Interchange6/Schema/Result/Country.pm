use utf8;
package Interchange6::Schema::Result::Country;

=head1 NAME

Interchange6::Schema::Result::Country

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<countries>

=cut

__PACKAGE__->table("countries");

=head1 DESCRIPTION

ISO 3166-1 codes for country identification

B<country_iso_code:> Two letter country code such as 'SI' = Slovenia.

B<scope:> Internal sorting field.

B<name:>  Full country name.

B<priority:>  Display order.

B<active:>  Active shipping destination?  Default is false.

=cut

=head1 ACCESSORS

=head2 country_iso_code

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 0
  size: 2

=head2 scope

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 priority

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 show_state

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "country_iso_code",
  { data_type => "char", default_value => "", is_nullable => 0, size => 2 },
  "scope",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "show_states",
  { data_type => "boolean", default_value => 0, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</country_iso_code>

=back

=cut

__PACKAGE__->set_primary_key("country_iso_code");

=head1 RELATIONSHIPS

=head2 zone_countries

C<has_many> relationship with L<Interchange6::Schema::Result::ZoneCountry>

=cut

__PACKAGE__->has_many(
                      'zone_countries',
                      "Interchange6::Schema::Result::ZoneCountry",
                      { "foreign.country_iso_code" => "self.country_iso_code" },
                     );

=head2 zones

C<many_to_many> relationship with L<Interchange6::Schema::Result::Zone>

=cut

__PACKAGE__->many_to_many("zones", "zone_countries", "zone");

=head2 states

C<has_many> relationship with L<Interchange6::Schema::Result::State>

=cut

__PACKAGE__->has_many(
    'states', "Interchange6::Schema::Result::State",
    'country_iso_code',
);

1;
