#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Role::Fixtures', 'Role::MySQL', 'Test::Expire', 'Test::Message', 'Test::Tax', 'Test::Variant', 'Test::Zone';

run_me;

done_testing;
