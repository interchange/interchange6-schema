use utf8;
package Interchange6::Schema;

=encoding utf8

=head1 NAME

Interchange6::Schema - Database Schema for Interchange 6

=head1 VERSION

0.032

=cut

our $VERSION = '0.032';

=head1 DESCRIPTION

Database schema classes for Interchange6 Open Source eCommerce
software.

=head1 CREATE SQL FILES FOR DATABASE SCHEMA

This command creates SQL files for our database schema
in the F<sql/> directory:

   interchange6-create-database

=head1 RESULT CLASSES

=head2 Products, Pricing, Inventory and Review

=head3 Product

L<Interchange6::Schema::Result::Product>

=head3 ProductAttribute

L<Interchange6::Schema::Result::ProductAttribute>

=head3 ProductAttributeValue

L<Interchange6::Schema::Result::ProductAttributeValue>

=head3 GroupPricing

L<Interchange6::Schema::Result::GroupPricing>

=head3 Inventory

L<Interchange6::Schema::Result::Inventory>

=head3 Review

L<Interchange6::Schema::Result::Review>

=head2 Attributes

=head3 Attribute

Generic attributes for other classes.

L<Interchange6::Schema::Result::Attribute>

=head3 AttributeValue

Generic attribute values for other classes.

L<Interchange6::Schema::Result::AttributeValue>

=head2 Merchandising

=head3 MerchandisingProduct

L<Interchange6::Schema::Result::MerchandisingProduct>

=head3 MerchandisingAttribute

L<Interchange6::Schema::Result::MerchandisingAttribute>

=head2 Navigation

=head3 Navigation

L<Interchange6::Schema::Result::Navigation>

=head3 NavigationProduct

L<Interchange6::Schema::Result::NavigationProduct>

=head3 NavigationAttribute

L<Interchange6::Schema::Result::NavigationAttribute>

=head3 NavigationAttributeValue

L<Interchange6::Schema::Result::NavigationAttributeValue>

=head2 Media

=head3 Media

L<Interchange6::Schema::Result::Media>

=head3 MediaDisplay

L<Interchange6::Schema::Result::MediaDisplay>

=head3 MediaType

L<Interchange6::Schema::Result::MediaType>

=head3 MediaProduct

L<Interchange6::Schema::Result::MediaProduct>

=head2 User, Roles and Permissions

=head3 User

L<Interchange6::Schema::Result::User>

=head3 Role

L<Interchange6::Schema::Result::Role>

=head3 UserRole

L<Interchange6::Schema::Result::UserRole>

=head3 Permission

L<Interchange6::Schema::Result::Permission>

=head3 UserAttribute

L<Interchange6::Schema::Result::UserAttribute>

=head3 UserAttributeValue

L<Interchange6::Schema::Result::UserAttributeValue>

=head2 Address

L<Interchange6::Schema::Result::Address>

=head2 Countries, States and Zones

=head3 Country

L<Interchange6::Schema::Result::Country>

=head3 State

L<Interchange6::Schema::Result::State>

=head3 Zone

L<Interchange6::Schema::Result::Zone>

=head3 ZoneCountry

L<Interchange6::Schema::Result::ZoneCountry>

=head2 Carts

=head3 Cart

L<Interchange6::Schema::Result::Cart>

=head3 CartProduct

L<Interchange6::Schema::Result::CartProduct>

=head2 Orders and Payment

=head3 Order

L<Interchange6::Schema::Result::Order>

=head3 Orderline

L<Interchange6::Schema::Result::Orderline>

=head3 OrderlinesShipping

L<Interchange6::Schema::Result::OrderlinesShipping>

=head3 PaymentOrder

L<Interchange6::Schema::Result::PaymentOrder>

=head2 Session

L<Interchange6::Schema::Result::Session>

=head2 Setting

L<Interchange6::Schema::Result::Setting>

=head1 RESULTSET CLASSES

=head2 Tax

L<Interchange6::Schema::ResultSet::Tax>

=head2 Session

L<Interchange6::Schema::ResultSet::Session>

=head1 POPULATE CLASSES

=head2 CountryLocale

L<Interchange6::Schema::Populate::CountryLocale>

=head2 StateLocale

L<Interchange6::Schema::Populate::StateLocale>

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
