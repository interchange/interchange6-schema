use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 7;

use Interchange6::Schema;
use DBICx::TestDatabase;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

# create product
my %data = (sku => 'BN004',
            name => 'Green Banana',
            price => 12);

my $product = $schema->resultset('Product')->create(\%data);

isa_ok($product, 'Interchange6::Schema::Result::Product')
    || diag "Create result: $product.";

ok($product->id eq 'BN004', "Testing product id.")
    || diag "Product id: " . $product->id;

# create user
my $user = $schema->resultset('User')->create({username => 'nevairbe@nitesi.de',
                                   email => 'nevairbe@nitesi.de',
                                   password => 'nevairbe'});

isa_ok($user, 'Interchange6::Schema::Result::User')
    || diag "Create result: $user.";

ok($user->id == 1, "Testing user id.")
    || diag "User id: " . $user->id;

# countries
use Locale::Country;

my @countries;

@countries = map {[$_, code2country($_)]} (all_country_codes(LOCALE_CODE_ALPHA_2));

# populate countries table
my $ret = $schema->populate('Country', [
  [ 'country_iso_code', 'name' ],
  @countries,
]);

ok(defined $ret && ref($ret) eq 'ARRAY' && @$ret == @countries,
   "Result of populating Country.");

$ret = $schema->resultset('Country')->find('de');

isa_ok($ret, 'Interchange6::Schema::Result::Country');

ok($ret->name eq 'Germany', "Country found for iso_code DE")
    || diag "Result: " . $ret->name;


