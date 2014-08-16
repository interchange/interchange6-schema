package Role::MySQL;

use Test::More;
use Test::Roo::Role;
with 'Role::Database';

eval "use DateTime::Format::MySQL";
plan skip_all => "DateTime::Format::MySQL required" if $@;

eval "use DBD::mysql";
plan skip_all => "DBD::mysql required" if $@;

eval "use Test::mysqld";
plan skip_all => "Test::mysqld required" if $@;

sub _build_database {
    my $self = shift;
    no warnings 'once';    # prevent: "Test::mysqld::errstr" used only once
    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'character-set-server' => 'utf8',
            'collation-server'     => 'utf8_unicode_ci',
            'skip-networking'      => '',
        }
    ) or plan skip_all => $Test::mysqld::errstr;
    return $mysqld;
}

sub _build_dbd_version {
    my $self = shift;
    return
        "DBD::mysql $DBD::mysql::VERSION Test::mysqld "
      . "$Test::mysqld::VERSION mysql_clientversion "
      . $self->schema->storage->dbh->{mysql_clientversion};
}

sub connect_info {
    my $self = shift;
    return ( $self->database->dsn( dbname => 'test' ),
        undef, undef,
        { mysql_enable_utf8 => 1, on_connect_call => 'set_strict_mode' } );
}

sub _build_database_info {
    my $self = shift;
    $self->schema->storage->dbh_do(
        sub {
            my ( $storage, $dbh ) = @_;
            my $variables = $dbh->selectall_arrayref(q(SHOW VARIABLES));
            my @info = map { $_->[0] =~ s/_server//; "$_->[0]=$_->[1]" } grep {
                $_->[0] =~ /^(version|character_set_server|collation_server)/
                  && $_->[0] !~ /compile/
            } @$variables;
            return join( " ", @info );
        }
    );
}

1;
