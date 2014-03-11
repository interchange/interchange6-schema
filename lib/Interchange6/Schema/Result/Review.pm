use utf8;
package Interchange6::Schema::Result::Review;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Interchange6::Schema::Result::Review

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw(InflateColumn::DateTime TimeStamp));

=head1 TABLE: C<reviews>

=cut

__PACKAGE__->table("reviews");

=head1 DESCRIPTION

User product reviews

B<reviews_id:>

B<sku:>

B<title:>

B<content:>

B<users_id:>

B<rating:>  Numeric range 1.0 to 5.0 for item rating.

B<recommend:>

B<public:>  Default is false

B<approved:>  Default is false

B<created:>

=cut

=head1 ACCESSORS

=head2 reviews_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 sku

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 0
  size: 64

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 users_id

  is_foreign_key: 1
  is_nullable: 0

=head2 rating

  data_type: 'numeric'
  default_value: 0.0
  is_nullable: 0

=head2 recommend

  data_type: 'boolean'
  is_nullable: 1

=head2 public

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 approved

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "reviews_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "sku",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "users_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "rating",
  { data_type => "numeric", default_value => 0.0, is_nullable => 0 },
  "recommend",
  { data_type => "boolean", is_nullable => 1 },
  "public",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "approved",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "created",
  { data_type => "datetime", set_on_create => 1, is_nullable => 0 },

);

=head1 PRIMARY KEY

=over 4

=item * L</reviews_id>

=back

=cut

__PACKAGE__->set_primary_key("reviews_id");

=head1 RELATIONS

=head2 User

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "User",
  "Interchange6::Schema::Result::User",
  { users_id => "users_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 Product

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "Product",
  "Interchange6::Schema::Result::Product",
  { sku => "sku" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-12-05 08:49:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JtaRif8NDVRTymg4pwVYMg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
