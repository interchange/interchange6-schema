use strict;
use FindBin;
use Test::More tests => 4;
use lib "$FindBin::Bin/../../../../";
use Interchange6::Schema;
use Interchange6::Schema::TestBed qw($db make_media_type);

use_ok('Interchange6::Schema::Result::MediaType');
is('media_types', Interchange6::Schema::Result::MediaType->table(), 'Table is defined correctly');

$db->txn_do(sub {
                ok(my $media_type = make_media_type(), 'media_type row initialized');

                ok($media_type->insert, 'Insert worked');

                die "rollback";
            });

1;
