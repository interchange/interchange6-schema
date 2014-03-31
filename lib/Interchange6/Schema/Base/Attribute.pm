use utf8;
package Interchange6::Schema::Base::Attribute;

=head1 NAME

Interchange6::Schema::Base::Attribute

=cut

use strict;
use warnings;

=head1 DESCRIPTION

This Base class in intended to be added to classes that require attributes
examples of these classes include User, Navigation and Product.

=over 4

=item B<Assumptions>

This module assumes that your using standardized class naming.

example: User in this example is the $base class so UserAttribute, 
UserAttributeValue class naming would be used.  These would
also use user_attributes_id and user_attributes_values_id as primary
keys.  In general follow the example classes listed in description.

=back

=cut

=head1 SYNOPSIS

    $navigation_object->add_attribute('meta_title','My very seductive title here!');

=head1 METHODS

=head2 add_attribute

Add attribute.

$base->add_attribute('hair_color', 'blond');

Where 'hair_color' is Attribute and 'blond' is AttributeValue

=cut

sub add_attribute {
    my ($self, $attr, $attr_value) = @_;
    my $base = $self->result_source->source_name;

    # find or create attributes
    my ($attribute, $attribute_value) = $self->find_or_create_attribute($attr, $attr_value);

    # create base_attribute object
    my $base_attribute = $self->find_or_create_related($base . 'Attribute',
                                                       {attributes_id => $attribute->id});
    # create base_attribute_value
    $base_attribute->create_related($base . 'AttributeValue',
                                    {attribute_values_id => $attribute_value->id});

    return $self;
}

=head2 update_attribute_value

Update base attribute value

$base->update_attribute('hair_color', 'brown');

=cut

sub update_attribute_value {
    my ($self, $attr, $attr_value) = @_;
    my $base = $self->result_source->source_name;

    my ($attribute, $attribute_value) = $self->find_or_create_attribute($attr, $attr_value);

    my (undef, $base_attribute_value) = $self->find_base_attribute_value($attribute, $base);

    $base_attribute_value->update({attribute_values_id => $attribute_value->id});

    return $self;
}

=head2 delete_attribute

Delete $base attribute

$base->delete_attribute('hair_color', 'purple');

=cut

sub delete_attribute {
    my ($self, $attr, $attr_value) = @_;
    my $base = $self->result_source->source_name;

    my ($attribute) = $self->find_or_create_attribute($attr, $attr_value);

    my ($base_attribute, $base_attribute_value) = $self->find_base_attribute_value($attribute, $base);

    #delete
    $base_attribute_value->delete;
    $base_attribute->delete;

    return $self;
}

=head2 search_attributes

Returns attributes for a $base object

my $attr_rs = shop_product->find('WBA0001')->search_attributes;

=cut

sub search_attributes {
    my ($self) = @_;
    my $base = $self->result_source->source_name;

    my $base_attributes = $self->search_related($base . 'Attribute');

    my $attributes = $base_attributes->search_related('Attribute');

    return $attributes;
}

=head2 find_attribute_value

Finds the attribute value for the current object or a defined object value.
If $object is passed the entire attribute_value object will be returned. $args can
accept both scaler and hash inputs.

$base->find_attribute_value({name => $attr_name, priority => $attr_priority}, {object => 1});

=cut

sub find_attribute_value {
    my ($self, $args, $object) = @_;
    my $base = $self->result_source->source_name;
    my $lc_base = lc($base);

    my %attr = ref($args) eq 'HASH' ? %{$args} : (name => $args);

    # attribute must be set
    unless ($args) {
       die "find_attribute_value input requires atleast a valid attribute value";
    };

    my $attribute = $self->result_source->schema->resultset('Attribute')->find( \%attr );

    unless ($attribute) {
        return;
    }

    # find records
    my $base_attribute = $self->find_related($base . 'Attribute',
                                            {attributes_id => $attribute->id});

    unless ($base_attribute) {
        return;
    }

    my $base_attribute_value = $base_attribute->find_related($base .'AttributeValue',
                                            {$lc_base . '_attributes_id' => $base_attribute->id});
    unless ($base_attribute_value) {
        return;
    }

    my $attribute_value = $base_attribute_value->find_related('AttributeValue',
                                            {lc($base) .'_attribute_values_id' => $base_attribute_value->id});
    if ($object) {
        return $attribute_value;
    }
    else {
        return $attribute_value->value;
    }
};

=head2 find_or_create_attribute

Find or create attribute and attribute_value.

=cut

sub find_or_create_attribute {
    my ($self, @args) = @_;

    # check if $args[0] is a HASH if not set as name
    my %attr = ref($args[0]) eq 'HASH' ? %{$args[0]} : (name => $args[0]);

    unless (defined($args[0] && $args[1])) {
        die "Both attribute and attribute value are required for find_or_create_attribute";
    }

    # check if $args[1] is a HASH if not set as value
    my %attr_value = ref($args[1]) eq 'HASH' ? %{$args[1]} : (value => $args[1]);

    my $attribute = $self->result_source->schema->resultset('Attribute')->find_or_create( %attr );

    # create attribute_values
    my $attribute_value = $attribute->find_or_create_related('AttributeValue', \%attr_value );

    return ($attribute, $attribute_value);
};

=head2 find_base_attribute_value

From a $base->attribute input $base_attribute, $base_attribute_value is returned.

=cut

sub find_base_attribute_value {
    my ($self, $attribute, $base) = @_;
    my $lc_base = lc($base);

    unless($attribute) {
        die "Missing attribute object for find_base_attribute_value";
    }

    my $base_attribute = $self->find_related($base . 'Attribute',
                                            {attributes_id => $attribute->id});

    my $base_attribute_value = $base_attribute->find_related($base . 'AttributeValue',
                                            {$lc_base . '_attributes_id' => $base_attribute->id});

    return ($base_attribute, $base_attribute_value);
}


1;
