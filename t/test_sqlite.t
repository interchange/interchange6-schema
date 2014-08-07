#!perl

use File::Spec;
use Module::Find;
use Test::Roo;

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

with 'Role::Fixtures', 'Role::SQLite', @test_roles;

run_me;

done_testing;
