package Interchange6::Test::Role::SQLite;

=head1 NAME

Interchange6::Test::Role::SQLite

=cut

use Class::Load qw/try_load_class/;
use Test::Roo::Role;
with 'Interchange6::Test::Role::Database';

=head1 METHODS

See also L<Interchange6::Test::Role::Database> which is consumed by this role.

=head2 BUILD

Check that all required modules load or else plan skip_all

=cut

sub BUILD {
    try_load_class('DBD::SQLite')
      or plan skip_all => "DBD::SQLite required to run these tests";
}

sub _build_database {

    # does nothing atm for SQLite
    return;
}

sub _build_dbd_version {
    return "DBD::SQLite $DBD::SQLite::VERSION";
}

=head2 connect_info

Returns appropriate DBI connect info for this role.

=cut

sub connect_info {
    my $self = shift;

    # :memory: db only for now
    return ( "dbi:SQLite:dbname=:memory:", undef, undef,
        {
            sqlite_unicode  => 1,
            on_connect_call => 'use_foreign_keys',
            on_connect_do   => 'PRAGMA synchronous = OFF',
            quote_names     => 1,
        }
    );
}

sub _build_database_info {
    my $self = shift;
    return "SQLite library version: "
      . $self->schema->storage->dbh->{sqlite_version};
}

1;
