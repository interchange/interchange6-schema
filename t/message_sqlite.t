#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Test::Message', 'Role::SQLite';

run_me;

done_testing;
