package Test::Message;

use DateTime;
use Test::Deep;
use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'simple message tests' => sub {

    diag Test::Message;

    my $self = shift;

    # fixtures
    $self->message_types;

    my $schema = $self->schema;

    my ( $data, $result );

    my $rset_message = $schema->resultset('Message');

    my $author   = $self->users->find( { username => 'customer1' } );
    my $approver = $self->users->find( { username => 'admin1' } );

    $data = {};

    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/.*/, "fail message create empty data" );

    $data->{title} = "Message title";

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/.*/, "fail message missing required field" );

    $data->{content} = "Message content";
    $data->{type} = "blog_post";

    lives_ok( sub { $result = $rset_message->create($data) },
        "Message OK with title, content and type" );

    cmp_ok( $rset_message->count, '==', 1, "We have one message" );
    lives_ok( sub { $result->delete }, "delete message" );
    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

    lives_ok( sub { $result = $schema->resultset('MessageType')->find({
                    name => 'blog_post' })}, "find blog_post MessageType" );

    ok( $result->active, "blog_post type is active" );

    lives_ok( sub { $result->update({ active => 0 }) }, "change to inactive" );

    ok( !$result->active, "blog_post type is not active" );

    throws_ok( sub { $result = $rset_message->create($data) },
        qr/"blog_post" is not active/,
        "fail to create blog_post" );

    cmp_ok( $rset_message->count, '==', 0, "We have zero messages" );

    lives_ok( sub { $result->update({ active => 1 }) }, "change to active" );


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

    # fixtures
    $self->addresses;
    $self->message_types;

    my $schema = $self->schema;

    my ( $user, $billing_address, $shipping_address, $order, $data, $result,
        $rset );

    # first we need an adddress and order that we can attach comments to

    my $dt = DateTime->now;

    lives_ok( sub { $user = $self->users->find( { username => 'customer1' } ) },
        "select author from User" );

    lives_ok(
        sub {
            $billing_address =
              $user->search_related( 'addresses', { type => 'billing' } )
              ->first;
        },
        "Find billing address"
    );

    lives_ok(
        sub {
            $shipping_address =
              $user->search_related( 'addresses', { type => 'shipping' } )
              ->first;
        },
        "Find shipping address"
    );

    $data = {
        order_number          => '1234',
        order_date            => $dt,
        users_id              => $user->id,
        email                 => $user->email,
        shipping_addresses_id => $shipping_address->id,
        billing_addresses_id  => $billing_address->id,
    };

    lives_ok( sub { $order = $schema->resultset('Order')->create($data) },
        "Create order" );

    cmp_ok( $schema->resultset('Order')->count, "==", 1, "We have 1 order" );

    $data = {
        title   => "Initial order comment",
        content => "Please deliver to my neighbour if I am not at home",
        author  => $user->id,
    };

    lives_ok( sub { $result = $order->add_to_comments($data) },
        "Add comment to order" );

    isa_ok( $result, "Interchange6::Schema::Result::Message" );

    lives_ok(
        sub {
            $result = $order->add_to_comments(
                { title => "order response", content => "OK will do!" } );
        },
        "Add another message"
    );

    isa_ok( $result, "Interchange6::Schema::Result::Message" );

    $rset = $order->order_comments;

    lives_ok( sub { $rset = $order->search_related("order_comments") },
        "Search for comments on order" );

    cmp_ok( $rset->count, "==", 2, "Found 2 order comments" );

    lives_ok( sub { $result = $schema->resultset('MessageType')->find({
                    name => 'order_comment' })}, "find order_comment MessageType" );

    ok( $result->active, "order_comment type is active" );

    lives_ok( sub { $result->update({ active => 0 }) }, "change to inactive" );

    ok( !$result->active, "order_comment type is not active" );

    lives_ok( sub { $rset = $order->search_related("order_comments") },
        "Search for comments on order" );

    cmp_ok( $rset->count, "==", 2, "Found 2 order comments" );

    throws_ok(
        sub {
            $result = $order->add_to_comments(
                { title => "order response", content => "frizzzzz" } );
        },
        qr/"order_comment" is not active/,
        "fail to create order_comment" );

    lives_ok( sub { $result->update({ active => 1 }) }, "change to active" );

    lives_ok( sub { $order->delete }, "Delete order" );

    cmp_ok( $schema->resultset("Order")->count, "==", 0, "Zero orders" );

    cmp_ok( $schema->resultset("OrderComment")->count,
        "==", 0, "Zero order comments" );

    cmp_ok( $schema->resultset("Message")->count, "==", 0, "Zero messages" );

    # now make use of convenience accessors in ::Base::Message

    $data = {
        order_number          => '1234',
        order_date            => $dt,
        users_id              => $user->id,
        email                 => $user->email,
        shipping_addresses_id => $shipping_address->id,
        billing_addresses_id  => $billing_address->id,
        order_comments        => [
            {
                message => {
                    title => "Initial order comment",
                    content =>
                      "Please deliver to my neighbour if I am not at home",
                    author => $user->id,
                    type   => 'order_comment',
                }
            }
        ],
    };

    lives_ok( sub { $order = $schema->resultset('Order')->create($data) },
        "Create order" );

    cmp_ok( $schema->resultset('Order')->count, "==", 1, "We have 1 order" );

    lives_ok( sub { $rset = $order->comments }, "get comments via m2m" );

    cmp_ok( $rset->count, "==", 1, "We have 1 comment" );

    $result = $rset->first;

    isa_ok( $result, 'Interchange6::Schema::Result::Message' );

    cmp_ok( $result->title, 'eq', "Initial order comment", "check title" );

    lives_ok( sub { $result->title("New title") }, "Change title" );

    cmp_ok( $result->title, 'eq', "New title", "check title" );

    lives_ok( sub { $result->update }, "call update on Message" );

    lives_ok( sub { $rset = $order->comments }, "Reload comments from DB" );

    lives_ok( sub { $result = $rset->first }, "Get first result" );

    cmp_ok( $result->title, 'eq', "New title", "check title" );

    lives_ok(
        sub {
            $result->update(
                { title => "changed again", content => "new content as well" }
            );
        },
        "update title and content via ->update(href) on Message"
    );

    lives_ok( sub { $rset = $order->comments }, "Reload comments from DB" );

    lives_ok( sub { $result = $rset->first }, "Get first result" );

    cmp_ok( $result->title,   'eq', "changed again",       "check title" );
    cmp_ok( $result->content, 'eq', "new content as well", "check content" );

    lives_ok( sub { $order->delete }, "Delete order" );

    cmp_ok( $schema->resultset("Order")->count, "==", 0, "Zero orders" );

    cmp_ok( $schema->resultset("OrderComment")->count,
        "==", 0, "Zero order comments" );

    cmp_ok( $schema->resultset("Message")->count, "==", 0, "Zero messages" );

};

