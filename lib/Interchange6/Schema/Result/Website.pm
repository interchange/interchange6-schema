use utf8;

package Interchange6::Schema::Result::Website;

=head1 NAME

Interchange6::Schema::Result::Website - all sites/shops served from this schema

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 id

Primary key.

=cut

primary_column id => { data_type => "integer", is_auto_increment => 1 };

=head2 name

Name of website/shop

Unique constraint.

=cut

unique_column name => { data_type => "varchar", size => 255 };

=head2 description

Description of website/shop

=cut

column description =>
  { data_type => "varchar", size => 2048, default_value => '' };

=head2 active

Boolean showing whether site is currently active.

=cut

column active => { data_type => "boolean", default_value => 1 };

1;
