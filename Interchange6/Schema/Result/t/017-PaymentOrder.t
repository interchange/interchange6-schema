use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_payment_order);

use_ok('Interchange6::Schema::Result::PaymentOrder');
is('payment_orders', Interchange6::Schema::Result::PaymentOrder->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $payment_order = make_payment_order(), 'payment_orders row initialized');

                ok($payment_order->insert, 'Insert worked');

                die "rollback";
            });

1;
