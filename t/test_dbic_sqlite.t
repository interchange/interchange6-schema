use strict;
use warnings;
use Test::More;

unless ( $ENV{TEST_DBIC} ) {
    plan( skip_all => "Author tests not required for installation" );
}

do("t/test_dbix_class.pl");
