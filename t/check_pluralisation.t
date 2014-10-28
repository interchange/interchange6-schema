#!perl

use Data::Dumper::Concise;
use Class::Load qw(try_load_class);
use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use DBD::SQLite;
use Test::Roo;
with 'Interchange6::Test::Role::SQLite';

sub BUILD {
    plan skip_all => "Author tests not required for installation"
      unless $ENV{PLURALISATION_TESTING};

    try_load_class("Lingua::EN::Inflect")
      or plan skip_all => "Lingua::EN::Inflect required";
    use Lingua::EN::Inflect qw( PL PL_N );

    try_load_class("String::CamelCase")
      or plan skip_all => "String::CamelCase required";
    use String::CamelCase qw( camelize decamelize );
}

test 'pluralisation' => sub {
    my $self = shift;

    my $schema = $self->schema;

    foreach my $source_name ( sort $schema->sources ) {

        my $source = $schema->source($source_name);

        my $decamelize = decamelize($source_name);
        my $plural     = PL($decamelize);

        my @primary_columns = $source->primary_columns;

        my $num_pk = scalar @primary_columns;
        if ( $num_pk == 0 ) {
            fail("$source_name has no primary columns");
        }
        elsif ( $num_pk == 1 && $primary_columns[0] =~ /_id$/ ) {
            cmp_ok(
                $primary_columns[0], 'eq',
                $plural . "_id",
                "PK col name is OK"
            );
        }
        elsif ( $num_pk > 2 ) {
            fail("$source_name has $num_pk primary columns");
        }
    }
};

run_me;

done_testing;
