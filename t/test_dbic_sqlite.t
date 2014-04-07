use strict;
use warnings;
use Test::Most;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Enable test_dbic_sqlite tests with TEST_DBIC environment variable" );
}

require("t/test_dbic.pl");
