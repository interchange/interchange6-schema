package Interchange6::Schema::MultiSite;

use strict;
use warnings;

use Class::Method::Modifiers qw/around install_modifier/;

# Add current_website attribute to schema which is used by DynamicDefault
# to set the website_id column on record create.

Interchange6::Schema->mk_group_ro_accessors(
    inherited => (
        [ 'current_website' => '_ic6_current_website' ],
    )
);

Interchange6::Schema->mk_group_wo_accessors(
    inherited => (
        [ 'set_current_website' => '_ic6_current_website' ],
    )
);

# We need somewhere to store configuration of MultiSite options.

Interchange6::Schema->mk_group_accessors(
    inherited => (
        [ 'multisite_config' => '_ic6_multisite_config' ],
    )
);

install_modifier "DBIx::Class::Schema", "around", "register_class", sub {
    my ( $orig, $self, $source_name, $to_register ) = @_;


    if ( $to_register ne 'Interchange6::Schema::MultiSite::Result::Website' ) {

        my $add_website_relation;

        if ( $self->multisite_config->{users} eq "universal" ) {
        }
        elsif ( $self->multisite_config->{users} eq "website" ) {
            # don't want link table between Website and User
            return
              if $to_register eq
              'Interchange6::Schema::MultiSite::Result::WebsiteUser';

            $add_website_relation++;

            if ( 
        }

        if ($add_website_relation) {

            # Add websites_id column, create a relationship 'website' to the
            # Website class and add DynamicWebsiteId for website_id column.

            # add component which adds in get_website_id method
            $to_register->load_components(
                '+Interchange6::Schema::MultiSite::DynamicWebsiteId');

            # add column
            $to_register->add_column(
                websites_id => {
                    data_type                 => "integer",
                    dynamic_default_on_create => 'get_website_id',
                }
            );

            # create relationship
            $to_register->belongs_to(
                website => "Interchange6::Schema::MultiSite::Result::Website",
                "websites_id"
            );


        }
    }

};

sub add_website_relation {
    my $to_register = shift;
}

install_modifier "DBIx::Class::Schema", "around", "deploy", sub {
    my ( $orig, $self ) = ( shift, shift );

    my $ret = $orig->( $self, @_ );

    # create website 'Default'
    my $website = $self->resultset('Website')->create(
        {
            hostname    => "",
            name        => "Default",
            description => "Default Website"
        }
    );

    # set current_website to be picked up by DynamicDefault
    $self->set_current_website($website);
};

# load it all up!
sub load_namespaces {
    my $self = shift;

    my $config = $self->multisite_config || {};
    $config->{users} ||= "website";
    $self->multisite_config($config);

    $self->next::method(
        default_resultset_class => '+Interchange6::Schema::ResultSet',
        result_namespace        => [
            '+Interchange6::Schema::Result',
            '+Interchange6::Schema::MultiSite::Result'
        ],
        resultset_namespace => [
            '+Interchange6::Schema::ResultSet',
            '+Interchange6::Schema::MultiSite::ResultSet'
        ],
    );
}

1;
__END__

=head1 NAME

Interchange6::Schema::MultiSite - Add multisite/multistore features to Interchange6

=head1 SYNOPSIS

  package MyApp::Schema;

  use base 'Interchange6::Schema';

  Interchange6::Schema->load_own_components('MultiSite');

  __PACKAGE__->multisite_config( { foo => 'bar' } ); # see CONFIGURATION

  __PACKAGE__->load_namespaces();

=head1 DESCRIPTION

This L<Interchange6::Schema> component adds multisite/multistore support to
your database schema.

B<WARNING:> This is B<alpha> code and is likely to have many bugs.

=head1 CONFIGURATION

As shown in the L</SYNOPSIS> options can be set via C<multisite_config> which
affect the behavior of this component. Options must be passed as a hash
reference with the following keys...

=head2 users

The value of this can be either of the following:

=over

=item universal

A single user account can be used across all websites. In this case
L<Interchange6::Schema::Result::User/username> is set as a unique constraint
and a link table L<Interchange6::Schema::MultiSite::Result::WebsiteUser> is
created between L<Interchange6::Schema::Result::User> and
L<Interchange6::Schema::MultiSite::Result::Website>.

=item website

This default value.

=back

