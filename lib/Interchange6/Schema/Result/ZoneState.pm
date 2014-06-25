use utf8;

package Interchange6::Schema::Result::ZoneState;

=head1 NAME

Interchange6::Schema::Result::ZoneState

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<zone_states>

=cut

__PACKAGE__->table("zone_states");

=head1 ACCESSORS

=head2 zones_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 states_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    "zones_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
    "states_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</zones_id>

=item * L</states_id>

=back

=cut

__PACKAGE__->set_primary_key( "zones_id", "states_id" );

=head1 RELATIONS

=head2 zone

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Zone>

=cut

__PACKAGE__->belongs_to(
    "zone", "Interchange6::Schema::Result::Zone",
    "zones_id",
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 state

Type: belongs_to

Related object: L<Interchange6::Schema::Result::State>

=cut

__PACKAGE__->belongs_to(
    "state", "Interchange6::Schema::Result::State",
    "states_id",
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

1;
