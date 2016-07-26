use utf8;

package Interchange6::Schema::Result::Website;

=head1 NAME

Interchange6::Schema::Result::Website - all sites/shops served from this schema

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 website_id

Primary key.

=cut

primary_column website_id => { data_type => "integer", is_auto_increment => 1 };

=head2 name

Name of website/shop

Unique constraint.

=cut

unique_column name => { data_type => "varchar", size => 255 };

=head2 description

Description of website/shop

=cut

column description =>
  { data_type => "varchar", size => 2048, default_value => '' };

=head2 active

Boolean showing whether site is currently active.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head2 hostname

The unescaped hostname (domain name) for the website.

Unique constraint.

=cut

unique_column hostname => { data_type => "varchar", size => 255 };

=head1 RELATIONS

=head2 addresses

Type: has_many

Related object: L<Interchange6::Schema::Result::Address>

=cut

has_many addresses => "Interchange6::Schema::Result::Address", "website_id";

=head2 attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::Attribute>

=cut

has_many attributes => "Interchange6::Schema::Result::Attribute", "website_id";

=head2 

Type: has_many attribute_values

Related object: L<Interchange6::Schema::Result::AttributeValue>

=cut

has_many
  attribute_values => "Interchange6::Schema::Result::AttributeValue",
  "website_id";

=head2 carts

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

has_many carts => "Interchange6::Schema::Result::Cart", "website_id";

=head2 cart_products

Type: has_many

Related object: L<Interchange6::Schema::Result::CartProduct>

=cut

has_many
  cart_products => "Interchange6::Schema::Result::CartProduct",
  "website_id";

=head2 countries

Type: has_many

Related object: L<Interchange6::Schema::Result::Country>

=cut

has_many countries => "Interchange6::Schema::Result::Country", "website_id";

=head2 inventories

Type: has_many

Related object: L<Interchange6::Schema::Result::Inventory>

=cut

has_many inventories => "Interchange6::Schema::Result::Inventory", "website_id";

=head2 medias

Type: has_many

Related object: L<Interchange6::Schema::Result::Media>

=cut

has_many medias => "Interchange6::Schema::Result::Media", "website_id";

=head2 media_displays

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaDisplay>

=cut

has_many
  media_displays => "Interchange6::Schema::Result::MediaDisplay",
  "website_id";

=head2 media_navigations

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaNavigation>

=cut

has_many
  media_navigations => "Interchange6::Schema::Result::MediaNavigation",
  "website_id";

=head2 media_products

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaProduct>

=cut

has_many
  media_products => "Interchange6::Schema::Result::MediaProduct",
  "website_id";

=head2 media_types

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaType>

=cut

has_many media_types => "Interchange6::Schema::Result::MediaType", "website_id";

=head2 merchandising_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingAttribute>

=cut

has_many
  merchandising_attributes =>
  "Interchange6::Schema::Result::MerchandisingAttribute",
  "website_id";

=head2 merchandising_products

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

has_many
  merchandising_products =>
  "Interchange6::Schema::Result::MerchandisingProduct",
  "website_id";

=head2 messages

Type: has_many

Related object: L<Interchange6::Schema::Result::Message>

=cut

has_many messages => "Interchange6::Schema::Result::Message", "website_id";

=head2 message_types

Type: has_many

Related object: L<Interchange6::Schema::Result::MessageType>

=cut

has_many
  message_types => "Interchange6::Schema::Result::MessageType",
  "website_id";

=head2 navigations

Type: has_many

Related object: L<Interchange6::Schema::Result::Navigation>

=cut

has_many
  navigations => "Interchange6::Schema::Result::Navigation",
  "website_id";

=head2 navigation_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttribute>

=cut

has_many
  navigation_attributes => "Interchange6::Schema::Result::NavigationAttribute",
  "website_id";

=head2 navigation_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationAttributeValue>

=cut

has_many
  navigation_attribute_values =>
  "Interchange6::Schema::Result::NavigationAttributeValue",
  "website_id";

=head2 navigation_messages

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationMessage>

=cut

has_many
  navigation_messages => "Interchange6::Schema::Result::NavigationMessage",
  "website_id";

=head2 navigation_products

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationProduct>

=cut

has_many
  navigation_products => "Interchange6::Schema::Result::NavigationProduct",
  "website_id";

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

has_many orders => "Interchange6::Schema::Result::Order", "website_id";

=head2 order_comments

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderComment>

=cut

has_many
  order_comments => "Interchange6::Schema::Result::OrderComment",
  "website_id";

=head2 order_statuses

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderStatus>

=cut

has_many
  order_statuses => "Interchange6::Schema::Result::OrderStatus",
  "website_id";

=head2 orderlines

