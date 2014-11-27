use utf8;

package Interchange6::Schema::Result::Product;

=head1 NAME

Interchange6::Schema::Result::Product

=cut

use base 'Interchange6::Schema::Base::Attribute';

use DateTime;
use Try::Tiny;

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

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
  primary key

=cut

primary_column sku => { data_type => "varchar", is_nullable => 0, size => 64 };

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

column name => { data_type => "varchar", is_nullable => 0, size => 255 };

=head2 short_description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 500

=cut

column short_description => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
    size          => 500
};

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

column description => { data_type => "text", is_nullable => 0 };

=head2 price

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column price => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ]
};

=head2 uri

Unique product uri.  Example "acme-pro-dumbbells".

  data_type: 'varchar'
  is_nullable: 1
  size: 255
  unique constraint

=cut

unique_column uri => { data_type => "varchar", is_nullable => 1, size => 255 };

=head2 weight

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0
  size: [10,2]

=cut

column weight => {
    data_type     => "numeric",
    default_value => "0.0",
    is_nullable   => 0,
    size          => [ 10, 2 ]
};

=head2 priority

Display order priority.

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

column priority =>
  { data_type => "integer", default_value => 0, is_nullable => 0 };

=head2 gtin

EAN or UPC type data.

  data_type: 'varchar'
  is_nullable: 1
  size: 32
  unique constraint

=cut

unique_column gtin => { data_type => "varchar", is_nullable => 1, size => 32 };

=head2 canonical_sku

The SKU of the main product if this product is a variant of a main product, otherwise NULL.

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=cut

column canonical_sku =>
  { data_type => "varchar", is_nullable => 1, size => 64 };

=head2 active

  data_type: 'boolean'
  default_value: 1
  is_nullable: 0

=cut

column active =>
  { data_type => "boolean", default_value => 1, is_nullable => 0 };

=head2 inventory_exempt

  data_type: 'boolean'
  default_value: 0
  is_nullable: 0

=cut

column inventory_exempt =>
  { data_type => "boolean", default_value => 0, is_nullable => 0 };

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

column created =>
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 };

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable   => 0
};

=head1 RELATIONS

=head2 canonical

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

belongs_to
  canonical => "Interchange6::Schema::Result::Product",
  { 'foreign.sku' => 'self.canonical_sku' };

=head2 variants

Type: has_many

Related object: L<Interchange6::Schema::Result::Product>

=cut

has_many
  variants => "Interchange6::Schema::Result::Product",
  { "foreign.canonical_sku" => "self.sku" },
  { cascade_copy            => 0, cascade_delete => 0 };

=head2 cart_products

Type: has_many

Related object: L<Interchange6::Schema::Result::CartProduct>

=cut

has_many
  cart_products => "Interchange6::Schema::Result::CartProduct",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 price_modifiers

Type: has_many

Related object: L<Interchange6::Schema::Result::PriceModifier>

=cut

has_many
  price_modifiers => "Interchange6::Schema::Result::PriceModifier",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 inventory

Type: might_have

Related object: L<Interchange6::Schema::Result::Inventory>

=cut

might_have
  inventory => "Interchange6::Schema::Result::Inventory",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 media_products

Type: has_many

Related object: L<Interchange6::Schema::Result::MediaProduct>

=cut

has_many
  media_products => "Interchange6::Schema::Result::MediaProduct",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 merchandising_products

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

has_many
  merchandising_products =>
  "Interchange6::Schema::Result::MerchandisingProduct",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 merchandising_product_related

Type: has_many

Related object: L<Interchange6::Schema::Result::MerchandisingProduct>

=cut

has_many
  merchandising_product_related =>
  "Interchange6::Schema::Result::MerchandisingProduct",
  { "foreign.sku_related" => "self.sku" },
  { cascade_copy          => 0, cascade_delete => 0 };

=head2 navigation_products

Type: has_many

Related object: L<Interchange6::Schema::Result::NavigationProduct>

=cut

has_many
  navigation_products => "Interchange6::Schema::Result::NavigationProduct",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 orderlines

Type: has_many

Related object: L<Interchange6::Schema::Result::Orderline>

=cut

has_many
  orderlines => "Interchange6::Schema::Result::Orderline",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 product_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductAttribute>

=cut

has_many
  product_attributes => "Interchange6::Schema::Result::ProductAttribute",
  "sku",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 media

Type: many_to_many with media

=cut

many_to_many media => "media_products", "media";

=head2 _product_reviews

Type: has_many

