use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_address);

use_ok('Interchange6::Schema::Result::Address');

is('addresses', Interchange6::Schema::Result::Address->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $address = make_address(), 'address row initialized');

                ok($address->insert, 'Insert worked');

                die "rollback";
            });

1;
