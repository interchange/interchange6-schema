package Role::SQLite;

use Test::More;
use Test::Roo::Role;
with 'Role::Database';

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
    return ( "dbi:SQLite:dbname=:memory:" );
}

1;
