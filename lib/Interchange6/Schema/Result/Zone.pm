use utf8;

package Interchange6::Schema::Result::Zone;

=head1 NAME

Interchange6::Schema::Result::Zone

=cut

use strict;
use warnings;
use DateTime;
use Scalar::Util qw(blessed);

use Moo;

extends 'DBIx::Class::Core';

with('Interchange6::Schema::Role::Errors');

use namespace::clean;

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<zones>

=cut

__PACKAGE__->table("zones");

=head1 DESCRIPTION

In the context of zones the term 'state' refers to state, province or other principal subdivision of a country as defined in L<ISO 3116-2|http://en.wikipedia.org/wiki/ISO_3166-2>. Countries to be added to a zone must already exist in L<Interchange6::Schema::Result::Country> and states in L<Interchange6::Schema::Result::State>.

Zones can contain any of the following:

=over 4

=item * No countries and no states

An empty zone must be created before countries/states are added but otherwise is probably not useful.

=item * Multiple countries

For example to create a trading group like the European Union.

=item * A single country

Probably what to use in combination with postal ranges.

=item * A single country with a single state

For example Qubec in Canada which has GST + QST

=item * A single country with multiple states

For example a group containing all Canadian provinces that charge only GST.

=back

The following combinations are NOT allowed:

=over 4

=item * Multiple countries with one or more states

=item * One or more states with no country

=back

Countries and states should be added to and removed from the zone using these methods which are described further below:

=over 4

=item * add_countries

=item * remove_countries

=item * add_states

=item * remove_states

=back

B<NOTE:> avoid using other methods from L<DBIx::Class::Relationship::Base> since you may inadvertently end up with an invalid zone.

=head1 ACCESSORS

NOTE: postal_range_state and postal_range_end are only really useful when the zone contains a single country.

=head2 zones_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'zones_id_seq'

=head2 zone

For example for storing the UPS/USPS zone code or perhaps a simple name for the zone.

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 postal_range_start

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 postal_range_end

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
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

=cut

