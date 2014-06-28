use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 5;

use Try::Tiny;
use Interchange6::Schema;
use DBICx::TestDatabase;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

#create roles
my $pop_roles = $schema->resultset("Role")->populate([
    { roles_id => '1', name => 'user', label => 'Basic User' },
    { roles_id => '2', name => 'admin', label => 'Admin User' },
    { roles_id => '3', name => 'editor', label => 'Editor' },
]);

#create users
my $user = $schema->resultset('User');

$user->create(
    { username => 'sam', password => 'sam', first_name => 'Sam',
      last_name => 'Batschelet', email => 'sbatschelet@mac.com',
        user_roles => [
        { roles_id => '1' },
        { roles_id => '2' },
        { roles_id => '3' },
      ],
    });

$user->create(
    { username => 'joe', password => 'joe', first_name => 'Joe',
      last_name => 'Batschelet', email => 'jbatschelet@mac.com',
        user_roles => [
        { roles_id => '1' },
        { roles_id => '3' },
      ],
    });

# use many_to_many roles relationship
my $role_count_sam = $user->find({ username => 'sam' })->roles();

ok($role_count_sam eq '3', "Testing roles relationship.")
    || diag "role count for user sam:" . $role_count_sam;

my $role_count_joe = $user->find({ username => 'joe' })->roles();

ok($role_count_joe eq '2', "Testing roles relationship.")
    || diag "role count for user joe:" . $role_count_joe;

# test reverse relationship
my %users_expected = (1 => {count => 2},
		      2 => {count => 1},
		      3 => {count => 2},
		     );

my $roles_iter = $schema->resultset('Role')->search;

while (my $role = $roles_iter->next) {
    my $count = $role->users->count;
    my $expected = $users_expected{$role->id}->{count};

    ok ($count == $expected, "Test user count for " . $role->name)
	|| diag "Wrong user count: $count instead of $expected.";
}
