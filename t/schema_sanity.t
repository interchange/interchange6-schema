#!perl

use Data::Dumper::Concise;
use File::Spec;
use lib File::Spec->catdir( 't', 'lib' );

use Test::Deep;
use Test::Roo;
with 'Interchange6::Test::Role::SQLite';

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use Module::Path";
plan skip_all => "Module::Path required" if $@;

eval "use Pod::POM";
plan skip_all => "Pod::POM required" if $@;

test 'schema_sanity' => sub {
    my $self = shift;

    my $schema = $self->ic6s_schema;

    foreach my $source_name ( sort $schema->sources ) {

        my $source = $schema->source($source_name);

        # extract pod

        my %pod;

        my $file   = Module::Path::module_path( $source->result_class );
        my $parser = Pod::POM->new;
        my $pom    = $parser->parse_file($file);
        ok( $pom, "Pod::POM parser created for $source_name" )
          or diag $parser->error();

        foreach my $head1 ( @{ $pom->head1 } ) {
            if ( $head1->title eq 'ACCESSORS' ) {

                # columns

                foreach my $head2 ( @{ $head1->content } ) {

                    my $title = $head2->title;

                    foreach my $node ( @{ $head2->content } ) {
                        foreach my $line ( split( /\n/, $node->text ) ) {

                            next
                              unless $line =~
                              /^\s+(\S.*?):\s*[\"\']?(\S.*?)[\"\']?\s*$/;

                            my ( $key, $value ) = ( $1, $2 );

                            $value =~ s/.*empty string.*//;

                            if ( $value =~ /\[.+\]/ ) {
                                $value = eval $value;
                            }
                            elsif ( $value =~ /\{.+\}/ ) {
                                $value = eval $value;
                            }

                            $value = undef if $value =~ /undef/;

                            $pod{columns}{$title}{$key} = $value;
                        }
                    }
                }
            }
            elsif ( $head1->title =~ /^RELATIONS/ ) {

                # relationships

                foreach my $head2 ( @{ $head1->content } ) {

                    my $title = $head2->title;

                    foreach my $node ( @{ $head2->content } ) {
                        if (
                            $node->text =~ /(belongs_to|has_many|might_have
                                |has_one|many_to_many)/x
                          )
                        {
                            $pod{relations}{$title}{type} = $1;
                        }
                    }
                    unless ( defined $pod{relations}{$title}{type} ) {
                        fail(   "cannot determine relation type in pod for "
                              . "$source_name $title" );
                    }
                    delete $pod{relations}{$title}
                      if $pod{relations}{$title}{type} eq 'many_to_many';
                }
            }
        }

        ok( defined $pod{columns},
            "found pod head1 ACCESSORS for $source_name" );

        my $columns_info = $source->columns_info;

        # check columns

        foreach my $column ( sort keys %$columns_info ) {

            my $data_type = $columns_info->{$column}->{data_type};
            my $size      = $columns_info->{$column}->{size};

            # created/last_modified

            if ( $column =~ /^(created|last_modified)$/ ) {
                ok(
                    defined $columns_info->{$column}
                      ->{dynamic_default_on_create},
                    "set_on_create exists for $source_name $column"
                );

                if ( $column eq 'last_modified' ) {
                    ok(
                        defined $columns_info->{$column}
                          ->{dynamic_default_on_update},
                        "set_on_update exists for $source_name $column"
                    );
                }
            }

            # auto_increment

            if ( $columns_info->{$column}->{is_auto_increment} ) {
                ok(
                    defined $data_type && $data_type eq 'integer',
                    "$source_name $column has integer auto_increment col"
                );
            }

            # data_type specific checks

            if ( $data_type =~ /^(integer|text)$/ ) {

                # nothing to see
            }
            elsif ( $data_type eq 'boolean' ) {
                my $default_value = $columns_info->{$column}->{default_value};
                if ( defined $default_value ) {
                    fail "$source_name $column "
                      . "default_value for boolean should be 0 or 1"
                      unless $default_value =~ /^[01]$/;
                }
            }
            elsif ( $data_type =~ /^(var)*char$/ ) {
                ok( defined $size, "size is defined for $source_name $column" )
                  && cmp_ok( $size, '>=', 1,
                    "size >= 1 for $source_name $column" );
            }
            elsif ( $data_type eq 'numeric' ) {
                ok( defined $size, "size is defined for $source_name $column" )
                  && ok( ref($size) eq 'ARRAY', "and is an array" )
                  && cmp_ok( scalar @$size, '==', 2, "that has 2 elements" )
                  && cmp_ok( $size->[0], '>=', $size->[1],
                    "and precision >= scale" );
            }
            elsif ( $data_type =~ /^(date(time)*|timestamp)$/ ) {
                ok(
                    defined $columns_info->{$column}->{_ic_dt_method},
                    "InflateColumn::DateTime set for $source_name $column"
                );
            }
            else {
                fail(
                    "unexpected data_type $data_type for $source_name $column");
            }

            # POD comparison

            # we need a mangled form of columns_info to cope with magic
            # stuff handled by components

            my $info = $columns_info->{$column};
            delete $info->{_ic_dt_method};
            delete $info->{_inflate_info};

            if ( $info->{dynamic_default_on_create} ) {
                delete $info->{dynamic_default_on_create};
                $info->{set_on_create} = 1;
            }

            if ( $info->{dynamic_default_on_update} ) {
                delete $info->{dynamic_default_on_update};
                $info->{set_on_update} = 1;
            }

            if ( defined $pod{columns}{$column} ) {

                pass("$source_name $column pod exists");

                cmp_deeply(
                    $info,
                    $pod{columns}{$column},
                    "$source_name $column check pod"
                ) or diag Dumper($info);

                delete $pod{columns}{$column};
            }
            else {
                fail("$source_name $column pod exists");
            }
        }
        foreach my $key ( keys %{ $pod{columns} } ) {
            fail("$source_name $key unexpected pod found");
        }

        # check relationships

        my @source_relations = $source->relationships;

        foreach my $relname (@source_relations) {

            cmp_ok( $relname, 'eq', lc($relname),
                "relname $relname is lc in $source_name" );

            my $relationship = $source->relationship_info($relname);

            ( my $foreign_source_name = $relationship->{source} ) =~ s/.*://;

         # check columns exist in self and foreign then check data_type and size

            my $foreign_source       = $schema->source($foreign_source_name);
            my $foreign_columns_info = $foreign_source->columns_info;

            my @cond = %{ $relationship->{cond} };

            my ($self_column)    = grep { s/^self\.// } @cond;
            my ($foreign_column) = grep { s/^foreign\.// } @cond;

            ok(
                $columns_info->{$self_column},
                "$source_name has column $self_column"
              )

              && ok( $foreign_columns_info->{$foreign_column},
                    "foreign column $foreign_column exists for relation "
                  . "$source_name -> $relname" )

              && cmp_ok(
                $columns_info->{$self_column}->{data_type},
                'eq',
                $foreign_columns_info->{$foreign_column}->{data_type},
                "data_type matches across relationship $relname in $source_name"
              )

              && (
                $columns_info->{$self_column}->{data_type} =~ /^(var)*char$/ )

              && cmp_ok(
                $columns_info->{$self_column}->{size},
                'eq',
                $foreign_columns_info->{$foreign_column}->{size},
                "size matches across relationship $relname in $source_name"
              );

            # pod

            next
              if ( $source_name eq 'Navigation'
                && $relname =~ /^(_parent|children|parents)$/ );

            if ( defined $pod{relations}{$relname} ) {

                pass("$source_name relationship $relname pod exists");

                delete $pod{relations}{$relname};
            }
            else {
                fail("$source_name relationship $relname pod exists");
            }
        }
        foreach my $key ( keys %{ $pod{relations} } ) {
            fail(   "$source_name $pod{relations}{$key}{type} $key "
                  . "unexpected pod found" );
        }
    }
};

run_me;

done_testing;