__PACKAGE__->add_columns(
    "zones_id",
    {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "zones_id_seq"
    },
    "zone",
    {
        data_type     => "varchar",
        default_value => "",
        is_nullable   => 1,
        size          => 255
    },
    "postal_range_start",
    {
        data_type     => "varchar",
        default_value => "",
        is_nullable   => 0,
        size          => 255
    },
    "postal_range_end",
    {
        data_type     => "varchar",
        default_value => "",
        is_nullable   => 0,
        size          => 255
    },
    "created",
    { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
    "last_modified",
    {
        data_type     => "datetime",
        set_on_create => 1,
        set_on_update => 1,
        is_nullable   => 0
    },
);

=head1 PRIMARY KEY

=over 4

=item * L</zones_id>

=back

=cut

__PACKAGE__->set_primary_key("zones_id");

=head1 RELATIONS

=head2 ZoneCountry

Type: has_many

Related object: L<Interchange6::Schema::Result::ZoneCountry>

=cut

__PACKAGE__->has_many(
    "ZoneCountry", "Interchange6::Schema::Result::ZoneCountry",
    "zones_id", { cascade_copy => 0, cascade_delete => 0 },
);

=head2 countries

Type: many_to_many

Accessor to related Country results ordered by name.

=cut

__PACKAGE__->many_to_many( "countries", "ZoneCountry", "Country",
    { order_by => 'Country.name' } );

=head2 ZoneState

Type: has_many

Related object: L<Interchange6::Schema::Result::ZoneState>

=cut

__PACKAGE__->has_many(
    "ZoneState", "Interchange6::Schema::Result::ZoneState",
    "zones_id", { cascade_copy => 0, cascade_delete => 0 },
);

=head2 states

Type: many_to_many

Accessor to related State results ordered by name.

=cut

__PACKAGE__->many_to_many( "states", "ZoneState", "State",
    { order_by => 'State.name' } );

=head1 METHODS

=head2 new

Should not be called directly. Used to set default values for certain rows.

=cut

sub new {
    my ( $class, $attrs ) = @_;

    $attrs->{zone} = '' unless defined $attrs->{zone};

    my $new = $class->next::method($attrs);

    return $new;
}

=head2 add_countries

Argument is either a L<Interchange6::Schema::Result::Country> object or an arrayref of the same.

Returns the Zone object or undef on failure. Errors are available via errors method inherited from L<Interchange6::Schema::Role::Errors>.

=cut

sub add_countries {
    my ( $self, $arg ) = ( shift, shift );

    $self->clear_errors;

    if ( $self->state_count > 0 ) {
        $self->add_error("Cannot add countries to zone with states");
        return;
    }

    if ( ref($arg) eq 'Interchange6::Schema::Result::Country' ) {

        # a single arg so convert to arrayref and continue
        $arg = [$arg];
    }
    elsif ( ref($arg) ne "ARRAY" ) {

        # no idea what we've been given
        $self->add_error("Bad arg passed to add_countries: " . ref($arg));
        return;
    }

    # use a transaction when adding countries so that all succeed or all fail

  TXN: for ( ; ; ) {

        my $guard = $self->result_source->schema->txn_scope_guard;

        foreach my $country (@$arg) {

            unless ( blessed($country)
                && $country->isa('Interchange6::Schema::Result::Country') )
            {

                $self->add_error(
                    "Country must be an Interchange6::Schema::Result::Country");
                return;
            }

            eval { $self->add_to_countries($country); };
            if ($@) {
                $self->add_error( "Failed to add "
                      . $country->name
                      . " to zone "
                      . $self->zone );
                last TXN;
            }
        }

        $guard->commit;
        last TXN;
    }

    if ( $self->has_error ) {
        return undef;
    }
    else {
        return $self;
    }
}

=head2 has_country

Argument can be Interchange6::Schema::Result::Country, country name or iso code. Returns 1 if zone includes that country else 0;

=cut

sub has_country {
    my ( $self, $country ) = ( shift, shift );
    my $rset;

    # first try Country object

    if ( blessed($country) ) {
        if ( $country->isa('Interchange6::Schema::Result::Country') ) {

            $rset = $self->country->search(
                {
                    "Country.country_iso_code" => $country->country_iso_code,
                }
            );
            return 1 if $rset->count == 1;

        }
        else {
            return 0;
        }
    }

    # maybe an ISO code?

    if ( $country =~ /^[a-z]{2}$/i ) {

        $rset = $self->countries->search(
            { "Country.country_iso_code" => uc($country) } );

        return 1 if $rset->count == 1;
    }

    # finally try country name

    $rset = $self->countries->search( { "Country.name" => $country } );

    return 1 if $rset->count == 1;

    return 0;
}

=head2 country_count

Takes no args. Returns the number of countries in the zone.

=cut

sub country_count {
    my $self = shift;
    return $self->countries->count;
}

=head2 remove_countries

Argument is either a L<Interchange6::Schema::Result::Country> object or an arrayref of the same.

Returns the Zone object or undef on failure. Errors are available via errors method inherited from L<Interchange6::Schema::Role::Errors>.

=cut

sub remove_countries {
    my ( $self, $arg ) = ( shift, shift );

    $self->clear_errors;

    if ( $self->state_count > 0 ) {

        $self->add_error("States must be removed before countries");
        return;
    }
    elsif ( ref($arg) eq 'Interchange6::Schema::Result::Country' ) {

        # a single arg so convert to arrayref and continue
        $arg = [$arg];
    }
    elsif ( ref($arg) ne "ARRAY" ) {

        # no idea what we've been given
        $self->add_error("Bad arg passed to remove_countries: " . ref($arg));
        return;
    }

    # use a transaction when removing countries so that all succeed or all fail

  TXN: for ( ; ; ) {

        my $guard = $self->result_source->schema->txn_scope_guard;

        foreach my $country (@$arg) {

            unless ( blessed($country)
                && $country->isa('Interchange6::Schema::Result::Country') )
            {

                $self->add_error(
                    "Country must be an Interchange6::Schema::Result::Country");
                return;
            }

            eval { $self->remove_from_countries($country); };
            if ($@) {
                $self->add_error( "Failed to rmeove "
                      . $country->name
                      . " from zone "
                      . $self->zone );
                last TXN;
            }
        }

        $guard->commit;
        last TXN;
    }

    if ( $self->has_error ) {
        return undef;
    }
    else {
        return $self;
    }
}

=head2 add_states

Argument is either a L<Interchange6::Schema::Result::State> object or an arrayref of the same.

Returns the Zone object or undef on failure. Errors are available via errors method inherited from L<Interchange6::Schema::Role::Errors>.

=cut

sub add_states {
    my ( $self, $arg ) = ( shift, shift );

    $self->clear_errors;

    if ( $self->country_count > 1 ) {

        $self->add_error("Cannot add state to zone with multiple countries");
        return;
    }

    if ( ref($arg) eq 'Interchange6::Schema::Result::State' ) {

        # a single arg so convert to arrayref and continue
        $arg = [$arg];
    }
    elsif ( ref($arg) ne "ARRAY" ) {

        # no idea what we've been given
        $self->add_error("Bad arg passed to add_states: " . ref($arg));
        return;
    }

    # use a transaction when adding states so that all succeed or all fail

  TXN: for ( ; ; ) {

        my $guard = $self->result_source->schema->txn_scope_guard;

        foreach my $state (@$arg) {

            unless ( blessed($state)
                && $state->isa('Interchange6::Schema::Result::State') )
            {

                $self->add_error(
                    "State must be an Interchange6::Schema::Result::State");
                return;
            }

            if ( $self->country_count == 0 ) {

                # add the country first

                $self->add_countries( $state->Country );

                # bail out if we have an error
                return undef if $self->has_error;
            }
            else {
                # make sure state is in the existing country

                my $country =
                  $self->countries->search( {}, { rows => 1 } )->single;

                unless ( $country->country_iso_code eq
                    $state->Country->country_iso_code )
                {
                    $self->add_error(
                        "State is not in country " . $country->name );
                    return;
                }
            }

            # try to add the state

            eval { $self->add_to_states($state); };
            if ($@) {
                $self->add_error( "Failed to add "
                      . $state->name
                      . " to zone "
                      . $self->zone );
                last TXN;
            }
        }

        $guard->commit;
        last TXN;
    }

    if ( $self->has_error ) {
        return undef;
    }
    else {
        return $self;
    }
}

=head2 has_state

Argument can be Interchange6::Schema::Result::State, state name or iso code. Returns 1 if zone includes that state else 0;

=cut

sub has_state {
    my ( $self, $state ) = ( shift, shift );
    my $rset;

    # first try State object

    if ( blessed($state) ) {
        if ( $state->isa('Interchange6::Schema::Result::State') ) {

            $rset = $self->states->search(
                {
                    "State.country_iso_code" => $state->country_iso_code,
                    "State.state_iso_code"   => $state->state_iso_code
                }
            );
            return 1 if $rset->count == 1;

        }
        else {
            return 0;
        }
    }

    # maybe an ISO code?

    if ( $state =~ /^[a-z]{2}$/i ) {

        $rset = $self->states->search( { state_iso_code => uc($state) } );

        return 1 if $rset->count == 1;
    }

    # finally try state name

    $rset = $self->states->search( { name => $state } );

    return 1 if $rset->count == 1;

    return 0;
}

=head2 state_count

Takes no args. Returns the number of states in the zone.

=cut

sub state_count {
    my $self = shift;
    return $self->states->search( {} )->count;
}

=head2 remove_states

Argument is either a L<Interchange6::Schema::Result::State> object or an arrayref of the same.

Returns the Zone object or undef on failure. Errors are available via errors method inherited from L<Interchange6::Schema::Role::Errors>.

=cut

sub remove_states {
    my ( $self, $arg ) = ( shift, shift );

    $self->clear_errors;

    if ( ref($arg) eq 'Interchange6::Schema::Result::State' ) {

        # a single arg so convert to arrayref and continue
        $arg = [$arg];
    }
    elsif ( ref($arg) ne "ARRAY" ) {

        # no idea what we've been given
        $self->add_error("Bad arg passed to remove_states: " . ref($arg));
        return;
    }

    # use a transaction when removing states so that all succeed or all fail

  TXN: for ( ; ; ) {

        my $guard = $self->result_source->schema->txn_scope_guard;

        foreach my $state (@$arg) {

            unless ( blessed($state)
                && $state->isa('Interchange6::Schema::Result::State') )
            {

                $self->add_error(
                    "State must be an Interchange6::Schema::Result::State");
                return;
            }

            # try to remove the state
            eval { $self->remove_from_states($state); };
            if ($@) {
                $self->add_error( "Failed to remove "
                      . $state->name
                      . " from zone "
                      . $self->zone );
                last TXN;
            }
        }

        $guard->commit;
        last TXN;
    }

    if ( $self->has_error ) {
        return undef;
    }
    else {
        return $self;
    }
}

1;
