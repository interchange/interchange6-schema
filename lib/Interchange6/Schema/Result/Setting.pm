use utf8;

package Interchange6::Schema::Result::Setting;

=head1 NAME

Interchange6::Schema::Result::Setting

=cut

use Interchange6::Schema::Candy;

=head1 ACCESSORS

=head2 settings_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'settings_settings_id_seq'
  primary key

=cut

column settings_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "settings_settings_id_seq",
};

=head2 scope

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

column scope => { data_type => "varchar", is_nullable => 0, size => 32 };

=head2 site

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column site =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 32

=cut

column name => { data_type => "varchar", is_nullable => 0, size => 32 };

=head2 value

  data_type: 'text'
  is_nullable: 0

=cut

column value => { data_type => "text", is_nullable => 0 };

=head2 category

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 32

=cut

column category =>
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 32 };

1;
