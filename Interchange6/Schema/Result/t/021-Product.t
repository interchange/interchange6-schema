use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_product);

use_ok('Interchange6::Schema::Result::Product');
is('products', Interchange6::Schema::Result::Product->table(), 'Table is defined correctly');


$db->txn_do(sub {
                ok(my $product = make_product(), 'product row initialized');

                ok($product->insert, 'Insert worked');

                die "rollback";
            });

1;
