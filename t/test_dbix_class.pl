use strict;
use warnings;

use Data::Dumper;
use Test::Most;

BEGIN { use_ok('Test::DBIx::Class', 0.41) or BAIL_OUT "Cannot load Test::DBIx::Class 0.41" };

use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;

use Test::DBIx::Class { traits => $ENV{TDC_TRAIT} };

fixtures_ok sub {
    my $schema = shift @_;
    my $data = Interchange6::Schema::Populate::CountryLocale->new->records;
    foreach my $record ( @$data ) {
        $schema->resultset('Country')->create($record);
    }
}, 'Populate countries';

done_testing;
