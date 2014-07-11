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
    no warnings 'once'; # prevent: "Test::mysqld::errstr" used only once
    my $mysqld = Test::mysqld->new( my_cnf => { 'skip-networking' => '' } )
      or die $Test::mysqld::errstr;
    return $mysqld;
}

sub _build_dbd_version {
    return "DBD::mysql $DBD::mysql::VERSION";
}

sub connect_info {
    my $self = shift;
    return $self->database->dsn( dbname => 'test' );
}

1;
