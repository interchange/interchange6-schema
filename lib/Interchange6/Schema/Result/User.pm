use utf8;

package Interchange6::Schema::Result::User;

=head1 NAME

Interchange6::Schema::Result::User

=cut

use base 'Interchange6::Schema::Base::Attribute';

use Interchange6::Schema::Candy -components =>
  [qw(EncodedColumn InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 users_id

Primary key.

=cut 

primary_column users_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    sequence          => "users_users_id_seq",
};

=head2 username

The username is automatically converted to lowercase so
we make sure that the unique constraint on username works.

=cut

unique_column username => {
    data_type   => "varchar",
    size        => 255,
};

=head2 nickname

Unique nickname for user.

=cut

unique_column nickname => {
    data_type   => "varchar",
    is_nullable => 1,
    size        => 255,
};

=head2 email

email address.

=cut

column email => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 password

Hashed password using L<Crypt::Eksblowfish::Bcrypt>. Check password method
is C<check_password>.

=cut

column password => {
    data_type           => "varchar",
    default_value       => "",
    size                => 60,
    encode_column       => 1,
    encode_class        => 'Crypt::Eksblowfish::Bcrypt',
    encode_args         => { key_nul => 1, cost => 14 },
    encode_check_method => 'check_password',
};

=head2 first_name

User's first name.

=cut

column first_name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 last_name

User's last name.

=cut

column last_name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 last_login

Last login returned as L<DateTime> object.

=cut

column last_login => {
    data_type   => "datetime",
    is_nullable => 1,
};

=head2 fail_count

Count of failed logins since last successful login.

=cut

column fail_count => {
    data_type     => "integer",
    default_value => 0,
};

=head2 reset_token

Used to store password reset token.

=cut

column reset_token => {
    data_type => "text",
    is_nullable   => 1,

};

=head2 created

Date and time when this record was created returned as L<DateTime> object.
Value is auto-set on insert.

=cut

column created => {
    data_type     => "datetime",
    set_on_create => 1,
};

=head2 last_modified

Date and time when this record was last modified returned as L<DateTime> object.
Value is auto-set on insert and update.

=cut

column last_modified => {
    data_type     => "datetime",
    set_on_create => 1,
    set_on_update => 1,
};

=head2 active

Is this user account active? Default is yes.

=cut

column active => {
    data_type     => "boolean",
    default_value => 1,
};

=head1 RELATIONS

=head2 addresses

Type: has_many

Related object: L<Interchange6::Schema::Result::Address>

=cut

has_many
  addresses => "Interchange6::Schema::Result::Address",
  "users_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 carts

Type: has_many

Related object: L<Interchange6::Schema::Result::Cart>

=cut

has_many
  carts => "Interchange6::Schema::Result::Cart",
  "users_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

has_many
  orders => "Interchange6::Schema::Result::Order",
  "users_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 user_attributes

Type: has_many

Related object: L<Interchange6::Schema::Result::UserAttribute>

=cut

has_many
  user_attributes => "Interchange6::Schema::Result::UserAttribute",
  "users_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 user_roles

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

has_many
  user_roles => "Interchange6::Schema::Result::UserRole",
  "users_id";

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

many_to_many roles => "user_roles", "role";

=head2 approvals

Type: has_many

Related object: L<Interchange6::Schema::Result::Message> FK C<approved_by_users_id>

=cut

has_many
  approvals => "Interchange6::Schema::Result::Message",
  { 'foreign.approved_by_users_id' => 'self.users_id' };

=head2 messages

Type: has_many

Related object: L<Interchange6::Schema::Result::Message> FK C<author_users_id>

=cut

has_many
  messages => "Interchange6::Schema::Result::Message",
  { 'foreign.author_users_id' => 'self.users_id' };

=head1 METHODS

Attribute methods are provided by the L<Interchange6::Schema::Base::Attribute> class.

=head2 new

Overloaded method. Die if username is undef, empty string or not lowercase.

=cut

sub new {
    my ( $class, $attrs ) = @_;

    # should have the same checks in update
    die "username cannot be undef" unless defined $attrs->{username};
    die "username cannot be empty string" if $attrs->{username} eq '';
    die "username must be lowercase"
      if $attrs->{username} ne lc( $attrs->{username} );

    my $new = $class->next::method($attrs);
    return $new;
}

=head2 insert

Overloaded method. Always add new users to Role with name 'user'.

=cut

sub insert {
    my ($self, @args) = @_;
    
    my $guard = $self->result_source->schema->txn_scope_guard;

    $self->next::method(@args);

    my $user_role = $self->result_source->schema->resultset('Role')
      ->find( { name => 'user' } );

    if ( $user_role ) {
        $self->create_related( 'user_roles', { roles_id => $user_role->id } );
    }
    else {
        # we should never get here
        $self->throw_exception(
            "Role with name 'user' must exist when creating a new user");
    }
    
    $guard->commit;
    return $self;
}

=head2 update

Overloaded method. Throw exception if username is undef, empty string or not lowercase.

=cut

sub update {
    my ( $self, $upd ) = @_;

    my $username;

    # username may have been passed as arg or previously set

    if ( exists $upd->{username} ) {
        $username = $upd->{username};
    }
    else {
        my %data = $self->get_dirty_columns;
        $username = $data{username} if exists $data{username};
    }

    # should have the same checks in new
    if ($username) {

        $self->throw_exception("username cannot be undef")
          unless defined $username;

        $self->throw_exception("username cannot be empty string")
          if $username eq '';

        $self->throw_exception("username must be lowercase")
          if $username ne lc($username);

    }

    return $self->next::method($upd);
}

=head2 blog_posts

Returns resultset of messages that are blog posts (Message->type eq 'blog_post')

=cut

sub blog_posts {
    my $self = shift;
    return $self->messages->search( { type => 'blog_post' } );
}

=head2 name

Returns L</first_name> and L</last_name> joined by a single space.

=cut

sub name {
    my $self = shift;
    return $self->first_name . " " . $self->last_name;
}

=head2 reviews

Returns resultset of messages that are reviews (referenced by ProductReview class).

=cut

sub reviews {
    my $self = shift;
    return $self->messages->search( {}, { join => 'product_review' } );
}

1;
