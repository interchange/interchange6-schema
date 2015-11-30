package Test::Role::Websites;

use Test::Exception;
use Test::Roo::Role;

has websites => (
    is       => 'ro',
    default  => sub { [] },
    init_arg => undef,
);

my @currencies = ( 'EUR', 'USD', 'GBP', 'JPY' );

test 'create websites' => sub {
    my $self = shift;

    my $schema = $self->ic6s_schema;

    foreach my $i ( 0 .. 1 ) {
        my $website;

        # test hash and hashref forms of create_website
        if ( $i % 2 ) {
            lives_ok {
                $website = $schema->create_website(
                    name        => "shop$i",
                    description => "Test Shop $i",
                    admin       => "shop${i}admin\@example.com",
                    currency    => $currencies[$i]
                );
            }
            "Create shop$i using hash";
        }
        else {
            lives_ok {
                $website = $schema->create_website(
                    {
                        name        => "shop$i",
                        description => "Test Shop $i",
                        admin       => "admin",
                        currency    => $currencies[$i]
                    }
                );
            }
            "Create shop$i using hashref";
        }
        push @{ $self->websites }, $website;

        my $settings = $website->settings->search(
            { scope => 'global', name => 'currency' } );

        cmp_ok($settings->count, '==', 1, 'found 1 currency setting');

        my $currency = $currencies[$i];

        cmp_ok( $settings->first->value,
            'eq', $currency, "currency is $currency" );

        # clear out some rows that will be replaced by test fixtures
        $self->ic6s_schema->resultset('User')->delete;
        $self->ic6s_schema->resultset('Role')->delete;
    }
};

1;
