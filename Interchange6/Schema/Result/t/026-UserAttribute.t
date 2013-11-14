use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_user_attribute);

use_ok('Interchange6::Schema::Result::UserAttribute');
is('user_attributes', Interchange6::Schema::Result::UserAttribute->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $user_attr = make_user_attribute(), 'user attribute row initialized');

                ok($user_attr->insert, 'Insert worked');

                die "rollback";
            });

1;

