use utf8;

package Interchange6::Schema::Result::Website;

=head1 NAME

Interchange6::Schema::Result::Website - all sites/shops served from this schema

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 website_id

Primary key.

=cut

primary_column website_id => { data_type => "integer", is_auto_increment => 1 };

=head2 fqdn

Fully-qualified domain name for this website, e.g.: www.perldance.com

This is the primary domain name for this site. Any domain name L</aliases>
should be created with L</primary_website_id> set to the L</website_id> of
this site.

Unique constraint.

=cut

unique_column fqdn => { data_type => "varchar", size => "255" };

=head2 name

Name of website/shop

=cut

column name => { data_type => "varchar", size => 255 };

=head2 description

Description of website/shop

=cut

column description =>
  { data_type => "varchar", size => 2048, default_value => '' };

=head2 active

Boolean showing whether site is currently active.

=cut

column active => { data_type => "boolean", default_value => 1 };

=head2 primary_website_id

FK on L</website_id>.

Used for domain name L</aliases>.

Is nullable.

B<NOTE:> This is only for domain name aliases that actually reach your
application. Any aliases that are redirected before reaching the application
(by proxy/webserver) do not need to be added here.

=cut

column parent_website_id => { data_type => "integer", is_nullable => 1 };

=head1 RELATIONS

=head2 primary_website

Type: belongs_to

Related_object: <Interchange6::Schema::Result::Website>

=cut

belongs_to
  primary_website => "Interchange6::Schema::Result::Website",
  "parent_website_id",
  { join_type => "left" };

=head2 aliases

Type: has_many

Related_object: <Interchange6::Schema::Result::Website>

=cut

has_many
  aliases => "Interchange6::Schema::Result::Website",
  "parent_website_id";

1;
