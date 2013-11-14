package Exporter::AutoOkay;
#
#   Automatically add all subroutines from caller package into the
#   @EXPORT_OK array. In the package use like Exporter, f.ex.:
#
#       use parent 'Exporter::AutoOkay';
#
use warnings;
use strict;
no strict 'refs';

require Exporter;

sub import {
    my $package = $_[0].'::';

    # Get the list of exportable items
    my @export_ok = (@{$package.'EXPORT_OK'});

    # Automatically add all subroutines from package into the list
    foreach (keys %{$package}) {
        next unless defined &{$package.$_};
        push @export_ok, $_;
    }

    # Set variable ready for Exporter
    @{$package.'EXPORT_OK'} = @export_ok;

    #warn 'We are exporting ' . join(',',@export_ok) . "\n";

    # Let Exporter do the rest
    goto &Exporter::import;
}

package Interchange6::Schema::TestBed;
use strict;
use parent -norequire, 'Exporter::AutoOkay';

use Interchange6::Schema;
our @EXPORT_OK = qw($db);
our (@connection, $db);

BEGIN {
    @connection = ('dbi:Pg:database=jeff;host=localhost;port=5433','jeff','b00dylish');

    $db = Interchange6::Schema->connect(@connection);
}

sub make_address {
    use Interchange6::Schema::Result::Address;

    my $user = make_user();
    $user->insert;

    return $db->resultset('Address')->new({
        users_id       => $user->users_id,
        first_name     => 'Testy',
        last_name      => 'Tester',
        company        => 'TestoTronics',
        address        => '123 Any St',
        zip            => '12345',
        city           => 'Anytown',
        phone          => '555-222-2222',
        state_code     => 'AK',
        country_code   => 'US',
        created        => 'now',
        last_modified  => 'now',
    });
}

sub make_cart {
    use Interchange6::Schema::Result::Cart;

    my $user = make_user();
    $user->insert;
    my $session = make_session();
    $session->insert;

    return $db->resultset('Cart')->new({
        users_id       => $user->users_id,
        sessions_id    => $session->sessions_id,
        name           => 'my cart',
        created        => 'now',
        last_modified  => 'now',
        approved       => 1,
        status         => 'ok',
    });
}

sub make_cart_product {
    use Interchange6::Schema::Result::CartProduct;

    my $cart = make_cart();
    $cart->insert;
    my $product = make_product();
    $product->insert;

    return $db->resultset('CartProduct')->new({
        carts_id => $cart->carts_id,
        sku => $product->sku,
        cart_position => 1,
        quantity => 1,
        when_added => 'now',
    });
}

sub make_group_pricing {
    use Interchange6::Schema::Result::GroupPricing;

    my $product = make_product();
    $product->insert;
    my $role = make_role();
    $role->insert;
    return $db->resultset('GroupPricing')->new({
        sku => $product->sku,
        roles_id => $role->roles_id,
        quantity => 1,
        price => 12.34,
    });
}

sub make_inventory {
    use Interchange6::Schema::Result::Inventory;

    my $product = make_product();
    $product->insert;
    return $db->resultset('Inventory')->new({
        sku      => $product->sku,
        quantity => 1,
    });
}

sub make_media {
    use Interchange6::Schema::Result::Media;
    return $db->resultset('Media')->new({
        file           => 'some file',
        uri            => 'http://example.com/some_file.txt',
        mime_type      => 'text/plain',
        label          => 'Some File',
        author         => 0,
        created        => 'now',
        last_modified  => 'now',
        active         => 0,
    });
}

sub make_media_display {
    use Interchange6::Schema::Result::MediaDisplay;

    my $media = make_media();
    $media->insert;
    my $product = make_product();
    $product->insert;
    my $media_type = make_media_type();
    $media_type->insert;

    return $db->resultset('MediaDisplay')->new({
        media_id => $media->media_id,
        media_types_id => $media_type->media_types_id,
        sku => $product->sku,
    });
}

sub make_media_product {
    use Interchange6::Schema::Result::MediaProduct;

    my $media = make_media();
    $media->insert;
    my $product = make_product();
    $product->insert;

    return $db->resultset('MediaProduct')->new({
        media_id => $media->media_id,
        sku => $product->sku,
    });
}

sub make_media_type {
    use Interchange6::Schema::Result::MediaType;

    return $db->resultset('MediaType')->new({
        type => 'type',
    });
}

sub make_merchandising_attribute {
    use Interchange6::Schema::Result::MerchandisingAttribute;

    my $merch = make_merchandising_product();
    $merch->insert;

    return $db->resultset('MerchandisingAttribute')->new({
        merchandising_products_id => $merch->merchandising_products_id,
        name => 'name',
        value => 'value',
    });
}

sub make_merchandising_product {
    use Interchange6::Schema::Result::MerchandisingProduct;

    my $product = make_product()->insert;
    my $related = make_product(1)->insert;

    return $db->resultset('MerchandisingProduct')->new({
        sku => $product->sku,
        sku_related => $related->sku,
        type => 'type',
    });
}

sub make_navigation {
    use Interchange6::Schema::Result::Navigation;

    return $db->resultset('Navigation')->new({
        uri => 'uri',
        type => 'type',
        scope => 'scope',
        name => 'name',
        description => 'description',
        template => 'template',
        product_count => 1,
        active => 0,
    });
}

sub make_navigation_product {
    use Interchange6::Schema::Result::NavigationProduct;

    my $product = make_product()->insert;
    my $navigation = make_navigation()->insert;

    return $db->resultset('NavigationProduct')->new({
        sku => $product->sku,
        navigation_id => $navigation->navigation_id,
        type => 'type',
    });
}

