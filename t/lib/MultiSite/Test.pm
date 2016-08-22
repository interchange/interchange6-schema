package MultiSite::Test;

use Test::Roo::Role;
use Test::More;
use Class::ISA;

test one => sub {
    my $self = shift;
    my $schema = $self->ic6s_schema;

    my $rset = $schema->resultset('Website')->rand;
    my $result = $rset->single;

    ok 1;
};

1;
