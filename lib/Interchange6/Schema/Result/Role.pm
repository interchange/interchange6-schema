use utf8;

package Interchange6::Schema::Result::Role;

=head1 NAME

Interchange6::Schema::Result::Role

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 name

Role name, e.g.: admin.

Unique constraint.

=cut

unique_column name => { data_type => "varchar", size => 32 };

=head2 label

Label, e.g.: Admin.

=cut

column label => { data_type => "varchar", size => 255 };

=head2 description

Description, e.g.: Administrator with full privileges.

=cut

column description => { data_type => "text" };

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

Is nullable. A null value indicates that the role is available to all
websites.

=cut

column website_id => { data_type => "integer", is_nullable => 1 };

=head1 RELATIONS

=head2 price_modifiers

Type: has_many

Related object: L<Interchange6::Schema::Result::PriceModifier>

=cut

has_many
  price_modifiers => "Interchange6::Schema::Result::PriceModifier",
  "role_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 permissions

Type: has_many

Related object: L<Interchange6::Schema::Result::Permission>

=cut

has_many
  permissions => "Interchange6::Schema::Result::Permission",
  "role_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 user_roles

Type: has_many

Related object: L<Interchange6::Schema::Result::UserRole>

=cut

has_many
  user_roles => "Interchange6::Schema::Result::UserRole",
  "role_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id",
  { join_type => 'left' };

=head2 users

Type: many_to_many

Composing rels: L</user_roles> -> user

=cut

many_to_many users => "user_roles", "user";

=head1 METHODS

=head2 delete

Override delete so that FIXME ??

=cut

sub delete {
    my ( $self, @args ) = @_;
    my $schema = $self->result_source->schema;
    my $current_website_id = $schema->current_website_id;
    if ( $schema->superadmin ) {
        $self->next::method(@args);
    }
    elsif (defined $current_website_id
        && defined $self->website_id
        && $current_website_id eq $self->website_id )
    {
        $self->next::method(@args);
    }
}

1;
