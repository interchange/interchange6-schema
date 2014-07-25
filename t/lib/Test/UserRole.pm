package Test::UserRole;

use Try::Tiny;
use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'user role tests' => sub {

    diag Test::UserRole;

    my $self = shift;

    my ( $admin1, $admin2 );

    #create roles
    my $pop_roles = $self->schema->resultset("Role")->populate(
        [
            { roles_id => '1', name => 'user',   label => 'Basic User' },
            { roles_id => '2', name => 'admin',  label => 'Admin User' },
            { roles_id => '3', name => 'editor', label => 'Editor' },
        ]
    );

    lives_ok( sub { $admin1 = $self->users->find( { username => 'admin1' } ) },
        "grab admin1 user from fixtures" );

    lives_ok( sub { $admin2 = $self->users->find( { username => 'admin2' } ) },
        "grab admin2 user from fixtures" );

    foreach my $i ( 1 .. 3 ) {
        lives_ok( sub { $admin1->add_to_user_roles( { roles_id => $i } ) },
            "add roles_id $i to admin1" );
    }

    foreach my $i ( 1, 3 ) {
        lives_ok( sub { $admin2->add_to_user_roles( { roles_id => $i } ) },
            "add roles_id $i to admin2" );
    }

    # count via m2m
    cmp_ok( $admin1->roles->count, '==', 3, "admin1 has 3 roles" );
    cmp_ok( $admin2->roles->count, '==', 2, "admin2 has 2 roles" );

    # test reverse relationship
  SKIP: {
        skip "user is a reserved word in Pg so joins against User fail", 1
          if $self->schema->storage->sqlt_type eq 'PostgreSQL';

        my %users_expected = (
            1 => { count => 2 },
            2 => { count => 1 },
            3 => { count => 2 },
        );

        my $roles_iter = $self->schema->resultset('Role')->search;

        while ( my $role = $roles_iter->next ) {
            my $count    = $role->users->count;
            my $expected = $users_expected{ $role->id }->{count};

            cmp_ok( $count, '==', $expected,
                "Test user count for role " . $role->name );
        }
    }

};

1;