Type: has_many

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

has_many orderlines => "Interchange6::Schema::Result::Orderline", "website_id";

=head2 orderlines_shippings

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderlinesShipping>

=cut

has_many
  orderlines_shippings => "Interchange6::Schema::Result::OrderlinesShipping",
  "website_id";

=head2 payment_orders

Type: has_many

Related object: L<Interchange6::Schema::Result::PaymentOrder>

=cut

has_many
  payment_orders => "Interchange6::Schema::Result::PaymentOrder",
  "website_id";

=head2 permissions

Type: has_many

Related object: L<Interchange6::Schema::Result::Permission>

=cut

has_many
  permissions => "Interchange6::Schema::Result::Permission",
  "website_id";

=head2 price_modifiers

Type: has_many

Related object: L<Interchange6::Schema::Result::PriceModifier>

=cut

has_many
  price_modifiers => "Interchange6::Schema::Result::PriceModifier",
  "website_id";

=head2 products

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

has_many products => "Interchange6::Schema::Result::Product", "website_id";

=head2 product_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

has_many
  product_attributes => "Interchange6::Schema::Result::ProductAttribute",
  "website_id";

=head2 product_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttributeValue>

=cut

has_many
  product_attribute_values =>
  "Interchange6::Schema::Result::ProductAttributeValue",
  "website_id";

=head2 product_messages

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductMessage>

=cut

has_many
  product_messages => "Interchange6::Schema::Result::ProductMessage",
  "website_id";

=head2 roles

Type: has_many

Related object: L<Interchange6::Schema::Result::Role>

=cut

has_many roles => "Interchange6::Schema::Result::Role", "website_id";

=head2 sessions

Type: has_many

Related object: L<Interchange6::Schema::Result::Session>

=cut

has_many sessions => "Interchange6::Schema::Result::Session", "website_id";

=head2 settings

Type: has_many

Related object: L<Interchange6::Schema::Result::Setting>

=cut

has_many settings => "Interchange6::Schema::Result::Setting", "website_id";

=head2 shipments

Type: has_many

Related object: L<Interchange6::Schema::Result::Shipment>

=cut

has_many shipments => "Interchange6::Schema::Result::Shipment", "website_id";

=head2 shipment_carriers

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentCarrier>

=cut

has_many
  shipment_carriers => "Interchange6::Schema::Result::ShipmentCarrier",
  "website_id";

=head2 shipment_destinations

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentDestination>

=cut

has_many
  shipment_destinations => "Interchange6::Schema::Result::ShipmentDestination",
  "website_id";

=head2 shipment_methods

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentMethod>

=cut

has_many
  shipment_methods => "Interchange6::Schema::Result::ShipmentMethod",
  "website_id";

=head2 shipment_rates

Type: has_many

Related object: L<Interchange6::Schema::Result::ShipmentRate>

=cut

has_many
  shipment_rates => "Interchange6::Schema::Result::ShipmentRate",
  "website_id";

=head2 states

Type: has_many

Related object: L<Interchange6::Schema::Result::State>

=cut

has_many states => "Interchange6::Schema::Result::State", "website_id";

=head2 taxes

Type: has_many

Related object: L<Interchange6::Schema::Result::Tax>

=cut

has_many taxes => "Interchange6::Schema::Result::Tax", "website_id";

=head2 uri_redirects

Type: has_many

Related object: L<Interchange6::Schema::Result::UriRedirect>

=cut

has_many
  uri_redirects => "Interchange6::Schema::Result::UriRedirect",
  "website_id";

=head2 users

Type: has_many

Related object: L<Interchange6::Schema::Result::User>

=cut

has_many users => "Interchange6::Schema::Result::User", "website_id";

=head2 user_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttribute>

=cut

has_many
  user_attributes => "Interchange6::Schema::Result::UserAttribute",
  "website_id";

=head2 user_attribute_values

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttributeValue>

=cut

has_many
  user_attribute_values => "Interchange6::Schema::Result::UserAttributeValue",
  "website_id";

=head2 user_roles

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

has_many user_roles => "Interchange6::Schema::Result::UserRole", "website_id";

=head2 zones

Type: has_many

Related object: L<Interchange6::Schema::Result::Zone>

=cut

has_many zones => "Interchange6::Schema::Result::Zone", "website_id";

=head2 zone_countries

Type: has_many

Related object: L<Interchange6::Schema::Result::ZoneCountry>

=cut

has_many
  zone_countries => "Interchange6::Schema::Result::ZoneCountry",
  "website_id";

=head2 zone_states

Type: has_many

Related object: L<Interchange6::Schema::Result::ZoneState>

=cut

has_many zone_states => "Interchange6::Schema::Result::ZoneState", "website_id";

1;
