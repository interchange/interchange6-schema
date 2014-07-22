#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Role::Fixtures', 'Test::Fixtures', 'Role::SQLite';

run_me;

done_testing;
