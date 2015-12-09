package Interchange6::Schema::Component::WebsiteStamp;

=head1 NAME

Interchange6::Schema::Component::WebsiteStamp - provides default website_id

=head1 DESCRIPTION

Result class helper to provide default value for C<website_id>
on record create.

=head1 SYNOPSIS

 package My::Schema::Result::Thing;
 
 __PACKAGE__->load_components(
    qw( +Interchange6::Schema::Component::WebsiteStamp ));
  
 __PACKAGE__->add_columns(
    thing_id => { data_type => 'integer' },
    website_id => {
      data_type => 'char', size => 3, set_website_on_create => 1 },
 );

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
        # let Devel::Cover inform us if we find a column with no info data
        # uncoverable branch false
        my $info = ref $cols[0] ? shift @cols : {};
        if ( delete $info->{set_website_on_create} ) {
            $info->{dynamic_default_on_create} = 'get_website_id';
        }
        push @columns, $col => $info;
    }

    return $self->next::method(@columns);
}

=head2 get_website_id

This is the method which provides the default value for C<website_id>.

This is simply the value of L<Interchange6::Schema/website_id>.

=cut

sub get_website_id {
    return shift->result_source->schema->website_id;
}

1;
