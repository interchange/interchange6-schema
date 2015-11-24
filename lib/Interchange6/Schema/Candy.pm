use utf8;
package Interchange6::Schema::Candy;

=head1 NAME

Interchange6::Schema::Candy - add DBIx::Class::Candy to our Result classes

=cut

use base 'DBIx::Class::Candy';

=head1 METHODS

=head2 base

Set base to either what is set by the Result class or else to DBIx::Class::Core

=cut

sub base { $_[1] || 'DBIx::Class::Core' }

=head2 autotable

Set autotable to either what is set by the Result class or else to 1

=cut

sub autotable { $_[1] || 1 }

=head2 parse_arguments

Override L<DBIx::Class::Candy/parse_arguments> to add components to all of our
Result classes. The following components are currently loaded:

=over

=item * Interchange6::Schema::Component::AutoWebsiteId

=back

=cut

sub parse_arguments {
    my $self = shift;

    # add components to this list:
    my @result_class_components =
      ('+Interchange6::Schema::Component::AutoWebsiteId');

    my $args = $self->next::method(@_);
    unshift @{$args->{components}}, @result_class_components;
    return $args;
}


1;
