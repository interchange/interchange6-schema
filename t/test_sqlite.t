#!perl

use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Roo;
with 'Role::Fixtures', 'Role::SQLite', 'Test::BaseAttribute', 'Test::Expire', 'Test::Message', 'Test::Payment', 'Test::Shipment', 'Test::Tax', 'Test::UserAttribute', 'Test::UserRole', 'Test::Variant', 'Test::Zone';

run_me;

done_testing;
