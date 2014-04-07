
BEGIN {
    plan tests => 4;
    use_ok( 'Test::DBIx::Class', 0.41 )
      or BAIL_OUT "Cannot load Test::DBIx::Class 0.41";
}

use Data::Dumper;

use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;

use Test::DBIx::Class;

fixtures_ok sub {
    Interchange6::Schema::Populate::CountryLocale->new->records;
}, 'Populate countries';

fixtures_ok sub {
    Interchange6::Schema::Populate::StateLocale->new->records;
}, 'Populate states';

fixtures_ok sub {
    Interchange6::Schema::Populate::Zone->new->records;
}, 'Populate zones';
