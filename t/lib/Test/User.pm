package Test::User;

use Test::Exception;
use Test::More;
use Try::Tiny;
use Test::Roo::Role;

test 'simple user tests' => sub {

    diag Test::User;

    my $self = shift;

    # make sure there is no mess
    $self->clear_users;

    my $rset_user = $self->schema->resultset('User');

    my ( $data, $result );

    throws_ok( sub { $rset_user->create({}) },
        qr/username cannot be unde/,
        "fail User create with empty hashref" );

    throws_ok( sub { $rset_user->create({ username => undef }) },
        qr/username cannot be unde/,
        "fail User create with undef username" );

    throws_ok( sub { $rset_user->create({ username => 'MixedCase' }) },
        qr/username must be lowercase/,
        "fail User create with mixed case username" );

    throws_ok( sub { $rset_user->create({ username => '' }) },
        qr/username cannot be empty string/,
        "fail User create with empty string username" );

    lives_ok( sub {
            $result = $rset_user->create({ username => 'nevairbe@nitesi.de' })
        }, "create user" );

    throws_ok( sub { $rset_user->create({ username => 'nevairbe@nitesi.de' }) },
        qr/DBI Exception/i,
        "fail to create duplicate username" );

    throws_ok( sub { $result->update({ username => 'MixedCase' }) },
        qr/username must be lowercase/,
        "Fail to change username to mixed case" );

    lives_ok( sub { $result->delete }, "delete user" );

    cmp_ok( $rset_user->count, '==', 0, "zero User rows" );

    $data = {
        username => 'nevairbe@nitesi.de',
        email    => 'nevairbe@nitesi.de',
        password => 'nevairbe',
    };

    lives_ok( sub { $result = $rset_user->create($data) }, "create user" );

    like( $result->password, qr/^\$2a\$14\$.{53}$/,
        "Check password hash has correct format" );

    # cleanup
    $self->clear_users;
};

test 'user attribute tests' => sub {

    my $self = shift;

    my $count;

    my $user = $self->users->first;

    # add attribute attibute value relationship
    $user->add_attribute( 'hair_color', 'blond' );

    my $hair_color = $user->find_attribute_value('hair_color');

    ok( $hair_color eq 'blond', "Testing AttributeValue." )
      || diag "hair_color: " . $hair_color;

    # change user attribute_value
    $user->update_attribute_value( 'hair_color', 'red' );

    $hair_color = $user->find_attribute_value('hair_color');

    ok( $hair_color eq 'red', "Testing AttributeValue." )
      || diag "hair_color: " . $hair_color;

    # use find_attribute_value object
    $user->add_attribute( 'fb_token', '10A' );
    my $av_object = $user->find_attribute_value( 'fb_token', { object => 1 } );

    my $fb_token = $av_object->value;

    ok( $fb_token eq '10A', "Testing AttributeValue." )
      || diag "fb_token: " . $fb_token;

    # delete user attribute
    $user->delete_attribute( 'hair_color', 'red' );

    my $del = $user->search_related('user_attributes')
      ->search_related('user_attribute_values');

    ok( $del->count eq '1', "Testing user_attribute_values count." )
      || diag "user_attribute_values count: " . $del->count;

    # return all attributes for $user with search_attributes method
    $user->add_attribute( 'favorite_color', 'green' );
    $user->add_attribute( 'first_car',      '64 Mustang' );

    my $attr = $user->search_attributes;

    ok( $attr->count eq '3', "Testing User Attribute count." )
      || diag "User Attribute count: " . $del->count;

    # cleanup
    lives_ok(
        sub { $user->user_attributes->delete_all },
        "delete_all on user->user_attributes"
    );
};

test 'user role tests' => sub {

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

    # cleanup
    $self->clear_users;
};

1;
