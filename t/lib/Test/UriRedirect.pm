package Test::UriRedirect;

use Test::Exception;
use Test::Roo::Role;

use DateTime;

test 'uri_redirects tests' => sub {

    diag 'Test::UriRedirect';

    my $self = shift;
    my ($nav, $uri_redirect);
    my $schema = $self->ic6s_schema;

    # pop nav from fixtures

    $nav = $self->navigation->find( { uri => 'hand-tools/hammers' } ); 

    lives_ok(
        sub {
            $uri_redirect = $schema->resultset("UriRedirect")->create(
                {
                    uri_source           => 'my_bad_uri',
                    uri_target           => $nav->uri
                }
            );
        },
        "Create Uri 300 Redirect my_bad_uri -> hand-tools/hammers"
    );

    cmp_ok( $self->uri_redirects->find({ uri_source => 'my_bad_uri' })->status_code,
        '==', 301, "301 default uri_redirect status_code" );

    lives_ok(
        sub {
            $uri_redirect = $self->uri_redirects->find( { uri_source => 'bad_uri_1' } );
        },
        "find uri_redirect uri_source bad_uri_1 from fixtures"
    );

    # 3 records from fixtures
    cmp_ok( $schema->resultset('UriRedirect')->count,
        '==', 4, "4 uri redirects" );

    # cleanup
    $self->clear_uri_redirects;

    cmp_ok( $schema->resultset('UriRedirect')->count,
        '==', 0, "0 UriRedirect rows" );

};

1;
