package Test::Expire;

use Test::MockTime qw(:all);
use Test::Most;
use Test::Roo::Role;

test 'expire tests' => sub {
    my $self = shift;

    my ( $ret, $rset, $session );

    my $schema = $self->schema;

    # put clock back one minute whilst we add items to database
    set_relative_time(-600);

    # create product
    my %data = (
        sku   => 'BN004',
        name  => 'Walnut Extra',
        price => 12
    );

    my $product = $schema->resultset('Product')->create( \%data );

    isa_ok( $product, 'Interchange6::Schema::Result::Product' )
      || diag "Create result: $product.";

    ok( $product->id eq 'BN004', "Testing product id." )
      || diag "Product id: " . $product->id;

    # create user
    my $user = $schema->resultset('User')->create(
        {
            username => 'nevairbe@nitesi.de',
            email    => 'nevairbe@nitesi.de',
            password => 'nevairbe'
        }
    );

    isa_ok( $user, 'Interchange6::Schema::Result::User' )
      || diag "Create result: $user.";

    ok( $user->id == 1, "Testing user id." )
      || diag "User id: " . $user->id;

    # create sessions
    my @pop_session =
      ( [ '6182808', 'Green Banana' ], [ '9999999', 'Red Banana' ] );

    $ret = $schema->populate( 'Session',
        [ [ 'sessions_id', 'session_data' ], @pop_session, ] );

    my $rs = $schema->resultset('Session');

    ok( $rs->count eq '2', "Testing session count." )
      || diag "Session count: " . $rs->count;

    # create carts
    my @pop_cart = (
        [ '1', 'main', '1',   '6182808', undef ],
        [ '2', 'main', undef, '9999999', undef ]
    );

    $ret = $schema->populate(
        'Cart',
        [
            [ 'carts_id', 'name', 'users_id', 'sessions_id', 'approved' ],
            @pop_cart,
        ]
    );

    my $rs_cart = $schema->resultset('Cart');

    ok( $rs_cart->count eq '2', "Testing cart count." )
      || diag "Cart count: " . $rs_cart->count;

    # create CartProduct
    my @pop_prod = ( [ '1', 'BN004', '1', '1' ], [ '2', 'BN004', '1', '12' ] );

    # populate CartProduct
    $ret = $schema->populate( 'CartProduct',
        [ [ 'carts_id', 'sku', 'cart_position', 'quantity' ], @pop_prod, ] );

    my $rs_prod = $schema->resultset('Cart');

    ok( $rs_prod->count eq '2', "Testing cart count." )
      || diag "CartProduct count: " . $rs_prod->count;

    # reset time
    restore_time();

    throws_ok(
        sub { $schema->resultset('Session')->expire() },
        qr/Session expiration not set/,
        "Fail on undef arg to expire"
    );

    throws_ok(
        sub { $schema->resultset('Session')->expire('bananas') },
        qr/Unknown timespec: bananas/,
        "Fail on bad scalar arg to expire"
    );

    # find expired sessions and delete them
    lives_ok( sub { $schema->resultset('Session')->expire('1 second') },
        "Expire with arg '1 second'" );

    # test for expired sessions
    $rs = $schema->resultset('Session');
    ok( $rs->count eq '0', "Testing sessions count." )
      || diag "Sessions count: " . $rs->count;

    # test remaining carts
    my $carts = $schema->resultset('Cart');
    ok( $carts->count() eq '1', "Testing cart count." )
      || diag "Cart count: " . $carts->count();

    while ( my $carts_rs = $carts->next ) {
        is( $carts_rs->sessions_id, undef, "undefined as expected" );
    }

    # reset time and create session
    set_relative_time(-600);
    lives_ok(
        sub {
            $session = $schema->resultset('Session')->create(
                {
                    sessions_id  => '12345',
                    session_data => 'Yellow banana'
                }
            );
        },
        "Create new session"
    );

    lives_ok( sub { $rset = $schema->resultset('Session')->search( {} ) },
        "Search for session in DB" );

    cmp_ok( $rset->count, '==', 1, "1 session found" );
    $session = $rset->next;

    lives_ok( sub { $rset = $schema->resultset('Cart')->search( {} ) },
        'Find carts' );

    lives_ok(
        sub { $rset->next->update( { sessions_id => $session->sessions_id } ) },
        "Attach active session to first cart"
    );

    lives_ok(
        sub {
            $rset = $schema->resultset('Cart')
              ->search( { sessions_id => { '!=', undef } } );
        },
        "Find carts where sessions_id is not undef"
    );

    cmp_ok( $rset->count, '==', 1, "found 1" );

    # reset time
    restore_time();

    lives_ok( sub { $schema->resultset('Session')->expire('1') },
        "Expire with arg '1'" );

    lives_ok(
        sub {
            $rset = $schema->resultset('Cart')
              ->search( { sessions_id => { '!=', undef } } );
        },
        "Find carts where sessions_id is not undef"
    );

    cmp_ok( $rset->count, '==', 0, "found 0" );

    # test for expired sessions
    $rs = $schema->resultset('Session');
    ok( $rs->count eq '0', "Testing sessions count." )
      || diag "Sessions count: " . $rs->count;

};

1;
