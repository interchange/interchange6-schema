use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 5;
use Try::Tiny;
use DBICx::TestDatabase;

my $count;

my $shop_schema = DBICx::TestDatabase->new('Interchange6::Schema');

my $user_rs = $shop_schema->resultset('User');

# create user
my $user_data = {username => 'nevairbe@nitesi.de',
                 email => 'nevairbe@nitesi.de',
                 password => 'nevairbe',
                 users_id =>'20'};

my $user = $user_rs->create($user_data);

# add attribute attibute value relationship
$user->add_attribute('hair_color', 'blond');

my $hair_color = $user->find_attribute_value('hair_color');

ok($hair_color eq 'blond', "Testing AttributeValue.")
    || diag "hair_color: " . $hair_color;

# change user attribute_value
$user->update_attribute('hair_color', 'red');

$hair_color = $user->find_attribute_value('hair_color');

ok($hair_color eq 'red', "Testing AttributeValue.")
    || diag "hair_color: " . $hair_color;

# change attribute_value
$user->add_attribute('fb_token', '10A');
$user->update_attribute_value('fb_token', '20B');

my $fb_token = $user->find_attribute_value('fb_token');

ok($fb_token eq '20B', "Testing AttributeValue.")
    || diag "fb_token: " . $fb_token;

# use find_attribute_value object

my $av_object = $user->find_attribute_value('fb_token', {object => 1});

$av_object->update({'value' => '30B'});

$fb_token = $user->find_attribute_value('fb_token');

ok($fb_token eq '30B', "Testing AttributeValue.")
    || diag "fb_token: " . $fb_token;

# delete user attribute
$user->delete_attribute('hair_color', 'red');

my $del = $user->search_related('UserAttribute')->search_related('UserAttributeValue');

ok($del->count eq '1', "Testing UserAttributeValue count.")
    || diag "UserAttributeValue count: " . $del->count;


