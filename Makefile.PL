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
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
        'DBIx::Class'         => 0,
    },
    CONFIGURE => sub {
        # PREREQ_PM stuff goes here since we need to add DBIC deploy 
        # dependencies in the DBIC way so such things as SQLT version
        # deps needed by DBIC are always met correctly
        # https://metacpan.org/pod/distribution/DBIx-Class/lib/DBIx/Class/Optional/Dependencies.pod
        my $href->{PREREQ_PM} = {
            'Crypt::Eksblowfish::Bcrypt'           => 0,
            'Class::Method::Modifiers'             => 0,
            'CLDR::Number::Format::Currency'       => '0.16',
            'Data::UUID'                           => 0,
            'DBIx::Class'                          => 0,
            'DBIx::Class::Candy'                   => 0.002104,
            'DBIx::Class::DynamicDefault'          => '0.04',
            'DBIx::Class::PassphraseColumn'        => '0.02',
            'DBIx::Class::Helpers'                 => 2.024001,
            'DBIx::Class::InflateColumn::DateTime' => 0,
            'DBIx::Class::InflateColumn::DateTime::Duration' => 0,
            'DBIx::Class::Schema::Config'          => 0.001011,
            'DBIx::Class::TimeStamp'               => 0,
            'DBIx::Class::Tree'                    => 0,
            'Digest::MD5'                          => 0,
            'Encode'                               => 0,
            'Math::BigFloat'                       => '1.60',
            'Moo'                                  => '2.000',
            'Safe::Isa'                            => 0,
            'Session::Token'                       => 1.008,
            'Sub::Quote'                           => 1.004006,
            # for populating currency/country/state records
            'Locale::Codes'         => 0,
            'Locale::SubCountry'    => 1.62,
            'DateTime'              => 0,
            'Test::Roo'             => 1.003,
            'Time::Duration::Parse' => 0,
            'Try::Tiny'             => 0,
            'Type::Tiny'            => '0.038',
            # Add SQLT dep on version 0 to catch the case of users installing
            # directly from checked out repo who will not have META files yet.
            # This is also needed for travis-ci.
            'SQL::Translator' => 0,
        };
        # now add in the DBIC deploy deps
        eval { require DBIx::Class::Optional::Dependencies };
        return $href if $@;
        my $deploy_deps =
          DBIx::Class::Optional::Dependencies->req_list_for('deploy');

        for  (keys %$deploy_deps) {
            $href->{PREREQ_PM}->{$_} = $deploy_deps->{$_};
        }
        return $href;
    },
    BUILD_REQUIRES => {
                       'Class::Load' => 0,
                       'Data::Dumper::Concise' => 0,
                       'File::Temp' => 0,
                       'Test::MockTime' => 0,
                       'Test::More' => 0,
                       'Test::Most' => 0.33,
                       'Test::Warnings' => 0,
                       'DBD::SQLite' => 1.38_01,
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
