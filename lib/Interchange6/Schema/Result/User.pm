use utf8;
package Interchange6::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(FilterColumn EncodedColumn InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 users_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_users_id_seq'

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 255

The username is automatically converted to lowercase so
we make sure that the unique constraint on username works.

=head2 nickname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

nickname is automatically converted to lowercase

=head2 email

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255
  encode_column: 1
  encode_class: 'Digest'
  encode_args: { algorithm => 'SHA-512', format => 'hex', salt_length => 10 }
  encode_check_method: 'check_password'

=head2 first_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 last_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 last_login

  data_type: 'datetime'
  is_nullable: 1

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "users_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_users_id_seq",
  },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "nickname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "password",
  {
   data_type           => "varchar",
   default_value       => "",
   is_nullable         => 0,
   size                => 255, 
   encode_column       => 1,
   encode_class        => 'Digest',
   encode_args         => { algorithm => 'SHA-512', format => 'hex', salt_length => 10 },
   encode_check_method => 'check_password',
},
  "first_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "last_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "last_login",
  { data_type => "datetime", is_nullable => 1 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
  "last_modified",
  { data_type => "datetime", set_on_create => 1, set_on_update => 1, is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

__PACKAGE__->filter_column( username => {
    filter_to_storage => sub {lc($_[1])},
});

__PACKAGE__->filter_column( nickname => {
    filter_to_storage => sub {lc($_[1])},
});

=head1 METHODS

=head2 add_attribute

Add user attribute.

$user->add_attribute('hair_color', 'blond');

Where 'hair_color' is Attribute and 'blond' is AttributeValue

=cut

sub add_attribute {
    my ($self, $attr, $attr_value) = @_;

    # find or create attributes
    my ($attribute, $attribute_value) = $self->find_or_create_attribute($attr, $attr_value);

    # create user_attribute object
    my $user_attribute = $self->find_or_create_related('UserAttribute',
                                                       {attributes_id => $attribute->id});
    # create user_attribute_value
    $user_attribute->create_related('UserAttributeValue',
                                    {attribute_values_id => $attribute_value->id});

    return $self;
}

=head2 update_attribute

Update user atttibute

$user->update_attribute('hair_color', 'brown');

=cut

sub update_attribute {
    my ($self, $attr, $attr_value) = @_;

    my ($attribute, $attribute_value) = $self->find_or_create_attribute($attr, $attr_value);

    my (undef, $user_attribute_value) = $self->find_user_attribute_value($attribute);

    $user_attribute_value->update({attribute_values_id => $attribute_value->id});

    return $self;
}

=head2 delete_attribute

Delete user attribute

$user->delete_attribute('hair_color', 'purple');

=cut

sub delete_attribute {
    my ($self, $attr, $attr_value) = @_;

    my ($attribute) = $self->find_or_create_attribute($attr, $attr_value);

    my ($user_attribute, $user_attribute_value) = $self->find_user_attribute_value($attribute);

    #delete
    $user_attribute_value->delete;
    $user_attribute->delete;

    return $self;
}

=head2 find_attribute_value

Finds the attribute value for the current user or a defined user
If $object is passed the entire attribute_value object will be returned

=cut

sub find_attribute_value {
    my ($self, $attr, $object) = @_;

    # attribute must be set
    unless ($attr) {
       die "find_attribute_value input requires attribute value";
    };

    my $attribute = $self->result_source->schema->resultset('Attribute')->find({ name => $attr });

    unless ($attribute) {
        return;
    }

    # find records
    my $user_attribute = $self->find_related('UserAttribute',
                                            {attributes_id => $attribute->id});

    unless ($user_attribute) {
        return;
    }

    my $user_attribute_value = $user_attribute->find_related('UserAttributeValue',
                                            {user_attributes_id => $user_attribute->id});
    unless ($user_attribute_value) {
        return;
    }

    my $attribute_value = $user_attribute_value->find_related('AttributeValue',
                                            {user_attribute_values_id => $user_attribute_value->id});
    if ($object) {
        return $attribute_value;
    }
    else {
        return $attribute_value->value;
    }
};

=head2 update_attribute_value

Finds the attribute value and updates it. Be careful to only update
attribute values that are unique to that user or you could update 
multiple users.

=cut

sub update_attribute_value {
    my ($self, $attr, $attr_value) = @_;

    my $attribute_value = $self->find_attribute_value($attr,{object => 1}); 

    unless(defined($attribute_value->value)) {
        die "attribute_value does not exist for update_attribute_value";
    }

    unless (defined($attr_value)) {
        die "Missing attribute value for update_attribute_value"; 
    }

    $attribute_value->update({'value' => $attr_value});

    return;
};

=head2 find_or_create_attribute

Find or create attribute and attribute_value.

=cut

sub find_or_create_attribute {
    my ($self, $attr, $attr_value) = @_;

    unless (defined($attr && $attr_value)) {
        die "Both attribute and attribute value are required for find_or_create_attribute";
    }

    my $attribute = $self->result_source->schema->resultset('Attribute')->find_or_create({ name => $attr });

    # create attribute_values
    my $attribute_value = $attribute->find_or_create_related('AttributeValue',
                                                        {value => $attr_value}
                                                            );

    return ($attribute, $attribute_value);
};

=head2 find_user_attribute_value

From a $user->attribute $user_attribute, $user_attribute_value is returned.

=cut

sub find_user_attribute_value {
    my ($self, $attribute) = @_;

    unless($attribute) {
        die "Missing attribute object for find_user_attribute_value";
    }

    my $user_attribute = $self->find_related('UserAttribute',
                                            {attributes_id => $attribute->id});

    my $user_attribute_value = $user_attribute->find_related('UserAttributeValue',
                                            {user_attributes_id => $user_attribute->id});

    return ($user_attribute, $user_attribute_value);
}

=head1 PRIMARY KEY

=over 4

=item * L</users_id>

=back

=cut

__PACKAGE__->set_primary_key("users_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<users_username>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("users_username", ["username"]);

=head2 C<users_nickname>

=over 4

=item * L</nickname>

=back

=cut

__PACKAGE__->add_unique_constraint("users_nickname", ["nickname"]);

=head1 RELATIONS

=head2 Address

Type: has_many

Related object: L<Interchange6::Schema::Result::Address>

=cut

__PACKAGE__->has_many(
  "Address",
  "Interchange6::Schema::Result::Address",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Cart

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

__PACKAGE__->has_many(
  "Cart",
  "Interchange6::Schema::Result::Cart",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Order

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "Order",
  "Interchange6::Schema::Result::Order",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 UserAttribute

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttribute>

=cut

__PACKAGE__->has_many(
  "UserAttribute",
  "Interchange6::Schema::Result::UserAttribute",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 UserRole

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "UserRole",
  "Interchange6::Schema::Result::UserRole",
  { "foreign.users_id" => "self.users_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "UserRole", "Role");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:38:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8lfuxYQvCHVW0GTmbVAf6w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
