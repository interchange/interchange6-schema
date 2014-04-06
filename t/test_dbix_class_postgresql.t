use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use DBD::Pg";
plan skip_all => "DBD::Pg required" if $@;
`
eval "use Test::postgresql";
plan skip_all => "Test::postgresql required" if $@;
`
$ENV{TDC_TRAIT} = 'Testpostgresql';

do("t/test_dbix_class.pl");
