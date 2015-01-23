#!perl

use Class::Load qw/try_load_class/;
use File::Spec;
use Module::Find;
use Test::Deep;
use Test::Roo;
use Test::MockTime;

BEGIN {
    try_load_class('DBD::mysql')
      or plan skip_all => "DBD::mysql required to run these tests";
    try_load_class('Test::mysqld')
      or plan skip_all => "Test::mysqld required to run these tests";
}
{
    no warnings 'once';
    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'character-set-server' => 'utf8',
            'collation-server'     => 'utf8_unicode_ci',
            'skip-networking'      => '',
          }

    ) or die $Test::mysqld::errstr;
    my $dbh = DBI->connect(
        $mysqld->dsn(dbname => 'test'),
    );
    use DBI::Const::GetInfoType;
    diag(
        "SQL_DBMS_VER",          $dbh->get_info( $GetInfoType{SQL_DBMS_VER} ),
        "DBD::mysql ",           $DBD::mysql::VERSION,
        " mysql_clientversion ", $dbh->{mysql_clientversion}
    );
}

use lib File::Spec->catdir( 't', 'lib' );
my @test_roles;

if ( $ENV{TEST_ROLE_ONLY} ) {
    push @test_roles, map { "Test::$_" } split(/,/, $ENV{TEST_ROLE_ONLY});
}
else {
    my @old_inc = @INC;
    setmoduledirs( File::Spec->catdir( 't', 'lib' ) );

    # Test::Fixtures is always run first
    @test_roles = sort grep { $_ ne 'Test::Fixtures' } findsubmod Test;
    unshift @test_roles, 'Test::Fixtures';

    setmoduledirs(@old_inc);
}

diag "with " . join(" ", @test_roles);

with 'Interchange6::Test::Role::Fixtures', 'Interchange6::Test::Role::MySQL', @test_roles;

run_me;

done_testing;