Related object: L<Interchange6::Schema::Result::ProductReview>

This is considered a private method. Please see public L</product_reviews> method.

=cut

has_many
  _product_reviews => "Interchange6::Schema::Result::ProductReview",
  "sku", { cascade_copy => 0 };

=head2 _reviews

Type: many_to_many

This is considered a private method. Accessor to related Message results. Please see public L</reviews> and L</add_to_reviews> methods.

=cut

many_to_many _reviews => "_product_reviews", "message";

=head1 METHODS

Attribute methods are provided by the L<Interchange6::Schema::Base::Attribute> class.

=head2 path

Produces navigation path for this product.
Returns array reference in scalar context.

Uses $type to select specific taxonomy from navigation if present.

=cut

sub path {
    my ( $self, $type ) = @_;

    my $options = {};

    if ( defined $type ) {
        $options = { "navigation.type" => $type };
    }

    # search navigation entries for this product
    my $rs = $self->search_related('navigation_products')
      ->search_related( 'navigation', $options );

    my @path;

    if ( $rs->count == 1 ) {
        my $nav = $rs->next;
        my @anc = $nav->ancestors;

        @path = ( @anc, $nav );
    }

    return wantarray ? @path : \@path;
}

=head2 tier_pricing

Tier pricing can be calculated for a single role and also a combination of several roles.

=over 4

=item Arguments: array reference of L<Role names|Interchange6::Schema::Result::Role/name>

=item Return Value: in scalar context an array reference ordered by quantity ascending of hash references of quantity and price, in list context returns an array instead of array reference

=back

The method always returns the best price for specific price points including
any PriceModifier rows where roles_id is undef.

  my $aref = $product->tier_pricing( 'trade' );

  # [ 
  #   { quantity => 1,   price => 20 }, 
  #   { quantity => 10,  price => 19 }, 
  #   { quantity => 100, price => 18 }, 
  # ]

=cut

# TODO: SysPete is not happy with the initial version of this method.
# Patches always welcome.

sub tier_pricing {
    my ( $self, $args ) = @_;

    my $cond = { 'role.name' => undef };

    if ( $args ) {
        $self->throw_exception(
            "Argument to tier_pricing must be an array reference")
          unless ref($args) eq 'ARRAY';

        $cond = { 'role.name' => [ undef, { -in => $args } ] };
    }

    my @result = $self->price_modifiers->search(
        $cond,
        {
            join   => 'role',
            select => [ 'quantity', { min => 'price' } ],
            as       => [ 'quantity', 'price' ],
            group_by => 'quantity',
            order_by => { -asc => 'quantity' },
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        },
    )->all;

    if ( scalar @result && $result[0]->{quantity} < 1 ) {

        # zero or minus qty should not be possible so we adjust to one if found

        $result[0]->{quantity} = 1;
    }

    # maybe no qty 1 tier is defined so make sure we've got one

    if ( scalar @result && $result[0]->{quantity} == 1 ) {
        $result[0]->{price} = $self->price
          if $self->price < $result[0]->{price};
    }
    else {
        unshift @result, +{ quantity => 1, price => $self->price };
    }

    # Remove quantities that are inappropriate due to price at higher
    # quantity being higher (or same as) that a price at a lower quantity.
    # Normally caused when there are different price breaks for different
    # roles but we have been asked to combine multiple roles.

    my @return;
    my $previous;
    foreach my $i ( @result ) {
        push @return, $i;
        unless ( defined $previous ) {
            $previous = $i->{price};
            next;
        }
        pop @return unless $i->{price} < $previous;
    }

    return wantarray ? @return : \@return;
}

=head2 selling_price

Arguments should be given as a hash reference with the following keys/values:

=over 4

=item * quantity => $quantity

=item * roles => array reference of L<Role names|Interchange6::Schema::Result::Role/name>

=back

PriceModifier rows which have roles_is undefined are always included in the search in addition to any C<roles> that are provided as arguments. This enables promotional prices to be specified between fixed dates in L<Pricing price|Interchange6::Schema::Result::Pricing> to apply to all classes of user whether logged in or not.

C<quantity> defaults to 1 if not supplied.

Returns lowest price from L</price> and L<Pricing price|Interchange6::Schema::Result::Pricing/price>.

Throws exception on bad arguments though unexpected keys in the hash reference will be silently discarded.

=cut

