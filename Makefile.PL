use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Interchange6::Schema',
    AUTHOR              => q{Stefan Hornburg (Racke) <racke@linuxia.de>},
    VERSION_FROM        => 'lib/Interchange6/Schema.pm',
    ABSTRACT_FROM       => 'lib/Interchange6/Schema.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.47
      ? ('LICENSE'=> 'perl')
      : ()),
    MIN_PERL_VERSION    => '5.014000',
    PL_FILES            => {},
    EXE_FILES           => ['bin/interchange6-create-schema-png',
                            'bin/interchange6-create-database'],
    BUILD_REQUIRES => {
                       'Class::Load' => 0,
                       'Data::Dumper::Concise' => 0,
                       'Test::MockTime' => 0,
                       'Test::More' => 0,
                       'Test::Most' => 0.33,
                       'Test::Warnings' => 0,
                       'DBD::SQLite' => 1.38_01,
                       'File::Slurp' => 0,
                       'Try::Tiny' => 0,
                      },
    PREREQ_PM => {
                  'Crypt::Eksblowfish::Bcrypt' => 0,
                  'DBIx::Class' => 0,
                  'DBIx::Class::Candy' => 0.002104,
                  'DBIx::Class::EncodedColumn' => 0,
                  'DBIx::Class::InflateColumn::DateTime' => 0,
                  'DBIx::Class::TimeStamp' => 0,
                  'DBIx::Class::Tree' => 0,
                  'MooX::HandlesVia' => 0.001005,
                  'MooX::Types::MooseLike' => 0.25,
                  'SQL::Translator' => 0.11016,
                  'Sub::Quote' => 1.004006,
                  # for populating country/state records
                  'Locale::SubCountry' => 1.62,
                  'DateTime' => 0,
                  'Test::Roo'  => 1.003,
                  'Time::Duration::Parse' => 0,
                 },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Interchange6-Schema-*' },
    META_MERGE        => {
        resources => {
            repository  => 'https://github.com/interchange/interchange6-schema.git',
            bugtracker => 'https://github.com/interchange/interchange6-schema/issues',
            IRC => 'irc://irc.freenode.net/#interchange',
        },
    },
);
