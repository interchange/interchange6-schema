use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_merchandising_product);

use_ok('Interchange6::Schema::Result::MerchandisingProduct');
is('merchandising_products', Interchange6::Schema::Result::MerchandisingProduct->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $merchandising_product = make_merchandising_product(), 'merchandising_product row initialized');

                ok($merchandising_product->insert, 'Insert worked');

                die "rollback";
            });

1;
