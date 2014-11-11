use utf8;
package Interchange6::Schema::Result::LocationType;

=head1 NAME

Interchange6::Schema::Result::LocationType

=cut

use Interchange6::Schema::Candy -components =>
  [qw(InflateColumn::DateTime TimeStamp)];

=head1 ACCESSORS

=head2 location_types_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  primary key

=cut

primary_column location_types_id => {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
};

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0

=cut

column name => {
    data_type     => "varchar",
    default_value => "",
    is_nullable   => 0,
};

=head1 RELATIONS

=head2 locations

Type: has_many

Related object: L<Interchange6::Schema::Result::Location>

=cut

has_many
  locations => "Interchange6::Schema::Result::Location",
  { "foreign.location_types_id" => "self.location_types_id" },
  { cascade_copy  => 0, cascade_delete => 0 };

1;