sub make_permission {
    use Interchange6::Schema::Result::Permission;

    my $role = make_role();
    $role->insert;

    return $db->resultset('Permission')->new({
        roles_id => $role->roles_id,
        perm => 'something',
    });
}

sub make_order {
    use Interchange6::Schema::Result::Order;

    my $billing_address = make_address()->insert;
    my $user = make_user()->insert;

    return $db->resultset('Order')->new({
        billing_addresses_id => $billing_address->addresses_id,
        users_id => $user->users_id,
        order_number => '987654321',
        order_date => 'now',
        email => 'me@example.com',
        weight => 1.23,
        payment_method => 'Credit Card (Mustard Card)',
        payment_number => 'M2442',
        payment_status => 'successful',
        shipping_method => 'UPS',
        tracking_number => '355353',
        subtotal => 44.55,
        shipping => 12.95,
        handling => 0.0,
        salestax => 0.0,
        total_cost => 44.55 + 12.95,
        status => 'incoming',
    });
}

sub make_orderline {
    use Interchange6::Schema::Result::Orderline;

    my $order = make_order()->insert;
    my $product = make_product()->insert;

    return $db->resultset('Orderline')->new({
        order_number => $order->order_number,
        order_position => 1,
        sku => $product->sku,
        name => $product->name,
        short_description => $product->short_description,
        description => $product->description,
        weight => 1.23,
        quantity => 1,
        shipping_method => $order->shipping_method,
        tracking_number => $order->tracking_number,
        price => $product->price,
        subtotal => $product->price,
        shipping => $order->shipping,
        handling => 0.0,
        salestax => 0.0,
        status => 'incoming',
    });
}

sub make_orderline_shipping {
    use Interchange6::Schema::Result::OrderlinesShipping;

    my $orderline = make_orderline()->insert;
    my $shipping_address = make_address()->insert;

    return $db->resultset('OrderlinesShipping')->new({
        orderlines_id => $orderline->orderlines_id,
        addresses_id  => $shipping_address->addresses_id,
    });
}

sub make_payment_order {
    use Interchange6::Schema::Result::PaymentOrder;

    my $order = make_order()->insert;
    my $session = make_session()->insert;

    return $db->resultset('PaymentOrder')->new({
        order_number => $order->order_number,
        sessions_id  => $session->sessions_id,
        payment_mode => 'Credit Card',
        payment_action => 'Payment',
        payment_id => 8768766,
        auth_code => 'XYZ123',
        amount => 29.95,
        status => 'success',
        payment_sessions_id => 'RSTUV999',
        payment_error_code => '',
        payment_error_message => '',
        created => 'now',
        last_modified => 'now',
    });
}

sub make_product {
    my $suffix = shift // '0';

    use Interchange6::Schema::Result::Product;
    use Interchange6::Schema::Result::ProductClass;

    my $product_class = $db->resultset('ProductClass')->search({})->single()
        || make_product_class();
    $product_class->insert;

    return $db->resultset('Product')->new({
        sku_class    => $product_class->sku_class,
        sku  => 'WINGNUT_' . $suffix,
        name => "Wingnut, short ($suffix)",
        short_description => 'Short wingnut',
        description => 'A short wingnut',
        price => 12.34,
        uri => 'http://www.example.com/item/wingnut-' . $suffix,
        weight => 0.1,
        priority => 1,
        gtin => 'GTIN text',
        canonical_sku => 'WINGNUT',
        active => 1,
    });
}


sub make_product_attribute {
    use Interchange6::Schema::Result::ProductAttribute;
    return $db->resultset('ProductAttribute')->new({
        name => 'Color',
        value => 'Black',
    });
}

sub make_products_attributes {
    use Interchange6::Schema::Result::ProductAttributes;

    my $product = make_product()->insert;
    my $attribute = make_product_attribute()->insert;

    return $db->resultset('ProductAttributes')->new({
        sku => $product->sku,
        product_attributes_id => $attribute->product_attributes_id,
    });
}

sub make_product_class {
    use Interchange6::Schema::Result::ProductClass;
    return $db->resultset('ProductClass')->new({
        sku_class => 'sample',
        manufacturer => 'Acme, Inc.',
        name => 'CT-Widget',
        short_description => 'Contra-threaded widget',
        uri => 'http://example.com/ct-widget',
    });
}

sub make_role {

    use Interchange6::Schema::Result::Role;

    return $db->resultset('Role')->new({
        name => 'actor',
        label => 'Actor',
    });
}

sub make_session {
    use Interchange6::Schema::Result::Session;

    return $db->resultset('Session')->new({
        sessions_id => 'abcdef012345',
        session_data => 'Session data',
        session_hash => 'Session hash',
        created => 'now',
    });
}

sub make_setting {
    use Interchange6::Schema::Result::Setting;

    return $db->resultset('Setting')->new({
        scope => 'scope',
        site  => 'site',
        name  => 'setting',
        value => 'This is a setting value.',
        category => 'category',
    });
}

sub make_user_attribute {
    use Interchange6::Schema::Result::UserRole;

    my $user = make_user();
    $user->insert;

    return $db->resultset('UserAttribute')->new({
        users_id => $user->users_id,
        name => 'height',
        value => q{6 ft. 2 in.},
    });
}

sub make_user {
    use Interchange6::Schema::Result::User;

    return $db->resultset('User')->new({
        username       => 'Joe User',
        email          => 'joe@user.com',
        password       => 'aboodabee',
        last_login     => 'now',
        created        => 'now',
        last_modified  => 'now',
    });
}

sub make_user_role {
    use Interchange6::Schema::Result::UserRole;

    my $user = make_user();
    $user->insert;
    my $role = make_role();
    $role->insert;

    return $db->resultset('UserRole')->new({
        users_id => $user->users_id,
        roles_id => $role->roles_id,
    });
}

1;
