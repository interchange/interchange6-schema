#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Test::UserAttribute', 'Role::MySQL';

run_me;

done_testing;
