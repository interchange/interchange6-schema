use utf8;

package Interchange6::Schema::Result::Setting;

=head1 NAME

Interchange6::Schema::Result::Setting

=cut

use Interchange6::Schema::Candy -components => [
    qw(
      +Interchange6::Schema::Component::WebsiteStamp
      )
];

=head1 COMPONENTS

The following components are used:

=over

=item * Interchange6::Schema::Component::WebsiteStamp

=back

=head1 ACCESSORS

=head2 settings_id

Primary key.

=cut

primary_column settings_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    sequence          => "settings_settings_id_seq",
};

=head2 website_id

FK on L<Interchange6::Schema::Result::Website/website_id>

The website this setting belongs to.

=cut

column website_id => { data_type => "integer" };

=head2 scope

Scope of this setting.

=cut

column scope => { data_type => "varchar", size => 32 };

=head2 name

Name of this setting.

=cut

column name => { data_type => "varchar", size => 32 };

=head2 value

Value of this setting.

=cut

column value => { data_type => "text" };

=head2 category

Category of this setting.

Defaults to empty string.

=cut

column category =>
  { data_type => "varchar", default_value => "", size => 32 };

=head1 UNIQUE CONSTRAINT

=head2 website_id scope name category

=cut

unique_constraint [ 'website_id', 'scope', 'name', 'category' ];

=head1 RELATIONS

=head2 website

Type: belongs_to

Releated object: L<Interchange6::Schema::Result::Website>

=cut

belongs_to website => "Interchange6::Schema::Result::Website", "website_id";

1;
