package Interchange6::Schema::Component::DynamicDefaults;

=head1 NAME

Interchange6::Schema::Component::DynamicDefaults;

=head1 DESCRIPTION

Result class helper to provide default values for C<website_id> on record
create.

=cut

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/DynamicDefault/);

=head1 METHODS

=head2 add_columns

=cut

sub add_columns {
    my ( $self, @cols ) = @_;
    my @columns;

    while ( my $col = shift @cols ) {
        my $info = ref $cols[0] ? shift @cols : {};
        if (   $col eq 'website_id'
            && $self ne 'Interchange6::Schema::Result::Website' )
        {
            $info->{dynamic_default_on_create} = 'get_website_id';
        }
        push @columns, $col => $info;
    }

    return $self->next::method(@columns);
}

=head2 get_website_id

=cut

sub get_website_id {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    if ( $schema->current_website ) {
        return $schema->current_website->id;
    }
}

1;
