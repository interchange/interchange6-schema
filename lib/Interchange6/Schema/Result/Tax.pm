use utf8;

package Interchange6::Schema::Result::Tax;

=head1 NAME

Interchange6::Schema::Result::Tax

=cut

use strict;
use warnings;
use DateTime;

use base 'DBIx::Class::Core';

# component load order is important so be careful here:
__PACKAGE__->load_components(
    qw(InflateColumn::DateTime TimeStamp Result::Validation));

=head1 TABLE: C<taxes>

=cut

__PACKAGE__->table("taxes");

=head1 DESCRIPTION

The taxes table contains taxes such as sales tax and VAT. Each tax has a unique tax_name but can contain multiple rows for each tax_name to allow for changes in tax rates over time. When there is more than one row for a single tax_name then the valid_from and valid_to periods may not overlap.

=head1 ACCESSORS

=head2 taxes_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'taxes_id_seq'

=head2 tax_name

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 percent

  data_type: 'numeric'
  is_nullable: 0
  size: [3,4]

=head2 valid_from

  data_type: 'date'
  set_on_create: 1
  is_nullable: 0

=head2 valid_to

  data_type: 'date'
  is_nullable: 1

=head2 states_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 country_iso_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0

=head2 created

  data_type: 'datetime'
  set_on_create: 1
  is_nullable: 0

=head2 last_modified

  data_type: 'datetime'
  set_on_create: 1
  set_on_update: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    "taxes_id",
    {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "taxes_id_seq"
    },
    "tax_name",
    { data_type => "varchar", is_nullable => 0, size => 64 },
    "description",
    { data_type => "varchar", is_nullable => 0, size => 64 },
    "percent",
    { data_type => "numeric", is_nullable => 0, size => [ 3, 4 ] },
    "valid_from",
    { data_type => "date", set_on_create => 1, is_nullable => 0 },
    "valid_to",
    { data_type => "date", is_nullable => 1 },
    "states_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
    "country_iso_code",
    { data_type => "char", is_foreign_key => 1, is_nullable => 0 },
    "created",
    { data_type => "datetime", set_on_create => 1, is_nullable => 0 },
    "last_modified",
    {
        data_type     => "datetime",
        set_on_create => 1,
        set_on_update => 1,
        is_nullable   => 0
    },
);

=head1 METHODS

=head2 sqlt_deploy_hook

Called during table creation to add indexes on the following columns:

=cut

sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    $sqlt_table->add_index( name => 'idx_name', fields => ['name'] );
}

=head2 calculate

Calculate tax

Arguments should be a hash ref of the following arguments:

=over 4

=item * price

Price of product either inclusive or exclusive of tax - required.

=item * tax_included

Boolean indicating whether price is inclusive of tax or not. Defaults to 0.

=item * precision

How many decimal places to round the result to. Defaults to 2.

=back

Usage example:

    my $tax = $taxrecord->caclulate({ price => 13.47, 
        tax_included => 1, precision => 2 });

    # with percentage 18 our tax is 2.05

=cut

sub calculate {
    my $self = shift;
    my $args = shift;

    my $schema = $self->result_source->schema;
    my $dtf    = $schema->storage->datetime_parser;
    my $dt     = DateTime->today;
    my $tax;

    return unless $args->{price} =~ m/^(\d+)*(\.\d+)*$/;

    if ( $args->{tax_included} ) {
        my $nett = $args->{price} / ( 1 + ( $self->percent / 100 ) );
        $tax = $args->{price} - $nett;
    }
    else {
        $tax = $args->{price} * $self->percent / 100;
    }

    # round & return

    $args->{precision} = 2 unless $args->{precision};

    return sprintf( "%.$args->{precision}f", $tax );
}

=head1 PRIMARY KEY

=over 4

=item * L</taxes_id>

=back

=cut

__PACKAGE__->set_primary_key("taxes_id");

=head1 RELATIONS

=head2 State

Type: belongs_to

Related object: L<Interchange6::Schema::Result::State>

=cut

__PACKAGE__->belongs_to(
    "State",
    "Interchange6::Schema::Result::State",
    'states_id',
    {
        is_deferrable => 1,
        on_delete     => "CASCADE",
        on_update     => "CASCADE",
        order_by      => 'name'
    }
);

=head2 Country

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
    "Country",
    "Interchange6::Schema::Result::Country",
    'country_iso_code',
    {
        is_deferrable => 1,
        on_delete     => "CASCADE",
        on_update     => "CASCADE",
        order_by      => 'name'
    }
);

=head1 PRIVATE METHODS

=head2 _validate

Validity checks that cannot be enforced using primary key, unique or other database methods. The validity checks enforce the following rules:

=over 4

=item * Check country_iso_code is valid

=item * If both valid_from and valid_to are defined then valid_to must be a later date than valid_from.

=item * A single tax_name may appear more than once in the table to allow for changes in tax rates but valid_from/valid_to date ranges must not overlap.

=back

=cut

sub _validate {
    my $self   = shift;
    my $schema = $self->result_source->schema;
    my $dtf    = $schema->storage->datetime_parser;
    my $rset;

    # country iso code

    if ( defined $self->country_iso_code ) {
        $rset = $schema->resultset('Country')
          ->search( { country_iso_code => $self->country_iso_code } );
        if ( $rset->count == 0 ) {
            $self->add_result_error( 'error',
                'country_iso_code not valid: ' . $self->country_iso_code );
            return;
        }
    }

    # check that valid_to is later than valid_from (if it is defined)

    $self->valid_from->truncate( to => 'day' );

    if ( defined $self->valid_to ) {

        # remove time - we only want the date
        $self->valid_to->truncate( to => 'day' );

        unless ( $self->valid_to > $self->valid_from ) {
            $self->add_result_error( 'error',
                "valid_to is not later than valid_from" );
            return;
        }
    }

    # multiple entries for a single tax code do not overlap dates

    if ( defined $self->valid_to ) {
        $rset = $self->result_source->resultset->search(
            {
                tax_name => $self->tax_name,
                -or      => [
                    valid_from => {
                        -between => [
                            $dtf->format_datetime( $self->valid_from ),
                            $dtf->format_datetime( $self->valid_to ),
                        ]
                    },
                    valid_to => {
                        -between => [
                            $dtf->format_datetime( $self->valid_from ),
                            $dtf->format_datetime( $self->valid_to ),
                        ]
                    },
                ],
            }
        );
        if ( $rset->count > 0 ) {
            $self->add_result_error( 'error',
                'tax overlaps existing date range' );
            return;
        }
    }
    else {
        $rset = $self->result_source->resultset->search(
            {
                tax_name => $self->tax_name,
                -or      => [
                    {
                        valid_to => undef,
                        valid_from =>
                          { '<=', $dtf->format_datetime( $self->valid_from ) },
                    },
                    {
                        valid_to => { '!=', undef },
                        valid_to =>
                          { '>=', $dtf->format_datetime( $self->valid_from ) },
                    },
                ],
            }
        );
    }
    if ( $rset->count > 0 ) {
        $self->add_result_error( 'error', 'tax overlaps existing date range' );
        return;
    }
}

1;
