use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 10;
use Try::Tiny;
use DBICx::TestDatabase;
use Date::Parse;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');
my $now = time();

# create product
my %data = (sku => 'BN004',
            name => 'Walnut Extra',
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

# create sessions
my @pop_session =  (
    [ '6182808', 'Green Banana', '', '' ],
    [ '9999999', 'Red Banana', '', '']
);

$schema->populate('Session', [
[ 'sessions_id', 'session_data', 'created', 'last_modified' ],
@pop_session,
]);

my $rs = $schema->resultset('Session');

ok($rs->count eq '2', "Testing session count.")
    || diag "Session count: " . $rs->count;

# create carts
my @pop_cart =  (
    [ '1','main', '1', '6182808', '', '', undef ],
    [ '2','main', undef, '9999999', '', '', undef ]
);

$schema->populate('Cart', [
[ 'carts_id', 'name', 'users_id', 'sessions_id', 'created', 'last_modified', 'approved' ],
@pop_cart,
]);

my $rs_cart = $schema->resultset('Cart');

ok($rs_cart->count eq '2', "Testing cart count.")
    || diag "Cart count: " . $rs_cart->count;

# create CartProduct
my @pop_prod =  (
    [ '1','BN004', '1', '1', '', '' ],
    [ '2','BN004', '1', '12', '', '' ]
);

# populate CartProduct
$schema->populate('CartProduct', [
  [ 'carts_id', 'sku', 'cart_position', 'quantity', 'created', 'last_modified' ],
@pop_prod,
]);

my $rs_prod = $schema->resultset('Cart');

ok($rs_prod->count eq '2', "Testing cart count.")
    || diag "CartProduct count: " . $rs_prod->count;

# find expired sessions and delete them
my $delete_expired_sessions = $schema->resultset('Session')->expire('1 second');

# test for expired sessions
$rs = $schema->resultset('Session');
ok($rs->count eq '0', "Testing sessions count.")
    || diag "Sessions count: " . $rs->count;

# test remaining carts
my $carts = $schema->resultset('Cart');
ok($carts->count() eq '1', "Testing cart count.")
    || diag "Cart count: " . $carts->count();

while (my $carts_rs = $carts->next) {
is($carts_rs->sessions_id, undef, "undefined as expected");
}
