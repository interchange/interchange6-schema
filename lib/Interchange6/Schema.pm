use utf8;

package Interchange6::Schema;

=encoding utf8

=head1 NAME

Interchange6::Schema - Database Schema for Interchange 6

=head1 VERSION

0.091

=cut

our $VERSION = '0.091';

=head1 DESCRIPTION

Database schema classes for Interchange6 Open Source eCommerce
software.

This class inherits from L<DBIx::Class::Schema::Config>.

Components used:

=over

=item * L<DBIx::Class::Helper::Schema::DateTime>

=item * L<DBIx::Class::Helper::Schema::QuoteNames>

=item * L<DBIx::Class::Schema::RestrictWithObject>

=back

The minimum Perl version for Interchange6::Schema is 5.14.

=cut

use strict;
use warnings;

use base 'DBIx::Class::Schema::Config';
use Class::Method::Modifiers ':all';
use Try::Tiny;
use namespace::clean;

__PACKAGE__->load_components( 'Helper::Schema::DateTime',
    'Helper::Schema::QuoteNames', 'Schema::RestrictWithObject' );

__PACKAGE__->load_namespaces(
    default_resultset_class => 'ResultSet',
);

=head1 MANUAL

Please see the L<Interchange6 Schema Manual|Interchange6::Schema::Manual> for an overview of available documentation.

=head1 ACCESSORS

=cut

__PACKAGE__->mk_group_accessors(
    'simple' => qw/current_user current_website primary_currency superadmin/ );

after current_website => sub {
    my $schema = shift;

    if (@_) {

        # we have args
        if ( my $website = shift ) {

            # assume it is a website (an exception will be thrown if not)
            my $setting = $website->find_related( 'settings',
                { scope => 'global', name => 'currency' } );

            if ($setting) {
                # site has a currency setting to stash currency
                my $currency = $schema->resultset('Currency')->find(
                    {
                        website_id => $website->id,
                        iso_code   => uc( $setting->value ),
                    }
                );
                $schema->primary_currency($currency);
            }
        }
        else {
            $schema->primary_currency(undef);
        }
    }
};


=head2 current_user

Used to stash the current L<Interchange6::Schema::Result::User>.

=head2 current_website

Used to stash the current L<Interchange6::Schema::Result::Website>.

This can then be used in all resultsets except
L<Interchange6::Schema::Result::Website> to restrict searches to current
website and also to set the default value of C<website_id> column on create.

=head2 primary_currency

Used to stash the website's primary L<Interchange6::Schema::Result::Currency>.

This is set automatically whenever L</current_website> is set using
L<Interchange6::Schema::Result::Setting> where C<scope> is C<global>
and C<name> is C<currency> to find the Currency object.

=head2 superadmin

Boolean which if true allows 'superadmin' powers and removes any restrictions
set by L</current_website_id>.

B<NOTE:> this will also prevent auto-population of C<website_id> columns.

B<NOTE:> NOT CURRENTLY USED.

=head1 METHODS

=head2 restrict_with_website

Takes an L<Interchange6::Schema::Result::Website> object as its only argument.

Sets L</current_website> (and therefore also L</primary_currency>) and returns
a schema object that is restricted by the website using
L<DBIx::Class::Schema::RestrictWithObject>.

=cut

sub restrict_with_website {
    my ( $self, $website ) = @_;
    $self->current_website($website);
    return $self->restrict_with_object($website);
};

=head2 register_class

Extends L<DBIx::Class::Schema/register_class>.

For all result classes except L<Interchange6::Schema::Result::Website> performs
the following tasks:

=over

=item * adds C<restrict_${source_name}_resultset> method to L<Interchange6::Schema::Result::Website> for use by L<DBIx::Class::Schema::RestrictWithObject>

=back

=cut

sub register_class {
    my ( $self, $source_name, $class ) = @_;

    $self->next::method( $source_name, $class );

    if ( $class ne "Interchange6::Schema::Result::Website" ) {

        my $source = $self->source($source_name);

        install_modifier "Interchange6::Schema::Result::Website", "fresh",
          "restrict_${source_name}_resultset", sub {
            my $self            = shift;
            my $unrestricted_rs = shift;
            return $self->related_resultset($source->name);
#            my $schema          = $unrestricted_rs->result_source->schema;
#            return $unrestricted_rs->search_rs(
#                {
#                    $unrestricted_rs->current_source_alias . '.website_id' => $self->id
#                }
#            );
          };
    }
}

sub connection {
    my $self = shift;
    $self->next::method(@_);
    foreach my $source_name ( grep { $_ ne 'Website' } $self->sources ) {
        my $source = $self->source($source_name);

    }
    return $self;
}

=head2 deploy

Extends L<DBIx::Class::Schema/deploy>.

=over

=item * Add superadmin website with name "Admin Website"

=item * Add admin role to Admin Website

=item * Add user 'admin' with role 'admin' to Admin Website

Initial admin user is created with no password so cannot authenticate.

=cut

