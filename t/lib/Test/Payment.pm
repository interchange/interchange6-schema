package Test::Payment;

use Test::Exception;
use Test::More;
use Test::Roo::Role;

test 'payment tests' => sub {
    my $self = shift;

    my $schema = $self->schema;

    my %insertion = (
        payment_mode   => 'PayPal',
        payment_action => 'charge',
        status         => 'request',
        sessions_id    => '123412341234',
        amount         => '10.00',
        payment_fee    => 1.00,
        users_id       => '11',
    );

    my $payment;
    lives_ok(
        sub {
            $payment =
              $schema->resultset('PaymentOrder')->create( \%insertion );
        },
        "Insert payment into db"
    );

    ok( $payment->payment_fee == 1 );

};

1;
