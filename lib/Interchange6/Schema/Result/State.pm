use utf8;

package Interchange6::Schema::Result::State;

=head1 NAME

Interchange6::Schema::Result::State

=cut

use Interchange6::Schema::Candy;

=head1 DESCRIPTION

ISO 3166-2 codes for sub_country identification "states"

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id =>
  { data_type => "integer", is_auto_increment => 1 };

=head2 scope

Scope. Defaults to empty string.

=cut

column scope =>
  { data_type => "varchar", default_value => "", size => 32 };

=head2 iso_code

State ISO code, e.g.: NY.

=cut

column iso_code => { data_type => "varchar", size => 6 };

=head2 country_id

FK on L<Interchange6::Schema::Result::Country/id>.

=cut

column country_id => { data_type => "integer" };

=head2 name

Full name of state/province, e.g.: New York.

=cut

column name => {
    data_type     => "varchar",
    size          => 255
};

=head2 priority

Display sort order. Defaults to 0.

=cut

column priority =>
  { data_type => "integer", default_value => 0 };

=head2 active

Whether state is an active shipping destination. Defaults to 1 (true).

=cut

column active =>
  { data_type => "boolean", default_value => 1 };

=head2 website_id

FK on L<Interchange6::Schema::Result::Website/id>.

=cut

column website_id => { data_type => "integer" };

=head1 UNIQUE CONSTRAINT

=head2 iso_code country_id website_id

=cut

unique_constraint [qw/iso_code country_id website_id/];

=head1 RELATIONS

=head2 country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

belongs_to
  country => "Interchange6::Schema::Result::Country",
  "country_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 zone_states

Type: has_many

Related object L<Interchange6::Schema::Result::ZoneState>

=cut

has_many
  zone_states => "Interchange6::Schema::Result::ZoneState",
  "state_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 zones

Type: many_to_many

Composing rels: L</zone_states> -> zone

=cut

many_to_many zones => "zone_states", "zone";

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

1;