sub selling_price {
    my ( $self, $args ) = @_;

    my $price = $self->price;

    # if we have args check for hashref and if no args then define hashref

    if ($args) {
        $self->throw_exception(
            "Argument to selling_price must be a hash reference")
          unless ref($args) eq 'HASH';
    }
    else {
        $args = {};
    }

    # quantity

    if ( defined $args->{quantity} ) {
        $self->throw_exception(
            sprintf( "Bad quantity: %s", $args->{quantity} ) )
          unless $args->{quantity} =~ /^\d+$/;
    }
    else {
        $args->{quantity} = 1;
    }

    # roles

    my $role_cond = undef;

    if ( $args->{roles} ) {
        $self->throw_exception(
            "Argument roles to selling price must be an array reference")
          unless ref( $args->{roles} ) eq 'ARRAY';

        $role_cond = [ undef, { -in => $args->{roles} } ];
    }

    # now finally we can see if there is a better price for this customer

    my $dtf = $self->result_source->schema->storage->datetime_parser;
    my $today = $dtf->format_datetime(DateTime->today);

    my $tier_price = $self->price_modifiers->search(
        {
            'role.name' => $role_cond,
            quantity => { '<=', $args->{quantity} },
            start_date => [ undef, { '<=', $today } ],
            end_date   => [ undef, { '>=', $today } ],
        },
        {
            join => 'role',
        },
    )->get_column('price')->min;

    $price = defined $tier_price && $tier_price < $price ? $tier_price : $price;

    return $price;
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
    my ( $self, $input, $match_info ) = @_;

    if ( my $canonical = $self->canonical ) {
        return $canonical->find_variant( $input, $match_info );
    }

    my $gather_matches;

    if ( ref($match_info) eq 'HASH' ) {
        $gather_matches = 1;
    }

    # get all variants
    my $all_variants = $self->search_related('variants');
    my $variant;

    while ( $variant = $all_variants->next ) {
        my $sku;

        if ($gather_matches) {
            $sku = $variant->sku;
        }

        my $variant_attributes = $variant->search_related(
            'product_attributes',
            {},
            {
                join     => 'attribute',
                prefetch => 'attribute',
            },
        );

        my %match;

        while ( my $prod_att = $variant_attributes->next ) {
            my $name = $prod_att->attribute->name;

            my $pav_rs =
              $prod_att->search_related( 'product_attribute_values', {},
                { join => 'attribute_value', prefetch => 'attribute_value' } );

            if (   $pav_rs->count != 1
                || !defined $input->{$name}
                || $pav_rs->next->attribute_value->value ne $input->{$name} )
            {
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

        if ( scalar( keys %$input ) == scalar( keys %match ) ) {
            return $variant;
        }
    }

    return;
}

=head2 attribute_iterator( %args )

=over 4

=item Arguments: C<< hashref => 1 >>

=back

Return a hashref of attributes keyed on attribute name instead of an arrayref.

=over 4

=item Arguments: C<< selected => $sku >>

=back

Set the 'selected' SKU. For a child product this is set automatically.

=over 4

=item Returns: An arrayref of attributes complete with their respective attribute values.

=back

For canonical products, it shows all the attributes of the child products.

For a child product, it shows all the attributes of the siblings.

Example of returned arrayref:

   [
     {
       attribute_values => [
         {
           priority => 2,
           selected => 0,
           title => "Pink",
           value => "pink"
         },
         {
           priority => 1,
           selected => 0,
           title => "Yellow",
           value => "yellow"
         }
       ],
       name => "color",
       priority => 2,
       title => "Color"
     },
     {
       attribute_values => [
         {
           priority => 2,
           selected => 0,
           title => "Small",
           value => "small"
         },
         {
           priority => 1,
           selected => 0,
           title => "Medium",
           value => "medium"
         },
       ],
       name => "size",
       priority => 1,
       title => "Size"
     }
   ]

=cut

sub attribute_iterator {
    my ( $self, %args ) = @_;
    my ($canonical);

    if ( $canonical = $self->canonical ) {

        # get canonical object
        $args{selected} = $self->sku;
        return $canonical->attribute_iterator(%args);
    }

    # search for variants
    my $prod_att_rs = $self->search_related('variants')->search_related(
        'product_attributes',
        {},
        {
            join     => 'attribute',
            prefetch => 'attribute',
            order_by => 'attribute.priority',
        },
    );

    my %attributes;

    while ( my $prod_att = $prod_att_rs->next ) {
        my $name = $prod_att->attribute->name;

        unless ( exists $attributes{$name} ) {
            $attributes{$name} = {
                name             => $name,
                title            => $prod_att->attribute->title,
                priority         => $prod_att->attribute->priority,
                value_map        => {},
                attribute_values => [],
            };
        }

        my $att_record = $attributes{$name};

        my $pav_rs = $prod_att->search_related(
            'product_attribute_values',
            {},
            {
                join     => 'attribute_value',
                prefetch => 'attribute_value',
                order_by => { -desc => 'attribute_value.priority' },
            }
        );

        my @values;

        while ( my $prod_att_val = $pav_rs->next ) {
            my %attr_value = (
                value    => $prod_att_val->attribute_value->value,
                title    => $prod_att_val->attribute_value->title,
                priority => $prod_att_val->attribute_value->priority,
                selected => 0,
            );

            if ( !exists $att_record->{value_map}->{ $attr_value{value} } ) {
                $att_record->{value_map}->{ $attr_value{value} } = \%attr_value;
            }

            # determined whether this is the current attribute
            if ( $args{selected} && $prod_att->sku eq $args{selected} ) {
                $att_record->{value_map}->{ $attr_value{value} }->{selected} =
                  1;
            }
        }
    }

    while ( my ( $name, $record ) = each %attributes ) {
        $record->{attribute_values} =
          [ sort { $b->{priority} <=> $a->{priority} }
              values %{ delete $record->{value_map} } ];
    }

    if ( $args{hashref} ) {
        return \%attributes;
    }

    return [ sort { $b->{priority} <=> $a->{priority} } values %attributes ];
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
    my ( $self, @variants ) = @_;
    my %attr_map;
    my $attr_rs = $self->result_source->schema->resultset('Attribute');

    for my $var_ref (@variants) {
        my %attr;
        my %product;
        my $sku;

        unless ( exists $var_ref->{sku} && ( $sku = $var_ref->{sku} ) ) {
            die "SKU missing in input for add_variants.";
        }

        # weed out attribute values
        while ( my ( $name, $value ) = each %$var_ref ) {
            if ( $self->result_source->has_column($name) ) {
                $product{$name} = $value;
                next;
            }

            my ( $attribute, $attribute_value );

            if ( !$attr_map{$name} ) {
                my $set = $attr_rs->search(
                    {
                        name => $name,
                        type => 'variant',
                    }
                );

                if ( $set->count > 1 ) {
                    die "Ambigious variant attribute '$name' for SKU $sku";
                }
                elsif ( !( $attribute = $set->next ) ) {
                    die "Missing variant attribute '$name' for SKU $sku";
                }

                $attr_map{$name} = $attribute;
            }

            # search for attribute value
            unless ( $attribute_value =
                $attr_map{$name}
                ->find_related( 'attribute_values', { value => $value } ) )
            {
                die
"Missing variant attribute value '$value' for attribute '$name' and SKU $sku";
            }

            $attr{$name} = $attribute_value;
        }

        # clone with new values
        $product{canonical_sku} = $self->sku;

        $self->copy( \%product );

        # find or create product attribute and product attribute value
        while ( my ( $name, $value ) = each %attr ) {
            my $product_attribute = $attr_map{$name}
              ->find_or_create_related( 'product_attributes', { sku => $sku } );

            $product_attribute->create_related( 'product_attribute_values',
                { attribute_values_id => $value->id } );
        }
    }

    return $self;
}

=head2 media_by_type

Return a Media resultset with the related media, filtered by type
(e.g. video or image). On the results you can call
C<display_uri("type")> to get the actual uri.

=cut

sub media_by_type {
    my ( $self, $typename ) = @_;
    my @media_out;

    # track back the schema and search the media type id
    my $type = $self->result_source->schema->resultset('MediaType')
      ->find( { type => $typename } );
    return unless $type;
    return $self->media->search(
        {
            media_types_id => $type->media_types_id,
        },
        {
            order_by => 'uri',
        }
    );
}

=head2 product_reviews

Reviews should only be associated with parent products. This method returns the related ProductReview records for a parent product. For a child product the ProductReview records for the parent are returned.

=cut

sub product_reviews {
    my $self = shift;
    if ( $self->canonical_sku ) {
        return $self->canonical->_product_reviews;
    }
    else {
        return $self->_product_reviews;
    }
}

=head2 reviews

Reviews should only be associated with parent products. This method returns the related Message (reviews) records for a parent product. For a child product the Message records for the parent are returned.

=over

=item * Arguments: L<$cond|DBIx::Class::SQLMaker> | undef, L<\%attrs?|DBIx::Class::ResultSet#ATTRIBUTES>

=back

Arguments are passed as paremeters to search the related reviews.

=cut

sub reviews {
    my $self = shift;

    # use parent if I have one
    $self = $self->canonical if $self->canonical_sku;

    return $self->_reviews->search(@_);
}

=head2 top_reviews

Returns the highest-rated approved public reviews for this product. Argument is max number of reviews to return which defaults to 5.

=cut

sub top_reviews {
    my ( $self, $rows ) = @_;
    $rows = 5 unless defined $rows;
    return $self->reviews( { public => 1, approved => 1 },
        { rows => $rows, order_by => { -desc => 'rating' } } );
}

=head2 average_rating

Returns the average rating across all public and approved product reviews or undef if there are no reviews. Optional argument number of decimal places of precision must be a positive integer less than 10 which defaults to 1.

=cut

sub average_rating {
    my ( $self, $precision ) = @_;
    my $avg;

    $precision = 1 unless ( defined $precision && $precision =~ /^\d$/ );

    my $reviews = $self->reviews( { public => 1, approved => 1 } );

    # we use database AVG function if it has one
    try {
        $avg = $reviews->get_column('rating')->func('AVG');
    }
    catch {
        $avg = $reviews->get_column('rating')->sum / $reviews->count;
    };
    return defined $avg ? sprintf( "%.*f", $precision, $avg ) : undef;
}

=head2 add_to_reviews

Reviews should only be associated with parent products. This method returns the related ProductReview records for a parent product. For a child product the ProductReview records for the parent are returned.

=cut

# much of this was cargo-culted from DBIx::Class::Relationship::ManyToMany

sub add_to_reviews {
    my $self = shift;
    @_ > 0
      or $self->throw_exception( "add_to_reviews needs an object or hashref" );
    my $rset_message = $self->result_source->schema->resultset("Message");
    my $obj;
    if ( ref $_[0] ) {
        if ( ref $_[0] eq 'HASH' ) {
            $_[0]->{type} = "product_review";
            $obj = $rset_message->create( $_[0] );
        }
        else {
            $obj = $_[0];
            unless ( my $type = $obj->message_type->name eq "product_review" ) {
                $self->throw_exception(
                    "cannot add message type $type to reviews" );
            }
        }
    }
    else {
        push @_, type => "product_review";
        $obj = $rset_message->create( {@_} );
    }
    my $sku = $self->canonical_sku || $self->sku;
    $self->product_reviews->create( { sku => $sku, messages_id => $obj->id } );
    return $obj;
}

=head2 set_reviews

=over 4

=item Arguments: (\@hashrefs_of_col_data | \@result_objs)

=item Return Value: not defined

=back

Similar to L<DBIx::Class::Relationship::Base/set_$rel> except that this method DOES delete objects in the table on the right side of the relation.

=cut

sub set_reviews {
    my $self = shift;
    @_ > 0
      or $self->throw_exception(
        "set_reviews needs a list of objects or hashrefs" );
    my @to_set = ( ref( $_[0] ) eq 'ARRAY' ? @{ $_[0] } : @_ );
    $self->product_reviews->delete_all;
    $self->add_to_reviews( $_, ref( $_[1] ) ? $_[1] : {} ) for (@to_set);
}

=head2 quantity_in_stock

Returns undef if L<inventory_exempt> is true and otherwise returns the
quantity of the product in the inventory. For a product variant the
quantity returned is for the variant itself whereas for a canonical
(parent) product the quantity returned is the total for all variants.

=cut

sub quantity_in_stock {
    my $self = shift;
    my $quantity;
    my $variants = $self->variants;
    if ( $variants->count ) {
        my $not_exempt = $variants->search( { inventory_exempt => 0 } );
        if ( $not_exempt->count ) {
            $quantity = $not_exempt->search_related( 'inventory',
                { quantity => { '>' => 0 } } )->get_column('quantity')->sum;
        }
    }
    elsif ( ! $self->inventory_exempt ) {
        my $inventory = $self->inventory;
        $quantity = defined $inventory ? $self->inventory->quantity : 0;
    }
    return $quantity;
}


=head2 delete

Overload delete to force removal of any product reviews. Only parent products should have reviews so in the case of child products no attempt is made to delete reviews.

=cut

# FIXME: (SysPete) There ought to be a way to force this with cascade delete.

sub delete {
    my ( $self, @args ) = @_;
    my $guard = $self->result_source->schema->txn_scope_guard;
    $self->product_reviews->delete_all unless defined $self->canonical_sku;
    $self->next::method(@args);
    $guard->commit;
}

1;
