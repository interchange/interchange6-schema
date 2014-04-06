use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

$ENV{TDC_TRAIT} = 'SQLite';

do("t/test_dbix_class.pl");
