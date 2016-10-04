package Test::EmailAddress;

use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'email address tests' => sub {

    my $self = shift;

    # make sure there is no mess
    $self->clear_users;
    $self->users;

    my $schema = $self->ic6s_schema;

    my $user1 = $self->users->find( { username => 'customer1' } );
    my $user2 = $self->users->find( { username => 'customer2' } );

    isa_ok $user1, 'Interchange6::Schema::Result::User', 'user1';
    isa_ok $user2, 'Interchange6::Schema::Result::User', 'user2';

    my $email_rset = $schema->resultset('EmailAddress');

    my $email;

    lives_ok {
        $email = $email_rset->create(
            { email => 'DaveBean@example.com', users_id => $user1->id } ),
    }
    'Create with email DaveBean@example.com lives';

    $email->discard_changes;    # get defaults from DB

    cmp_ok $email->email, 'eq', 'davebean@example.com', 'email is lowercase';
    cmp_ok $email->header_to, 'eq', 'davebean@example.com',
      'header_to has been set';
    cmp_ok $email->type, 'eq', '', 'type is empty string';
    ok $email->active, 'active is true';
    ok !$email->validated, 'validated is false';

    throws_ok {
        $email = $email_rset->create(
            { email => 'DaveBean@example.com', users_id => $user2->id } ),
    }
    qr/Exception/, 'Cannot create DaveBean@example.com a second time';

    lives_ok {
        $email = $email_rset->create(
            {
                email     => 'BeerDrinker@example.com',
                users_id  => $user1->id,
                header_to => 'Beer Drinker <BeerDrinker@example.com>'
            }
          ),
    }
    'Create with email BeerDrinker@example.com plus header_to lives';

    cmp_ok $email->email, 'eq', 'beerdrinker@example.com', 'email is lowercase';
    cmp_ok $email->header_to, 'eq', 'Beer Drinker <BeerDrinker@example.com>',
      'header_to is correct';

    lives_ok { $email->email('CiderDrinker@example.com') }
    'change email attribute to CiderDrinker@example.com lives';

    cmp_ok $email->email, 'eq', 'CiderDrinker@example.com',
      'email is not lowercase';

    lives_ok { $email->update } "Now call update which should live";

    cmp_ok $email->email, 'eq', 'ciderdrinker@example.com',
      '... and email is now lowercase';

    lives_ok { $email->discard_changes } "force reload from DB";

    cmp_ok $email->email, 'eq', 'ciderdrinker@example.com',
      '... and email is still lowercase';

    lives_ok { $email->update( { email => 'BeerDrinker@example.com' } ) }
    'Change email to BeerDrinker@example.com directly via update method lives';

    cmp_ok $email->email, 'eq', 'beerdrinker@example.com', 'email is lowercase';

    lives_ok { $email->discard_changes } "force reload from DB";

    cmp_ok $email->email, 'eq', 'beerdrinker@example.com',
      '... and email is still lowercase';

    lives_ok {
        $email = $email_rset->create(
            {
                email     => 'CiderDrinker@example.com',
                users_id  => $user2->id,
            }
          ),
    }
    'Create email for users with email CiderDrinker@example.com';

    throws_ok {
        $email->update({ email => 'BeerDrinker@example.com' })
    }
    qr/Exception/,
    '...then trying to change email to BeerDrinker@example.com dies';

};

1;
