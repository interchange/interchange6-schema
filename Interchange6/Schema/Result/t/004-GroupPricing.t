use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_group_pricing);

use_ok('Interchange6::Schema::Result::GroupPricing');
is('group_pricing', Interchange6::Schema::Result::GroupPricing->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $group_pricing = make_group_pricing(), 'group_pricing row initialized');

                ok($group_pricing->insert, 'Insert worked');

                die "rollback";
            });

1;
