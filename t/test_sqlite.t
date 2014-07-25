#!perl

use Data::Dumper::Concise;
use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Role::Fixtures', 'Role::SQLite', 'Test::Expire', 'Test::Message', 'Test::Tax', 'Test::Variant', 'Test::Zone';

run_me;

done_testing;
