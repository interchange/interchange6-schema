use utf8;

package Interchange6::Schema::Result::EmailAddress;

=head1 NAME

Interchange6::Schema::Result::EmailAddress - a User can have many email addresses

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

use overload '""' => sub { shift->email }, fallback => 1;

=head1 DESCRIPTION

Additional email addresses for users.

Stringifies to value of L</email>.

=head1 ACCESSORS

=head2 email

Primary Key.

Lower-cased by overloaded L</insert> and L</update> methods.

This is effectively the envelope 'to'.

=cut

primary_column email => { data_type => "varchar", size => 254 };

=head2 users_id

FK on L<Interchange6::Schema::Result::User/users_id>

=cut

column users_id => { data_type => "integer" };

=head2 header_to

The header 'to' which can include name, e.g.:

  Dave Bean <dave.bean@example.com>

See L</insert> regarding default value for this column.

=cut

column header_to => { data_type => "varchar", size => 512 };

=head2 type

Type of email address, e.g.: work, personal, github

Defaults to empty string.

=cut

column type => { data_type => "varchar", size => 64, default_value => '' };

=head2 active

Boolean whether email address is active. Defaults to true value.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head2 validated

Whether email address has been validated in some way. Defaults to false value.

=cut

column validated => { data_type => "boolean", default_value => 0 };

=head2 validated_date

The L<DateTime> when this email address was validated. Is nullable.

=cut

column validated_date => { data_type => "datetime", is_nullable => 1 };

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => { data_type => "datetime", set_on_create => 1 };

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to user => "Interchange6::Schema::Result::User", "users_id";

=head1 METHODS

=head2 insert

Overloaded method which performs the following additional actions:

=over

=item Force L</email> to lower case.

=item Set L</header_to> to L</email> if is has not been set.

=back

=cut

sub insert {
    my $self = shift;
    $self->email( lc( $self->email ) );
    $self->header_to( $self->email ) unless $self->header_to;
    return $self->next::method();
}

=head2 update

Overloaded method to force L</email> to lower case.

=cut

sub update {
    my ( $self, $columns ) = @_;

    # email may have been passed as arg or previously updated
    if ( exists $columns->{email} ) {
        $columns->{email} = lc( $columns->{email} );
    }
    elsif ( $self->is_column_changed('email') ) {
        $self->email( lc( $self->email ) );
    }

    return $self->next::method($columns);
}

1;
