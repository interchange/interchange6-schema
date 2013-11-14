use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_inventory);

use_ok('Interchange6::Schema::Result::Inventory');
is('inventory', Interchange6::Schema::Result::Inventory->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $inventory = make_inventory(), 'inventory row initialized');

                ok($inventory->insert, 'Insert worked');

                die "rollback";
            });

1;
