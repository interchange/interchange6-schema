package Interchange6::Schema::Populate;

=head1 NAME

Interchange6::Schema::Populate - populates a website with various fixtures

=cut

use Moo;
with 'Interchange6::Schema::Populate::CountryLocale',
  'Interchange6::Schema::Populate::Currency',
  'Interchange6::Schema::Populate::MessageType',
  'Interchange6::Schema::Populate::Role',
  'Interchange6::Schema::Populate::StateLocale',
  'Interchange6::Schema::Populate::Zone';

=head1 ATTRIBUTES

=head2 schema

A connected schema. Required.

=cut

has schema => (
    is => 'ro',
    required => 1,
);

=head1 METHODS

=head2 populate

=cut

sub populate {
    my $self = shift;
    $self->populate_countries;
    $self->populate_currencies;
    $self->populate_message_types;
    $self->populate_roles;
    $self->populate_states;
    $self->populate_zones;
};

1;
