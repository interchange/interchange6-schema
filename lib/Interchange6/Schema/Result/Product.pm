use utf8;
package Interchange6::Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Product

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<products>

=cut

__PACKAGE__->table("products");

=head1 DESCRIPTION

The products table contains three product types parent, child and single.

=over

=item *

B<Parent Product> A parent product is a container product in which variations of parent product or "child products" are linked.

=item *

B<Child Product> A child product for example "Acme Pro 10lb Dumbbell" would include the canonical_sku of the parent item whose description might be something like "Acme Pro Dumbbell".  In general a child product would contain attributes while a parent product would not.

=item *

B<Single Product> A single product does not have child products and will become a parent product if a child product exists.

=back

B<sku:>

B<name:>

B<short_description:>

B<description:>

B<price:>

B<uri:> Unique product uri.  Example "acme-pro-dumbbells"

B<weight:>

B<priority:> Display order priority.

B<gtin:> EAN or UPC type data.

B<canonical_sku:> If the product is a child of a parent product the parent product sku would be referenced here.

B<active:> Default is true

B<inventory_exempt:>

=cut

=head1 ACCESSORS

=head2 sku

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 short_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

=head2 description

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=head2 uri

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=head2 priority

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gtin

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 canonical_sku

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 inventory_exempt

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sku",
  { data_type => "varchar", is_nullable => 0, size => 32 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "short_description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 500 },
  "description",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "price",
  { data_type => "numeric", default_value => "0.0", is_nullable => 0, size => [10, 2] },
  "uri",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "weight",
  { data_type => "numeric", default_value => "0.0", is_nullable => 0, size => [10, 2] },
  "priority",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "gtin",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "canonical_sku",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "inventory_exempt",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 METHODS

=head2 path

Produces navigation path for this product.
Returns array reference in scalar context.

=cut

sub path {
    my ($self) = @_;

    # search navigation entries for this product
    my $rs = $self->search_related('NavigationProduct')->search_related('Navigation');

    my @path;

    if ($rs->count == 1) {
        my $nav = $rs->next;
        my @anc = $nav->ancestors;

        @path = (@anc, $nav);
    }

    return wantarray ? @path : \@path;
}

=head2 attribute_iterator

Returns nested iterator for product attributes.

=cut

sub attribute_iterator {
    my ($self) = @_;

    my $prod_att_rs = $self->search_related('ProductAttribute',
                                         {},
                                         {join => 'Attribute',
                                          prefetch => 'Attribute',
                                         },
                                        );

    my @attributes;

    while (my $prod_att = $prod_att_rs->next) {
        my $pav_rs = $prod_att->search_related('ProductAttributeValue',{}, {join => 'AttributeValue', prefetch => 'AttributeValue'});

        my @values;

        while (my $prod_att_val = $pav_rs->next) {
            push @values, {value => $prod_att_val->AttributeValue->value,
                           title => $prod_att_val->AttributeValue->title,
                          };
        }

        push @attributes, {name => $prod_att->Attribute->name,
                           title => $prod_att->Attribute->title,
                           attribute_values => \@values,
                          };
    }

    return \@attributes;
}

=head1 PRIMARY KEY

=over 4

=item * L</sku>

=back

=cut

__PACKAGE__->set_primary_key("sku");

=head1 UNIQUE CONSTRAINTS

=head2 C<products_gtin>

=over 4

=item * L</gtin>

=back

=cut

__PACKAGE__->add_unique_constraint("products_gtin", ["gtin"]);

=head2 C<products_uri>

=over 4

=item * L</uri>

=back

=cut

__PACKAGE__->add_unique_constraint("products_uri", ["uri"]);

=head1 RELATIONS

=head2 CartProduct

Type: has_many

Related object: L<Interchange6::Schema::Result::CartProduct>

=cut

__PACKAGE__->has_many(
  "CartProducts",
  "Interchange6::Schema::Result::CartProduct",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 GroupPricing

Type: has_many

Related object: L<Interchange6::Schema::Result::GroupPricing>

=cut

__PACKAGE__->has_many(
  "GroupPricings",
  "Interchange6::Schema::Result::GroupPricing",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Inventory

Type: might_have

Related object: L<Interchange6::Schema::Result::Inventory>

=cut

__PACKAGE__->might_have(
  "Inventory",
  "Interchange6::Schema::Result::Inventory",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 MediaDisplay

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaDisplay>

=cut

__PACKAGE__->has_many(
  "MediaDisplay",
  "Interchange6::Schema::Result::MediaDisplay",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 MediaProduct

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaProduct>

=cut

__PACKAGE__->has_many(
  "MediaProducts",
  "Interchange6::Schema::Result::MediaProduct",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 MerchandisingProduct

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

__PACKAGE__->has_many(
  "MerchandisingProduct",
  "Interchange6::Schema::Result::MerchandisingProduct",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 MerchandisingProductRelated

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

__PACKAGE__->has_many(
  "MerchandisingProductRelated",
  "Interchange6::Schema::Result::MerchandisingProduct",
  { "foreign.sku_related" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 NavigationProduct

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationProduct>

=cut

__PACKAGE__->has_many(
  "NavigationProduct",
  "Interchange6::Schema::Result::NavigationProduct",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Orderline

Type: has_many

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

__PACKAGE__->has_many(
  "Orderline",
  "Interchange6::Schema::Result::Orderline",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ProductAttribute

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

__PACKAGE__->has_many(
  "ProductAttribute",
  "Interchange6::Schema::Result::ProductAttribute",
  { "foreign.sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3/NTsOSzy7fqdEvwhVcdXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
