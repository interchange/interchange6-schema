use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_orderline);

use_ok('Interchange6::Schema::Result::Orderline');
is('orderlines', Interchange6::Schema::Result::Orderline->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $orderline = make_orderline(), 'orderlines row initialized');

                ok($orderline->insert, 'Insert worked');

                die "rollback";
            });

1;
