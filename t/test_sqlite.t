#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Role::Fixtures', 'Role::SQLite', 'Test::Message', 'Test::Tax', 'Test::Zone';

run_me;

done_testing;
