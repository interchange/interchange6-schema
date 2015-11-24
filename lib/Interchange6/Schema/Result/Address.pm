use utf8;
package Interchange6::Schema::Result::Address;

=head1 NAME

Interchange6::Schema::Result::Address - customer billing/shipping addresses

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

use Class::Method::Modifiers;
use Try::Tiny;

=head1 DESCRIPTION

The Address class is used to store any kind of address such as billing, 
delivery, etc along with company and individual names if needed.

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => {
    data_type         => "integer",
    is_auto_increment => 1,
};

=head2 user_id

Foreign key constraint on L<Interchange6::Schema::Result::User/id>
via L</user> relationship.

=cut

column user_id => {
    data_type => "integer",
};

=head2 type

Address L</type> for such things as "billing" or "shipping". Defaults to
empty string.

=cut

column type => {
    data_type     => "varchar",
    default_value => "",
    size          => 16,
};

=head2 archived

Boolean indicating that address has been archived and so should no longer
appear in normal address listings.

=cut

column archived => {
    data_type     => "boolean",
    default_value => 0,
};

=head2 first_name

First name of person associated with address. Defaults to empty string.

=cut

column first_name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 last_name

Last name of person associated with address. Defaults to empty string.

=cut

column last_name => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 company

Company name associated with address. Defaults to empty string.

=cut

column company => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 address

First line of address. Defaults to empty string.

=cut

column address => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 address_2

Second line of address. Defaults to empty string.

=cut

column address_2 => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 postal_code

Postal/zip code. Defaults to empty string.

=cut

column postal_code => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 city

City/town name. Defaults to empty string.

=cut

column city => {
    data_type     => "varchar",
    default_value => "",
    size          => 255,
};

=head2 phone

Telephone number. Defaults to empty string.

=cut

column phone => {
    data_type     => "varchar",
    default_value => "",
    size          => 32,
};

=head2 state_id

Foreign key constraint on L<Interchange6::Schema::Result::State/id>
via L</state> relationship. NULL values are allowed.

=cut

column state_id => {
    data_type      => "integer",
    is_nullable    => 1,
};

=head2 country_iso_code

Two character country ISO code. Foreign key constraint on
L<Interchange6::Schema::Result::Country/iso_code> via L</country>
relationship.

=cut

column country_iso_code => {
    data_type      => "char",
    size           => 2,
};

=head2 priority

Signed integer priority. We normally order descending. A simple use might
be to set default address to 1 and others to 0.

Defaults to 0.

=cut

column priority => { data_type => "integer", default_value => 0 };

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

=head2 website_id

The id of the website/shop this address belongs to.

FK on L<Interchange6::Schema::Result::Website/id>

=cut

column website_id => { data_type => "integer" };

=head1 RELATIONS

=head2 orderlines_shipping

Type: has_many

Related object: L<Interchange6::Schema::Result::OrderlinesShipping>

=cut

has_many
  orderlines_shipping => "Interchange6::Schema::Result::OrderlinesShipping",
  "address_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 orders

Type: has_many

Related object: L<Interchange6::Schema::Result::Order>

=cut

has_many
  orders => "Interchange6::Schema::Result::Order",
  "billing_address_id",
  { cascade_copy => 0, cascade_delete => 0 };

=head2 user

Type: belongs_to

Related object: L<Interchange6::Schema::Result::User>

=cut

belongs_to
  user => "Interchange6::Schema::Result::User",
  "user_id",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 state

Type: belongs_to

Related object: L<Interchange6::Schema::Result::State>

=cut

belongs_to
  state => "Interchange6::Schema::Result::State",
  "state_id",
  {
    join_type     => 'left',
    is_deferrable => 1,
    on_delete     => "CASCADE",
    on_update     => "CASCADE"
  };

=head2 country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

belongs_to
  country => "Interchange6::Schema::Result::Country",
  "country_iso_code",
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" };

=head2 website

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to
  website => "Interchange6::Schema::Result::Website",
  "website_id";

=head2 orderlines

Type: many_to_many

Composing rels: L</orderlines_shipping> -> orderline

=cut

many_to_many orderlines => "orderlines_shipping", "orderline";

=head1 METHODS

=head2 delete

If an address cannot be deleted due to foreign key constraints (perhaps
it has L</orders> or L</orderlines_shipping>) then instead of deleting the
row set L</archived> to true.

=cut

# we can't use next::method since we do the delete inside try{} and that messes
# up callers so instead we use Class::Method::Modifiers::around

around delete => sub {
    my ( $orig, $self ) = @_;
    try {
        $self->$orig(@_);
    }
    catch {
        my $original_error = $_;
        try {
            $self->update({archived => 1});
        }
        catch {
            $self->result_source->schema->throw_exception($original_error);
        };
    };
};

1;
