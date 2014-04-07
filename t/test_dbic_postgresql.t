use strict;
use warnings;
use Test::Most;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Enable test_dbic_postgresql tests with TEST_DBIC environment variable" );
}

eval "use DBD::Pg";
plan skip_all => "DBD::Pg required" if $@;

eval "use Test::postgresql";
plan skip_all => "Test::postgresql required" if $@;

require("t/test_dbic.pl");
