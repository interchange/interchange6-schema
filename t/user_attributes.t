use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 4;
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

my $new_user = $user_rs->create($user_data);

my $user = $user_rs->find( $new_user->id );

# add attribute attibute value relationship
my $new_attr = $user->add_attribute('hair_color', 'blond');

my $attr_rs = $shop_schema->resultset('Attribute');

my $attr = $attr_rs->find({name => 'hair_color'});

my $attr_value = $attr->find_related('AttributeValue', {value => 'blond'});

ok($attr_value->id eq '1', "Testing AttributeValue.")
    || diag "AttributeValue id: " . $attr_value->id;

# change attribute
$new_attr = $user->update_attribute('hair_color', 'red');

$attr_value = $attr->find_related('AttributeValue', {value => 'red'});

ok($attr_value->id eq '2', "Testing AttributeValue.")
    || diag "AttributeValue id: " . $attr_value->id;

# check for user attribute value
my $user_attr = $user->find_related('UserAttribute',
                                            {attributes_id => $attr->id});

my $user_attr_value = $user_attr->find_related('UserAttributeValue',
                                            {user_attributes_id => $user_attr->id});

ok($user_attr_value->attribute_values_id eq '2', "Testing UserAttributeValue.")
    || diag "AttributeValue id: " . $user_attr_value->attribute_values_id;

$user->delete_attribute('hair_color', 'red');

my $del = $user_rs->search_related('UserAttribute')->search_related('UserAttributeValue');

ok($del->count eq '0', "Testing UserAttributeValue count.")
    || diag "UserAttributeValue count: " . $del->count;

