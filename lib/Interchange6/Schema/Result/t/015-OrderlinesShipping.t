use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_orderline_shipping);

use_ok('Interchange6::Schema::Result::OrderlinesShipping');
is('orderlines_shipping', Interchange6::Schema::Result::OrderlinesShipping->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $orderline_shipping = make_orderline_shipping(), 'orderlines_shipping row initialized');

                ok($orderline_shipping->insert, 'Insert worked');

                die "rollback";
            });

1;
