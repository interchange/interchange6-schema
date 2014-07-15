package Test::UserAttribute;

use Test::More;
use Try::Tiny;
use Test::Roo::Role;

test 'user attribute tests' => sub {
    my $self = shift;

    my $count;

    my $shop_schema = $self->schema;

    my $user_rs = $shop_schema->resultset('User');

    # create user
    my $user_data = {
        username => 'nevairbe@nitesi.de',
        email    => 'nevairbe@nitesi.de',
        password => 'nevairbe',
        users_id => '20'
    };

    my $user = $user_rs->create($user_data);

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

};

1;
