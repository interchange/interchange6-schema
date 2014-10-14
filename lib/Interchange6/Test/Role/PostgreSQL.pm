package Interchange6::Test::Role::PostgreSQL;

=head1 NAME

Interchange6::Test::Role::PostgreSQL

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
    my $self = shift;

    try_load_class('DateTime::Format::Pg')
      or plan skip_all => "DateTime::Format::Pg required to run these tests";

    try_load_class('DBD::Pg')
      or plan skip_all => "DBD::Pg required to run these tests";

    try_load_class('Test::PostgreSQL')
      or plan skip_all => "Test::PostgreSQL required to run these tests";

    eval { $self->database }
      or plan skip_all => "Init database failed: $@";
}

sub _build_database {
    my $self = shift;
    no warnings 'once'; # prevent: "Test::PostgreSQL::errstr" used only once
    my $pgsql = Test::PostgreSQL->new(
        initdb_args
          => $Test::PostgreSQL::Defaults{initdb_args}
            . ' --encoding=utf8 --no-locale'
    ) or die $Test::PostgreSQL::errstr;
    return $pgsql;
}

sub _build_dbd_version {
    return "DBD::Pg $DBD::Pg::VERSION Test::PostgreSQL $Test::PostgreSQL::VERSION";
}

=head2 connect_info

Returns appropriate DBI connect info for this role.

=cut

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
