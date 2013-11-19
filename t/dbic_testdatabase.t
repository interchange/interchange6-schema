use strict;
use warnings;

use Test::More tests => 2;

use Interchange6::Schema;
use DBICx::TestDatabase;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my $user = $schema->resultset('User')->create({username => 'nevairbe@nitesi.de',
                                   email => 'nevairbe@nitesi.de',
                                   password => 'nevairbe'});

isa_ok($user, 'Interchange6::Schema::Result::User')
    || diag "Create result: $user.";

ok($user->id == 1, "Testing user id.")
    || diag "User id: " . $user->id;


