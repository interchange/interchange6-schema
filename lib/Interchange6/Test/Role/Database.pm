package Interchange6::Test::Role::Database;

use Test::Roo::Role;

requires qw(_build_database _build_dbd_version);

=head1 NAME

Interchange6::Test::Role::Database

=head1 DESCRIPTION

Role consumed by all database-specific roles such as SQLite and Pg to provide common functionality.

=head1 ATTRIBUTES

=head2 database

The database object. We expect a database-specific role to supply the builder.

=cut

has database => (
    is      => 'lazy',
    clearer => 1,
);

=head2 database_info

Database backend version and other interesting info (if available).  We expect a database-specific role to supply the builder.

=cut

has database_info => (
    is => 'lazy',
);

sub _build_database_info {
    return "no info";
}

=head2 dbd_version

DBD::Foo version string. We expect a database-specific role to supply the builder.

=cut

has dbd_version => (
    is => 'lazy',
);

=head2 schema_class

Defaults to Interchange6::Schema. This gives tests the normal expected schema but allows them to overload with some other test schema if desired.

=cut

has schema_class => (
    is => 'ro',
    default => 'Interchange6::Schema',
);

=head2 unrestricted_schema

Our connected and deployed schema,

=cut;

has unrestricted_schema => (
    is      => 'lazy',
    clearer => 1,
);

sub _build_unrestricted_schema {
    my $self = shift;

    require DBIx::Class::Optional::Dependencies;
    if ( my $missing =
        DBIx::Class::Optional::Dependencies->req_missing_for('deploy') )
    {
        diag "WARN: missing $missing";
        plan skip_all => "$missing required to run tests";
    }

    my $schema_class = $self->schema_class;
    eval "require $schema_class"
      or die "failed to require $schema_class: $@";

    my $schema =  $schema_class->connect( $self->connect_info )
      or die "failed to connect to ";
    $schema->deploy();
    return $schema;
}
=head2 website

An L<Interchange6::Schema::Result::Website> object used to restrict the
schema.

=over

=item writer: set_website

After set_website is called L</ic6s_schema> is cleared.

=item clearer: clear_website

After clear_website is called L</ic6s_schema> is cleared.

=item predicate: has_website

=back

=cut

has website => (
    is        => 'ro',
    init_arg  => undef,
    writer    => 'set_website',
    clearer   => 1,
    predicate => 1,
);

after clear_website => sub {
    my $self = shift;
    $self->clear_ic6s_schema;
    $self->unrestricted_schema->current_website(undef);
};

after set_website => sub {
    my $self = shift;
    $self->clear_ic6s_schema;
    $self->unrestricted_schema->current_website($self->website);
};

=head2 ic6s_schema

L</unrestricted_schema> (possibly) restricted by L</website>

=over

=item clearer: clear_ic6s_schema

=back

=cut

has ic6s_schema => (
    is      => 'lazy',
    clearer => 1,
);

sub _build_ic6s_schema {
    my $self = shift;
    my $schema;
    if ( $self->has_website ) {
        $schema =
          $self->unrestricted_schema->restrict_with_website( $self->website );
    }
    else {
        $schema = $self->unrestricted_schema;
        $schema->current_website(undef);
    }
    return $schema;
}

=head1 MODIFIERS

=head2 before setup

Add diag showing DBD version info.

=cut

before setup => sub {
    my $self = shift;
    diag "using: " . $self->dbd_version;
    diag "db: " . $self->database_info;
};

1;
