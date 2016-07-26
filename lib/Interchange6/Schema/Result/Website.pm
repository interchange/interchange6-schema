use utf8;

package Interchange6::Schema::Result::Website;

=head1 NAME

Interchange6::Schema::Result::Website - all sites/shops served from this schema

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => { data_type => "integer", is_auto_increment => 1 };

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

=head1 RELATIONS

=cut

has_many addresses => "Interchange6::Schema::Result::Address", "website_id";

has_many attributes => "Interchange6::Schema::Result::Attribute", "website_id";

has_many
  attribute_values => "Interchange6::Schema::Result::AttributeValue",
  "website_id";

has_many carts => "Interchange6::Schema::Result::Cart", "website_id";

has_many
  cart_products => "Interchange6::Schema::Result::CartProduct",
  "website_id";

has_many countries => "Interchange6::Schema::Result::Country", "website_id";

has_many inventories => "Interchange6::Schema::Result::Inventory", "website_id";

has_many medias => "Interchange6::Schema::Result::Media", "website_id";

has_many
  media_displays => "Interchange6::Schema::Result::MediaDisplay",
  "website_id";

has_many
  media_navigations => "Interchange6::Schema::Result::MediaNavigation",
  "website_id";

has_many
  media_products => "Interchange6::Schema::Result::MediaProduct",
  "website_id";

has_many media_types => "Interchange6::Schema::Result::MediaType", "website_id";

has_many
  merchandising_attributes =>
  "Interchange6::Schema::Result::MerchandisingAttribute",
  "website_id";

has_many
  merchandising_products =>
  "Interchange6::Schema::Result::MerchandisingProduct",
  "website_id";

has_many messages => "Interchange6::Schema::Result::Message", "website_id";

has_many
  message_types => "Interchange6::Schema::Result::MessageType",
  "website_id";

has_many
  navigations => "Interchange6::Schema::Result::Navigation",
  "website_id";

has_many
  navigation_attributes => "Interchange6::Schema::Result::NavigationAttribute",
  "website_id";

has_many
  navigation_attribute_values =>
  "Interchange6::Schema::Result::NavigationAttributeValue",
  "website_id";

has_many
  navigation_messages => "Interchange6::Schema::Result::NavigationMessage",
  "website_id";

has_many
  navigation_products => "Interchange6::Schema::Result::NavigationProduct",
  "website_id";

has_many orders => "Interchange6::Schema::Result::Order", "website_id";

has_many
  order_comments => "Interchange6::Schema::Result::OrderComment",
  "website_id";

has_many
  order_statuses => "Interchange6::Schema::Result::OrderStatus",
  "website_id";

has_many orderlines => "Interchange6::Schema::Result::Orderline", "website_id";

has_many
  orderlines_shippings => "Interchange6::Schema::Result::OrderlinesShipping",
  "website_id";

has_many
  payment_orders => "Interchange6::Schema::Result::PaymentOrder",
  "website_id";

has_many
  permissions => "Interchange6::Schema::Result::Permission",
  "website_id";

has_many
  price_modifiers => "Interchange6::Schema::Result::PriceModifier",
  "website_id";

has_many products => "Interchange6::Schema::Result::Product", "website_id";

has_many
  product_attributes => "Interchange6::Schema::Result::ProductAttribute",
  "website_id";

has_many
  product_attribute_values =>
  "Interchange6::Schema::Result::ProductAttributeValue",
  "website_id";

has_many
  product_messages => "Interchange6::Schema::Result::ProductMessage",
  "website_id";

has_many roles => "Interchange6::Schema::Result::Role", "website_id";

has_many sessions => "Interchange6::Schema::Result::Session", "website_id";

has_many settings => "Interchange6::Schema::Result::Setting", "website_id";

has_many shipments => "Interchange6::Schema::Result::Shipment", "website_id";

has_many
  shipment_carriers => "Interchange6::Schema::Result::ShipmentCarrier",
  "website_id";

has_many
  shipment_destinations => "Interchange6::Schema::Result::ShipmentDestination",
  "website_id";

has_many
  shipment_methods => "Interchange6::Schema::Result::ShipmentMethod",
  "website_id";

has_many
  shipment_rates => "Interchange6::Schema::Result::ShipmentRate",
  "website_id";

has_many states => "Interchange6::Schema::Result::State", "website_id";

has_many taxes => "Interchange6::Schema::Result::Tax", "website_id";

has_many
  uri_redirects => "Interchange6::Schema::Result::UriRedirect",
  "website_id";

has_many users => "Interchange6::Schema::Result::User", "website_id";

has_many
  user_attributes => "Interchange6::Schema::Result::UserAttribute",
  "website_id";

has_many
  user_attribute_values => "Interchange6::Schema::Result::UserAttributeValue",
  "website_id";

has_many user_roles => "Interchange6::Schema::Result::UserRole", "website_id";

has_many zones => "Interchange6::Schema::Result::Zone", "website_id";

has_many
  zone_countries => "Interchange6::Schema::Result::ZoneCountry",
  "website_id";

has_many zone_states => "Interchange6::Schema::Result::ZoneState", "website_id";

1;
