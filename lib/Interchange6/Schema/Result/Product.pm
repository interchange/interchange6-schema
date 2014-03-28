use utf8;
package Interchange6::Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Product

=cut

use strict;
use warnings;

use base qw(DBIx::Class::Core Interchange6::Schema::Base::Attribute);

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

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

=cut

=head1 ACCESSORS

=head2 sku

  data_type: 'varchar'
  is_nullable: 0
  size: 64

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

Unique product uri.  Example "acme-pro-dumbbells".

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=head2 priority

Display order priority.

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 gtin

EAN or UPC type data.

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 canonical_sku

The SKU of the main product if this product is a variant of a main product, otherwise NULL.

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 inventory_exempt

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "sku",
  { data_type => "varchar", is_nullable => 0, size => 64 },
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
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "inventory_exempt",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
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

=head2 find_variant \%input [\%match_info]

Find product variant with the given attribute values
in $input.

Returns variant in case of success.

Returns undef in case of failure.

You can pass an optional hash reference \%match_info
which is filled with attribute matches (only valid
in case of failure).

=cut

sub find_variant {
    my ($self, $input, $match_info) = @_;

    if (my $canonical = $self->canonical) {
        return $canonical->find_variant($input, $match_info);
    }

    my $gather_matches;

    if (ref($match_info) eq 'HASH') {
        $gather_matches = 1;
    }

    # get all variants
    my $all_variants = $self->search_related('Variant');
    my $variant;

    while ($variant = $all_variants->next) {
        my $sku;

        if ($gather_matches) {
            $sku = $variant->sku;
        }

        my $variant_attributes = $variant->search_related('ProductAttribute',
                                         {},
                                         {join => 'Attribute',
                                          prefetch => 'Attribute',
                                         },
                                        );

        my %match;

        while (my $prod_att = $variant_attributes->next) {
            my $name = $prod_att->Attribute->name;

            my $pav_rs = $prod_att->search_related('ProductAttributeValue',{}, {join => 'AttributeValue', prefetch => 'AttributeValue'});

            if ($pav_rs->count != 1 ||
                    ! defined $input->{$name} ||
                    $pav_rs->next->AttributeValue->value ne $input->{$name}) {
                if ($gather_matches) {
                    $match_info->{$sku}->{$name} = 0;
                    next;
                }
                else {
                    last;
                }
            }

            if ($gather_matches) {
                $match_info->{$sku}->{$name} = 1;
            }

            $match{$name} = 1;
        }

        if (scalar(keys %$input) == scalar(keys %match)) {
            return $variant;
        }
    }

    return;
};

=head2 attribute_iterator

Returns nested iterator for product attributes.

For canonical products, it shows all the attributes
of the child products.

For a child product, it shows all the attributes
of the siblings.

=cut

sub attribute_iterator {
    my ($self, %args) = @_;
    my ($canonical);

    if ($canonical = $self->canonical) {
        # get canonical object
        $args{selected} = $self->sku;
        return $canonical->attribute_iterator(%args);
    }

    # search for variants
    my $prod_att_rs = $self->search_related('Variant')->search_related('ProductAttribute',
                                         {},
                                         {join => 'Attribute',
                                          prefetch => 'Attribute',
                                          order_by => 'Attribute.priority',
                                         },
                                        );

    my %attributes;

    while (my $prod_att = $prod_att_rs->next) {
        my $name = $prod_att->Attribute->name;

        unless (exists $attributes{$name}) {
            $attributes{$name} = {name => $name,
                                  title => $prod_att->Attribute->title,
                                  priority => $prod_att->Attribute->priority,
                                  value_map => {},
                                  attribute_values => [],
                              }
        }

        my $att_record = $attributes{$name};

        my $pav_rs = $prod_att->search_related('ProductAttributeValue',
                                               {},
                                               {join => 'AttributeValue', prefetch => 'AttributeValue',                                           order_by => 'AttributeValue.priority desc',});

        my @values;

        while (my $prod_att_val = $pav_rs->next) {
            my %attr_value = (value => $prod_att_val->AttributeValue->value,
                              title => $prod_att_val->AttributeValue->title,
                              priority => $prod_att_val->AttributeValue->priority,
                              selected => 0,
                          );

            if (! exists $att_record->{value_map}->{$attr_value{value}}) {
                $att_record->{value_map}->{$attr_value{value}} = \%attr_value;
            }

            # determined whether this is the current attribute
            if ($args{selected} && $prod_att->sku eq $args{selected}) {
                $att_record->{value_map}->{$attr_value{value}}->{selected} = 1;
            }
        }
    }

    while (my($name, $record) = each %attributes) {
        $record->{attribute_values} =
            [sort {$b->{priority} <=> $a->{priority}} values %{delete $record->{value_map}}];
    }

    if ($args{hashref}) {
        return \%attributes;
    }

    return [sort {$b->{priority} <=> $a->{priority}} values %attributes];
}

=head2 add_variants @variants

Add variants from a list of hash references.

Returns product object.

Each hash reference contains attributes and column
data which overrides data from the canonical product.

The canonical sku of the variant is automatically set.

Example for the hash reference (attributes in the first line):

     {color => 'yellow', size => 'small',
      sku => 'G0001-YELLOW-S',
      name => 'Six Small Yellow Tulips',
      uri => 'six-small-yellow-tulips'}

=cut

sub add_variants {
    my ($self, @variants) = @_;
    my %attr_map;
    my $attr_rs = $self->result_source->schema->resultset('Attribute');

    for my $var_ref (@variants) {
        my %attr;
        my %product;
        my $sku;

        unless (exists $var_ref->{sku} && ($sku = $var_ref->{sku})) {
            die "SKU missing in input for add_variants.";
        }

        # weed out attribute values
        while (my ($name, $value) = each %$var_ref) {
            if ($self->result_source->has_column($name)) {
                $product{$name} = $value;
                next;
            }

            my ($attribute, $attribute_value);

            if (! $attr_map{$name}) {
                my $set = $attr_rs->search({name => $name,
                                            type => 'variant',
                                        });

                if ($set->count > 1) {
                    die "Ambigious variant attribute '$name' for SKU $sku";
                }
                elsif (! ($attribute = $set->next)) {
                    die "Missing variant attribute '$name' for SKU $sku";
                }

                $attr_map{$name} = $attribute;
            }

            # search for attribute value
            unless ($attribute_value = $attr_map{$name}->find_related('AttributeValue',
                                                                {value => $value})) {
                die "Missing variant attribute value '$value' for attribute '$name' and SKU $sku";
            }

            $attr{$name} = $attribute_value;
        }

        # clone with new values
        $product{canonical_sku} = $self->sku;

        $self->copy(\%product);

        # find or create product attribute and product attribute value
        while (my ($name, $value) = each %attr) {
            my $product_attribute = $attr_map{$name}->find_or_create_related(
                'ProductAttribute', {sku => $sku});

            $product_attribute->create_related('ProductAttributeValue',
                                               {attribute_values_id => $value->id}
                                                   );
        }
    }

    return $self;
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

=head2 canonical

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
    "canonical",
    "Interchange6::Schema::Result::Product",
    {'foreign.sku' => 'self.canonical_sku'},
);

=head2 Variant

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->has_many(
  "Variant",
  "Interchange6::Schema::Result::Product",
  { "foreign.canonical_sku" => "self.sku" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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
