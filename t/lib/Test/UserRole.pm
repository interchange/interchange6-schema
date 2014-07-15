package Test::UserRole;

use Try::Tiny;
use Test::More;
use Test::Roo::Role;

test 'user role tests' => sub {
    my $self = shift;

my $schema = $self->schema;

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

ok($role_count_sam eq '3', "sam has 3 roles")
    || diag "role count for user sam:" . $role_count_sam;

my $role_count_joe = $user->find({ username => 'joe' })->roles();

ok($role_count_joe eq '2', "joe has 2 roles")
    || diag "role count for user joe:" . $role_count_joe;

# test reverse relationship
SKIP: {
    skip "user is a reserved word in Pg so joins against User fail", 1
    if $schema->storage->sqlt_type eq 'PostgreSQL';

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
}

};

1;
