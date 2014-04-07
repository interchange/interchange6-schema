use strict;
use warnings;
use Test::Most;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Author tests not required for installation" );
}

require("t/test_dbic.pl");
