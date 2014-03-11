use utf8;
package Interchange6::Schema;

=encoding utf8

=head1 NAME

Interchange6::Schema - Database Schema for Interchange 6

=head1 VERSION

0.018

=head1 DESCRIPTION

Database schema classes for Interchange6 Open Source eCommerce
software.

=head1 CREATE SQL FILES FOR DATABASE SCHEMA

This command creates SQL files for our database schema
in the F<sql/> directory:

   interchange6-create-database

=head1 SCHEMA CLASSES

=head2 CountryLocale

L<Interchange6::Schema::Populate::CountryLocale>

=head2 StateLocale

L<Interchange6::Schema::Populate::StateLocale>

=head2 Attribute

L<Interchange6::Schema::Result::Attribute>

=head2 AttributeValue

L<Interchange6::Schema::Result::AttributeValue>

=head2 Product

L<Interchange6::Schema::Result::Product>

=head2 ProductAttribute

L<Interchange6::Schema::Result::ProductAttribute>

=head2 ProductAttributeValue

L<Interchange6::Schema::Result::ProductAttributeValue>

=head2 GroupPricing

L<Interchange6::Schema::Result::GroupPricing>

=head2 Inventory

L<Interchange6::Schema::Result::Inventory>

=head2 Review

L<Interchange6::Schema::Result::Review>

=head2 MerchandisingAttribute

L<Interchange6::Schema::Result::MerchandisingAttribute>

=head2 MerchandisingProduct

L<Interchange6::Schema::Result::MerchandisingProduct>

=head2 Navigation

L<Interchange6::Schema::Result::Navigation>

=head2 NavigationProduct

L<Interchange6::Schema::Result::NavigationProduct>

=head2 Media

L<Interchange6::Schema::Result::Media>

=head2 MediaDisplay

L<Interchange6::Schema::Result::MediaDisplay>

=head2 MediaType

L<Interchange6::Schema::Result::MediaType>

=head2 MediaProduct

L<Interchange6::Schema::Result::MediaProduct>

=head2 User

L<Interchange6::Schema::Result::User>

=head2 Role

L<Interchange6::Schema::Result::Role>

=head2 UserRole

L<Interchange6::Schema::Result::UserRole>

=head2 Permission

L<Interchange6::Schema::Result::Permission>

=head2 UserAttribute

L<Interchange6::Schema::Result::UserAttribute>

=head2 UserAttributeValue

L<Interchange6::Schema::Result::UserAttributeValue>

=head2 Address

L<Interchange6::Schema::Result::Address>

=head2 Country

L<Interchange6::Schema::Result::Country>

=head2 State

L<Interchange6::Schema::Result::State>

=head2 Cart

L<Interchange6::Schema::Result::Cart>

=head2 CartProduct

L<Interchange6::Schema::Result::CartProduct>

=head2 Order

L<Interchange6::Schema::Result::Order>

=head2 Orderline

L<Interchange6::Schema::Result::Orderline>

=head2 OrderlinesShipping

L<Interchange6::Schema::Result::OrderlinesShipping>

=head2 PaymentOrder

L<Interchange6::Schema::Result::PaymentOrder>

=head2 Session

L<Interchange6::Schema::Result::Session>

=head2 Setting

L<Interchange6::Schema::Result::Setting>

=head2 Session

L<Interchange6::Schema::ResultSet::Session>

=head1 AUTHORS

Stefan Hornburg (Racke), C<racke@linuxia.de>

Jeff Boes, C<jeff@endpoint.com>

Sam Batschelet C<sbatschelet@mac.com>

=head1 CONTRIBUTORS

Kaare Rasmussen
SysPete
Šimun Kodžoman

=head1 LICENSE AND COPYRIGHT

Copyright 2013-2014 Stefan Hornburg (Racke), Jeff Boes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

our $VERSION = '0.018';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A+AhSjuWjRp6Y39vdVcJxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
