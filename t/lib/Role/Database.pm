package Role::Database;

use Test::More;
use Test::Roo::Role;

requires qw(_build_database _build_dbd_version);

has database => (
    is      => 'lazy',
    clearer => 1,
);

has dbd_version => (
    is => 'lazy',
);

before setup => sub {
    my $self = shift;
    diag "Testing with " . $self->dbd_version;
};

1;
