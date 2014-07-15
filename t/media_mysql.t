#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Test::Media', 'Role::MySQL';

run_me;

done_testing;
