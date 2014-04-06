use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use DBD::mysql";
plan skip_all => "DBD::mysql required" if $@;
`
eval "use Test::mysqld";
plan skip_all => "Test::mysqld required" if $@;
`
$ENV{TDC_TRAIT} = 'Testmysqld';

do("t/test_dbix_class.pl");