test 'product reviews tests' => sub {
    my $self = shift;

    my ( $product, $variant, $author, $approver, $rset, $result );

    my $rset_message = $self->schema->resultset('Message');

    lives_ok(
        sub {
            $product =
              $self->products->search( { canonical_sku => undef } )->first;
        },
        "grab canonical product from fixtures"
    );

    isa_ok( $product, 'Interchange6::Schema::Result::Product', "product" );

    cmp_ok( $product->variants->count, '>=', 1, "product has variants" );

    lives_ok( sub { $variant = $product->variants->first }, "grab variant" );

    isa_ok( $variant, 'Interchange6::Schema::Result::Product', "variant" );

    lives_ok(
        sub { $author = $self->users->find( { username => 'customer1' } ) },
        "select author from User" );

    lives_ok(
        sub { $approver = $self->users->find( { username => 'admin1' } ) },
        "select approver from User" );

    lives_ok(
        sub {
            $rset_message->create(
                {
                    title   => "not a review",
                    content => "not a review",
                    author  => $author->id,
                    type    => "blog_post",
                }
            );
        },
        "Add non-review message"
    );

    lives_ok(
        sub {
            $result = $product->add_to_reviews(
                {
                    title   => "massive bananas",
                    content => "Love them",
                    author  => $author->id
                }
            );
        },
        "Add review to parent product"
    );

    cmp_ok( $product->reviews->count,  '==', 1, "parent has 1 reviews" );
    cmp_ok( $variant->reviews->count,  '==', 1, "variant has 1 reviews" );
    cmp_ok( $product->_reviews->count, '==', 1, "parent has 1 _reviews" );
    cmp_ok( $variant->_reviews->count, '==', 0, "variant has 0 _reviews" );

    lives_ok(
        sub {
            $result = $variant->add_to_reviews(
                { title => "cool bananas", content => "yellow" } );
        },
        "Add review to variant product"
    );

    cmp_ok( $product->reviews->count,  '==', 2, "parent has 2 reviews" );
    cmp_ok( $variant->reviews->count,  '==', 2, "variant has 2 reviews" );
    cmp_ok( $product->_reviews->count, '==', 2, "parent has 2 _reviews" );
    cmp_ok( $variant->_reviews->count, '==', 0, "variant has 0 _reviews" );

    cmp_ok( $self->schema->resultset('Message')->count,
        '==', 3, "3 Message rows" );

    lives_ok( sub { $rset = $author->reviews }, "grab reviews for author" );

    cmp_ok( $rset->count, '==', 1, "1 review" );

    lives_ok( sub { $result = $rset->next }, "grab review obj" );

    cmp_ok( $result->title, 'eq', 'massive bananas', "review title OK");

    lives_ok(
        sub { $product->variants->delete_all },
        "delete all variants of parent"
    );

    cmp_ok( $product->reviews->count, '==', 2, "parent has 2 reviews" );

    lives_ok( sub { $product->delete }, "delete parent" );

    cmp_ok( $self->schema->resultset('Message')->count,
        '==', 1, "1 Message row" );

    # cleanup
    $self->clear_products;
    $rset_message->delete_all;
};

1;
