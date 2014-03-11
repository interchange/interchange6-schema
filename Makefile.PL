use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Interchange6::Schema',
    AUTHOR              => q{Stefan Hornburg (Racke) <racke@linuxia.de>},
    VERSION_FROM        => 'lib/Interchange6/Schema.pm',
    ABSTRACT_FROM       => 'lib/Interchange6/Schema.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    EXE_FILES           => ['bin/interchange6-create-database'],
    BUILD_REQUIRES => {
                       'Test::More' => 0,
                       'Test::Warnings' => 0,
                       'DBICx::TestDatabase' => 0,
                       'Locale::Country' => 0,
                       'Try::Tiny' => 0,
                      },
    PREREQ_PM => {
                  'DBIx::Class' => 0,
                  'DBIx::Class::EncodedColumn' => 0,
                  'DBIx::Class::InflateColumn::DateTime' => 0,
                  'DBIx::Class::TimeStamp' => 0,
                  'DBIx::Class::Tree' => 0,
                  'SQL::Translator' => 0.11016,
                  # for populating country/state records
                  'Locale::SubCountry' => 0,
                  'DateTime' => 0,
                  'Time::Duration::Parse' => 0,
                 },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Interchange6-Schema-*' },
    META_MERGE        => {
        resources => {
            repository  => 'https://github.com/interchange/interchange6-schema.git',
            bugtracker => 'https://github.com/interchange/interchange6-schema/issues',
        },
    },
);
