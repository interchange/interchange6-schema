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
    my $self = shift;

    use_ok 'Interchange6::Schema::Result::Message';

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

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/.*/, "fail message create empty data" );

    $data->{title} = "Message title";

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/.*/, "fail message missing required field" );

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

        throws_ok( sub { $result = $rset_message->create($data) },
            qr/.*/, "fail with uri > 255 chars" );
        cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );
    }

    $data->{uri} = "some-nice-uri-for-this-message";

    lives_ok( sub { $result = $rset_message->create($data) }, "Add uri" );

    cmp_ok( $rset_message->count, '==', 1, "We have one message" );
    lives_ok( sub { $result->delete }, "delete message" );
    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

    $data->{author} = 333333;

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/.*/, "FK error with bad user" );

    delete $data->{author};

    $data->{approved_by} = 333333;

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/.*/, "FK error with bad approved_by" );

    delete $data->{approved_by};

    $data->{author}      = $author;
    $data->{approved_by} = $approver;

    lives_ok( sub { $result = $rset_message->create($data) },
        "add good author and approved_by" );

    cmp_ok( $rset_message->count, '==', 1, "We have one message" );

    cmp_ok( $result->author->id, '==', $author->id, "has correct author" );

    cmp_ok( $result->approved_by->id,
        '==', $approver->id, "has correct approver" );

    my $dt = DateTime->now;
    cmp_ok( $result->created,       '<=', $dt, "created is <= now" );
    cmp_ok( $result->last_modified, '<=', $dt, "last_modified is <= now" );

    $dt->subtract( minutes => 2 );
    cmp_ok( $result->created,       '>=', $dt, "created in last 2 mins" );
    cmp_ok( $result->last_modified, '>=', $dt, "last_modified in last 2 mins" );

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

test 'order comments tests' => sub {
    my $self = shift;

    use_ok 'Interchange6::Schema::Result::OrderComment';

    my $schema = $self->schema;

    my ( $user, $address, $order, $data, $result, $rset );

    # first we need an adddress and order that we can attach comments to

    my $dt = DateTime->now;

    lives_ok(
        sub {
            $user =
              $schema->resultset('User')
              ->search( { username => 'author' }, { rows => 1 } )->single;
        },
        "select author from User"
    );

    $data = {
        users_id         => $user->id,
        country_iso_code => 'MT',
    };

    lives_ok( sub { $address = $schema->resultset('Address')->create($data) },
        "Create address" );

    $data = {
        order_number          => '1234',
        order_date            => $dt,
        users_id              => $user->id,
        email                 => $user->email,
        shipping_addresses_id => $address->id,
        billing_addresses_id  => $address->id,
    };

    lives_ok( sub { $order = $schema->resultset('Order')->create($data) },
        "Create order" );

    cmp_ok( $schema->resultset('Order')->count, "==", 1, "We have 1 order" );

    $data = {
        title   => "Initial order comment",
        content => "Please deliver to my neighbour if I am not at home",
        author  => $user->id,
    };

    lives_ok( sub { $result = $schema->resultset('Message')->create($data) },
        "create message" );

    lives_ok( sub { $result = $order->add_to_comments($result) },
        "Add message (comment) to order" );

    isa_ok( $result, "Interchange6::Schema::Result::Message" );

    lives_ok(
        sub {
            $result = $order->add_to_comments(
                { title => "order response", content => "OK will do!" } );
        },
        "Add another message"
    );

    isa_ok( $result, "Interchange6::Schema::Result::Message" );

    $rset = $order->comments;

    while ( my $comment = $rset->next ) {
    }
    lives_ok( sub { $rset = $order->search_related("order_comments") },
        "Search for comments on order" );

    cmp_ok( $rset->count, "==", 2, "Found 2 order comments" );

    lives_ok( sub { $order->delete }, "Delete order" );

    cmp_ok( $schema->resultset("Order")->count, "==", 0, "Zero orders" );

    cmp_ok( $schema->resultset("OrderComment")->count,
        "==", 0, "Zero order comments" );

    cmp_ok( $schema->resultset("Message")->count, "==", 0, "Zero messages" );
};

1;
