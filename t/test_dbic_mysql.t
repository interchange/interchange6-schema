use strict;
use warnings;
use Test::Most;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Enable test_dbic_myql tests with TEST_DBIC environment variable" );
}

eval "use DBD::mysql";
plan skip_all => "DBD::mysql required" if $@;

eval "use Test::mysqld";
plan skip_all => "Test::mysqld required" if $@;

require("t/test_dbic.pl");
