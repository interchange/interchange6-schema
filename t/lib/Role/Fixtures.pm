package Role::Fixtures;

use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;

use Test::Roo::Role;

=head1 ATTRIBUTES & METHODS

=head2 countries

=cut

has countries => (
    is        => 'lazy',
    clearer   => '_clear_countries',
    predicate => 1,
);

sub _build_countries {
    my $self         = shift;
    my $rset_country = $self->schema->resultset('Country');

    my $pop = Interchange6::Schema::Populate::CountryLocale->new->records;
    $rset_country->populate($pop) or die "Failed to populate Country";
    return $rset_country;
}

=head2 clear_countries

Deletes all rows from Country class and clears L</countries> attribute.

=cut

sub clear_countries {
    my $self = shift;
    if ( $self->has_countries ) {
        $self->countries->delete_all;
        $self->_clear_countries;
    }
}

=head2 states

=cut

has states => (
    is        => 'lazy',
    clearer   => '_clear_states',
    predicate => 1,
);

sub _build_states {
    my $self       = shift;
    my $rset_state = $self->schema->resultset('State');

    # we must have countries before we can proceed
    $self->countries unless $self->has_countries;

    my $pop = Interchange6::Schema::Populate::StateLocale->new->records;
    $rset_state->populate($pop) or die "Failed to populate State";
    return $rset_state;
}

=head2 clear_states

Deletes all rows from State class and clears L</states> attribute.

=cut

sub clear_states {
    my $self = shift;
    if ( $self->has_states ) {
        $self->states->delete_all;
        $self->_clear_states;
    }
}

=head2 users

=cut

has users => (
    is        => 'lazy',
    clearer   => '_clear_users',
    predicate => 1,
);

sub _build_users {
    my $self      = shift;
    my $rset_user = $self->schema->resultset('User');

    my $ret = $rset_user->populate(
        [
            [qw( username email password )],
            [ 'customer1', 'customer1@example.com', 'c1passwd' ],
            [ 'customer2', 'customer2@example.com', 'c1passwd' ],
            [ 'customer3', 'customer3@example.com', 'c1passwd' ],
            [ 'admin1',    'admin1@example.com',    'a1passwd' ],
            [ 'admin2',    'admin2@example.com',    'a2passwd' ],
        ]
    );

    return $rset_user;
}

=head2 clear_users

Deletes all rows from User class and clears L</users> attribute.

=cut

sub clear_users {
    my $self = shift;
    if ( $self->has_users ) {
        $self->users->delete_all;
        $self->_clear_users;
    }
}

=head2 zones

=cut

has zones => (
    is        => 'lazy',
    clearer   => '_clear_zones',
    predicate => 1,
);

=head2 zones

=cut

sub _build_zones {
    my $self      = shift;
    my $rset_zone = $self->schema->resultset('Zone');

    # we need to pass min value of states_id to ::Populate::Zone
    # also kicks in states and countries builders if not already set

    my $rset = $self->states->search(
        {},
        {
            select => [ { min => 'states_id' } ],
            as     => ['min_id'],
        }
    );

    my $min_states_id = $rset->first->get_column('min_id');

    my $pop =
      Interchange6::Schema::Populate::Zone->new(
        states_id_initial_value => $min_states_id )->records;

    $rset_zone->populate($pop) or die "Failed to populate Zone";
    return $rset_zone;
}

=head2 clear_zones

Deletes all rows from Zone class and clears L</zones> attribute.

=cut

sub clear_zones {
    my $self = shift;
    if ( $self->has_zones ) {
        $self->zones->delete_all;
        $self->_clear_zones;
    }
}

=head2 clear_all_fixtures

Clears all fixtures using respective clear_* methods

=cut

sub clear_all_fixtures {
    my $self = shift;
    $self->clear_users;
    $self->clear_zones;
    $self->clear_states;
    $self->clear_countries;
}

1;
