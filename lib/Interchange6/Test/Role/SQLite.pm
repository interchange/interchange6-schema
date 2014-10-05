package Interchange6::Test::Role::SQLite;

=head1 NAME

Interchange6::Test::Role::SQLite

=cut

=head1 METHODS

=head2 connect_info

Returns appropriate DBI connect info for this role.

=cut

use Test::Roo::Role;
with 'Interchange6::Test::Role::Database';

eval "use DBD::SQLite";
plan skip_all => "DBD::SQLite required" if $@;

sub _build_database {

    # does nothing atm for SQLite
    return;
}

sub _build_dbd_version {
    return "DBD::SQLite $DBD::SQLite::VERSION";
}

sub connect_info {
    my $self = shift;

    # :memory: db only for now
    return ( "dbi:SQLite:dbname=:memory:", undef, undef,
        { sqlite_unicode => 1, on_connect_call => 'use_foreign_keys',
          on_connect_do  => 'PRAGMA synchronous = OFF' } );
}

sub _build_database_info {
    my $self = shift;
    return "SQLite library version: "
      . $self->schema->storage->dbh->{sqlite_version};
}

1;
