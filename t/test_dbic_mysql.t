use strict;
use warnings;
use Test::Most;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use DBD::mysql";
plan skip_all => "DBD::mysql required" if $@;

eval "use Test::mysqld";
plan skip_all => "Test::mysqld required" if $@;

require("t/test_dbic.pl");
