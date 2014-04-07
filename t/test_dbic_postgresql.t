use strict;
use warnings;
use Test::More;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use DBD::Pg";
plan skip_all => "DBD::Pg required" if $@;

eval "use Test::postgresql";
plan skip_all => "Test::postgresql required" if $@;

do("t/test_dbic.pl");
