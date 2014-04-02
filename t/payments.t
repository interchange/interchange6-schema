use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 1;

use Interchange6::Schema;
use DBICx::TestDatabase;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my %insertion = (
                 payment_mode => 'PayPal',
                 payment_action => 'charge',
                 status => 'request',
                 sessions_id => '123412341234',
                 amount => '10.00',
                 payment_fee => 1.00,
                 users_id => '11',
                );

my $payment = $schema->resultset('PaymentOrder')->create(\%insertion);

ok ($payment->payment_fee == 1);



