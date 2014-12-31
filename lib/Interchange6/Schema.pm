use utf8;

package Interchange6::Schema;

=encoding utf8

=head1 NAME

Interchange6::Schema - Database Schema for Interchange 6

=head1 VERSION

0.070

=cut

our $VERSION = '0.070';

=head1 DESCRIPTION

Database schema classes for Interchange6 Open Source eCommerce
software.

Components used:

=over

=item * L<DBIx::Class::Helper::Schema::DateTime>

=item * L<DBIx::Class::Helper::Schema::QuoteNames>

=back

=cut

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_components( 'Helper::Schema::DateTime',
    'Helper::Schema::QuoteNames' );

__PACKAGE__->load_namespaces(
    default_resultset_class => 'ResultSet',
);

=head1 MANUAL

Please see the L<Interchange6 Schema Manual|Interchange6::Schema::Manual> for an overview of available documentation.

=head1 METHODS

=head2 deploy

Overload L<DBIx::Class::Schema/deploy> in order to add some core fixtures
via the following classes:

=over

=item * Interchange6::Schema::Populate::CountryLocale

=item * Interchange6::Schema::Populate::MessageType

=item * Interchange6::Schema::Populate::Role

=item * Interchange6::Schema::Populate::StateLocale

=item * Interchange6::Schema::Populate::Zone

=back

=cut

{
    use Interchange6::Schema::Populate::CountryLocale;
    use Interchange6::Schema::Populate::MessageType;
    use Interchange6::Schema::Populate::Role;
    use Interchange6::Schema::Populate::StateLocale;
    use Interchange6::Schema::Populate::Zone;

    sub deploy {
        my $self = shift;
        my $new  = $self->next::method(@_);

        my $pop_country =
          Interchange6::Schema::Populate::CountryLocale->new->records;
        $self->resultset('Country')->populate($pop_country)
          or die "Failed to populate Country";

        my $pop_messagetype =
          Interchange6::Schema::Populate::MessageType->new->records;
        $self->resultset('MessageType')->populate($pop_messagetype)
          or die "Failed to populate MessageType";

        my $pop_role =
          Interchange6::Schema::Populate::Role->new->records;
        $self->resultset('Role')->populate($pop_role)
          or die "Failed to populate Role";

        my $pop_state =
          Interchange6::Schema::Populate::StateLocale->new->records;
        my $states = $self->resultset('State')->populate($pop_state)
          or die "Failed to populate State";

        my $min_states_id = $self->resultset('State')->search(
            {},
            {
                select => [ { min => 'states_id' } ],
                as     => ['min_id'],
            }
        )->first->get_column('min_id');

        my $pop_zone =
          Interchange6::Schema::Populate::Zone->new(
              states_id_initial_value => $min_states_id )->records;
        $self->resultset('Zone')->populate($pop_zone)
          or die "Failed to populate Zone";
    }
}

1;

__END__

=head1 CREATE SQL FILES FOR DATABASE SCHEMA

This command creates SQL files for our database schema
in the F<sql/> directory:

   interchange6-create-database

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

Copyright 2013-2014 Stefan Hornburg (Racke), Jeff Boes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
