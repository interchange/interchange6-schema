package Interchange6::Test::Role::PostgreSQL;

=head1 NAME

Interchange6::Test::Role::PostgreSQL

=cut

=head1 METHODS

=head2 connect_info

Returns appropriate DBI connect info for this role.

=cut

use Test::Roo::Role;
with 'Interchange6::Test::Role::Database';

eval "use DateTime::Format::Pg";
plan skip_all => "DateTime::Format::Pg required" if $@;

eval "use DBD::Pg";
plan skip_all => "DBD::Pg required" if $@;

eval "use Test::PostgreSQL";
plan skip_all => "Test::PostgreSQL required" if $@;

sub _build_database {
    my $self = shift;
    no warnings 'once'; # prevent: "Test::PostgreSQL::errstr" used only once
    my $pgsql = Test::PostgreSQL->new(
        initdb_args
          => $Test::PostgreSQL::Defaults{initdb_args} . ' --encoding=utf8 --no-locale'
    ) or plan skip_all => $Test::PostgreSQL::errstr;
    return $pgsql;
}

sub _build_dbd_version {
    return "DBD::Pg $DBD::Pg::VERSION Test::PostgreSQL $Test::PostgreSQL::VERSION";
}

sub connect_info {
    my $self = shift;
    return ( $self->database->dsn, undef, undef,
        {
            on_connect_do  => 'SET client_min_messages=WARNING;',
            pg_enable_utf8 => 1,
        }
    );
}

sub _build_database_info {
    my $self = shift;
    $self->schema->storage->dbh_do(
        sub {
            my ( $storage, $dbh ) = @_;
            @{ $dbh->selectrow_arrayref(q| SELECT version() |) }[0];
        }
    );
}

1;