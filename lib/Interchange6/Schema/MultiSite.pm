package Interchange6::Schema::MultiSite;

use strict;
use warnings;

use Class::Method::Modifiers 'install_modifier';

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

install_modifier "DBIx::Class::Schema", "before", "register_class", sub {
    my ( $self, $source_name, $to_register ) = @_;

    # Add websites_id column to all result classes except Website,
    # create a relationship 'website' to the Website class and add
    # DynamicWebsiteId for website_id column.

    if ( $to_register ne "Interchange6::Schema::Result::Website" ) {

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
            website => "Interchange6::Schema::Result::Website",
            "websites_id"
        );
    }
};

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
Interchange6::Schema->load_namespaces(
    default_resultset_class => 'ResultSet',
);

1;
__END__

=head1 NAME

Interchange6::Schema::MultiSite - Add multisite/multistore features to Interchange6

=head1 SYNOPSIS

  package MyApp::Schema;

  use base 'Interchange6::Schema';

  Interchange6::Schema->load_own_components('MultiSite');

=head1 DESCRIPTION

This L<Interchange6::Schema> component adds multisite/multistore support to
your database schema.

B<WARNING:> This is B<alpha> code and is likely to have many bugs.