sub deploy {
    my $self = shift;
    my $new  = $self->next::method(@_);

    # we need super cow powers
    #$self->superadmin(1); FIXME: not currently used

    # create admin website
    my $website = $self->resultset('Website')->create(
        {
            name => "Admin Website",
            description => "The admin site is used to create and manage all websites in this Interchange6 installation",
        }
    );

    # set current_website so we don't need to supply website_id in create
    $self->current_website($website);

    # we need to create user role since all users are added to this role
    $self->resultset('Role')->create(
        {
            name => 'user',
            label => 'User',
            description => 'All users have this role',
        }
    );
    my $admin_role = $self->resultset('Role')->create(
        {
            name => 'admin',
            label => 'Admin',
            description => 'Superadmin role with power over all websites',
        }
    );

    # create initial admin user in role 'admin'
    $self->resultset('User')->create(
        {
            username => 'admin',
            user_roles => [
                {
                    role_id => $admin_role->id,
                },
            ],
        }
    );

    # disable super cow powers and undef website
    #$self->superadmin(0); FIXME: not currently used
    $self->current_website( undef );
}

=head2 create_website \%args | %args

Create a new website with initial admin user and add core fixtures to the new
site. Returns the newly created L<Interchange6::Schema::Result::Website>.

Required arguments:

=over

=item * admin - email address of initial site admin

e.g.: admin => 'user@example.com'

=item * name - name of site

e.g.: name => "House of Widgets"

=item * description - short description of site

e.g.: description => "Home to the best widgets on the planet"

=item * currency - ISO 4217 three letter code for main currency used by site

e.g.: currency => "EUR"

=back

The following classes are used to populate initial fixtures:

=over

=item * Interchange6::Schema::Populate::CountryLocale

=item * Interchange6::Schema::Populate::Currency

=item * Interchange6::Schema::Populate::MessageType

=item * Interchange6::Schema::Populate::Role

=item * Interchange6::Schema::Populate::StateLocale

=item * Interchange6::Schema::Populate::Zone

=back

=cut

sub create_website {
    my ( $self, @args ) = @_;
    my ( %params, $website );

    $self->throw_exception("No args supplied to create_website")
      unless defined $args[0];

    if ( ref($args[0]) eq 'HASH' ) {
        %params = %{ $args[0] };
    }
    else {
        %params = @args;
    }

    if (   !$params{admin}
        || !$params{name}
        || !$params{description}
        || !$params{currency} )
    {
        die "Missing args to Interchange6::Schema->create_website";
    }

    try {
        $self->txn_do(
            sub {

                # we need super cow powers
                #$self->superadmin(1); FIXME: not currently used

                # create website
                $website = $self->resultset('Website')->create(
                    {
                        name        => $params{name},
                        description => $params{description},
                    }
                );

                # set website so we don't need to supply website_id
                # in create
                $self->current_website( $website );

                use Interchange6::Schema::Populate;

                my $populator =
                  Interchange6::Schema::Populate->new(
                    schema => $self->restrict_with_object($website) );

                $populator->populate;

                # check and set default currency

                my $currency = $self->resultset('Currency')->find(
                    {
                        iso_code   => uc( $params{currency} ),
                        website_id => $website->id
                    }
                );

                $self->throw_exception("Currency not found: $params{currency}")
                  unless $currency;

                $self->resultset('Setting')->create(
                    {
                        scope => 'global',
                        name => 'currency',
                        value => $currency->iso_code,
                    }
                );

                # add site admin user

                $self->resultset('User')->create(
                    {
                        username   => $params{admin},
                        user_roles => [
                            {
                                role_id => $self->resultset('Role')->find(
                                    {
                                        name       => 'admin',
                                        website_id => $website->id
                                    }
                                )->id,
                            },
                        ],
                    }
                );

                # disable super cow powers and undef current_website_id
                #$self->superadmin(0); FIXME: not currently used
                $self->current_website( undef );
            }
        );
    }
    catch {
         die $_;
    };
    return $website;
};

1;

__END__

=head1 DEPLOYING THE SCHEMA

The following script is supplied for deploying the schema to a newly
created database:

   interchange6-deploy-schema

=head1 POPULATING A NEW WEBSITE/SHOP

The following script is supplied for populating the schema with data for
a new website/shop:

   interchange6-create-website

=head1 POLICY FOR RELATIONSHIP ACCESSORS

=over 4

=item All lower case

=item Singular names for belongs_to and has_one relationships

=item Pluralised names for many_to_many and has_many relationships

=item Use underscores for things like C<shipment_destinations>.

=back

=head1 AUTHORS

Stefan Hornburg (Racke), C<racke@linuxia.de>

Peter Mottram, C<peter@sysnix.com>

Jeff Boes, C<jeff@endpoint.com>

Sam Batschelet C<sbatschelet@mac.com>

=head1 CONTRIBUTORS

Kaare Rasmussen
Šimun Kodžoman
Grega Pompe

=head1 LICENSE AND COPYRIGHT

Copyright 2013-2015 Stefan Hornburg (Racke), Jeff Boes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
