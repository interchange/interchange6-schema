package Test::Message;

use DateTime;
use Test::Deep;
use Test::Exception;
use Test::More;
use Test::Roo::Role;

use Data::Dumper::Concise;

test 'create users' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    lives_ok(
        sub {
            $schema->resultset('User')->create(
                {
                    username => 'author',
                    email    => 'author@example.com',
                    password => 'badpassword',
                }
            );
        },
        "Create author"
    );

    lives_ok(
        sub {
            $schema->resultset('User')->create(
                {
                    username => 'approver',
                    email    => 'approver@example.com',
                    password => 'aSl1ghtlyB3tterp@SSw0rd',
                }
            );
        },
        "Create approver"
    );

    cmp_ok( $schema->resultset('User')->count, '==', 2, "We have 2 users" );
};

test 'simple message tests' => sub {
    my $self   = shift;
    my $schema = $self->schema;

    my ( $data, $result );

    my $rset_message = $schema->resultset('Message');
    my $rset_user    = $schema->resultset('User');

    my $author =
      $rset_user->search( { username => 'author' }, { rows => 1 } )->single;
    my $approver =
      $rset_user->search( { username => 'approver' }, { rows => 1 } )->single;

    $data = {};

    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

    throws_ok(
        sub { $result = $rset_message->create($data) },
        qr/doesn't have a default|not be null|null value in column/i,
        "fail message create empty data"
    );

    $data->{title} = "Message title";

    throws_ok(
        sub { $result = $rset_message->create($data) },
        qr/doesn't have a default|not be null|null value in column/i,
        "fail message missing required field"
    );

    $data->{content} = "Message content";

    lives_ok( sub { $result = $rset_message->create($data) },
        "Message OK with title and content" );

    cmp_ok( $rset_message->count, '==', 1, "We have one message" );
    lives_ok( sub { $result->delete }, "delete message" );
    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

  SKIP: {
        skip "SQLite does not check varchar length", 1
          if $schema->storage->sqlt_type eq "SQLite";

        $data->{uri} = "x" x 300;

        throws_ok(
            sub { $result = $rset_message->create($data) },
            qr/too long for (column 'uri'|type character varying)/i,
            "fail with uri > 255 chars"
        );
        cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );
    }

    $data->{uri} = "some-nice-uri-for-this-message";

    lives_ok( sub { $result = $rset_message->create($data) }, "Add uri" );

    cmp_ok( $rset_message->count, '==', 1, "We have one message" );
    lives_ok( sub { $result->delete }, "delete message" );
    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

    $data->{author} = 333333;

    throws_ok(
        sub { $result = $rset_message->create($data) },
        qr/foreign key constraint/,
        "FK error with bad user"
    );

    delete $data->{author};

    $data->{approved_by} = 333333;

    throws_ok(
        sub { $result = $rset_message->create($data) },
        qr/foreign key constraint/,
        "FK error with bad approved_by"
    );

    delete $data->{approved_by};

    $data->{author}      = $author;
    $data->{approved_by} = $approver;

    lives_ok( sub { $result = $rset_message->create($data) },
        "add good author and approved_by" );

    cmp_ok( $rset_message->count, '==', 1, "We have one message" );

    cmp_ok( $result->author->id, '==', $author->id, "has correct author" );

    cmp_ok( $result->approved_by->id,
        '==', $approver->id, "has correct approver" );

    cmp_deeply(
        $result,
        methods(
            title   => "Message title",
            uri     => "some-nice-uri-for-this-message",
            content => "Message content",
        ),
        "title, uri & content OK"
    );

    lives_ok( sub { $result->delete }, "delete message" );
    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );
};

1;
