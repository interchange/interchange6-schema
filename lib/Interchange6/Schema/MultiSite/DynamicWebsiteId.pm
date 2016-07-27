package Interchange6::Schema::MultiSite::DynamicWebsiteId;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/DynamicDefault/);

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
