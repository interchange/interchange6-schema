use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_permission);

use_ok('Interchange6::Schema::Result::Permission');
is('permissions', Interchange6::Schema::Result::Permission->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $permission = make_permission(), 'Permission row initialized');

                ok($permission->insert, 'Insert worked');

});

