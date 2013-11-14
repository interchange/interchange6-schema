use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_product_class);

use_ok('Interchange6::Schema::Result::ProductClass');

is('product_classes', Interchange6::Schema::Result::ProductClass->table(), 'Table is defined correctly');

eval {
    $db->txn_do(sub {
                    ok(my $class = make_product_class(), 'product class row initialized');

                    ok($class->insert, 'Insert worked');

                    die "rollback";
                });
    1;
};

