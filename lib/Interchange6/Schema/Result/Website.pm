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

=cut

column name => { data_type => "varchar", size => 255 };

=head2 description

Description of website/shop

=cut

column description => { data_type => "text", default_value => '' };

=head2 active

Boolean showing whether site is currently active.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head2 primary_currency_iso_code

Default currency for this site.

FK on L<Interchange6::Schema::Result::Currency/iso_code>

=cut

column primary_currency_iso_code => { data_type => "char", size => 3 };

=head1 RELEATIONS

=head2 primary_currency

The primary (default) currency for this website.

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Currency>

=cut

belongs_to
  primary_currency => "Interchange6::Schema::Result::Currency",
  "primary_currency_iso_code";

=head2 website_currencies

Relation to the Website <-> Currency link table

Type: has_many

Related object: L<Interchange6::Schema::Result::WebsiteCurrency>

=cut

has_many
  website_currencies => "Interchange6::Schema::Result::WebsiteCurrency",
  "website_id";

=head2 active_website_currencies

Relation to the Website <-> Currency link table with additional join condition
that L<Interchange6::Schema::Result::WebsiteCurrency/active> is true.

Type: has_many

Related object: L<Interchange6::Schema::Result::WebsiteCurrency>

=cut

has_many
  active_website_currencies => "Interchange6::Schema::Result::WebsiteCurrency",
  sub {
    my $args = shift;
    return {
        "$args->{foreign_alias}.website_id" =>
          { -ident => "$args->{self_alias}.website_id" },
        -bool => "$args->{foreign_alias}.active",
    };
  };

=head2 active_currencies

  Type: many_to_many

  Composing rels: L</active_website_currencies> -> currency

=cut

many_to_many active_currencies => "active_website_currencies", "currency";

=head2 products

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

has_many
  products => "Interchange6::Schema::Result::Product",
  "website_id";

=head2 users

Type: has_many

Related object: L<Interchange6::Schema::Result::User>

=cut

has_many
  users => "Interchange6::Schema::Result::User",
  "users_id";

1;
