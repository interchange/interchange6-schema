use utf8;

package Interchange6::Schema::Result::Tax;

=head1 NAME

Interchange6::Schema::Result::Tax

=cut

use strict;
use warnings;
use DateTime;
use POSIX qw/ceil floor/;

use Moo;

extends 'DBIx::Class::Core';

use namespace::clean;

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

=head2 precision

  data_type: 'integer'
  is_nullable: 0
  default_value: 2

Number of decimal places of precision required. Defaults to 2.

=head2 rounding

  data_type: char"
  is_nullable: 1
  size: 1
  default_value: undef

Default rounding is half round up to the precision number of decimal places. To use floor or ceiling set rounding to 'f' or 'c' as appropriate. The rounding value is automatically converted to lower case and any invalid value passed in will be ignored and instead undef will be stored giving default rounding.

=head2 valid_from

  data_type: 'date'
  set_on_create: 1
  is_nullable: 0

=head2 valid_to

  data_type: 'date'
  is_nullable: 1

=head2 country_iso_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 1

=head2 states_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

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
    "precision",
    { data_type => "integer", is_nullable => 0, default_value => 2 },
    "rounding",
    {
        data_type     => "char",
        is_nullable   => 1,
        size          => 1,
        default_value => undef
    },
    "valid_from",
    { data_type => "date", set_on_create => 1, is_nullable => 0 },
    "valid_to",
    { data_type => "date", is_nullable => 1 },
    "country_iso_code",
    { data_type => "char", is_foreign_key => 1, is_nullable => 1 },
    "states_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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

# for rounding to only store undef, c or f

around rounding => sub {
    my ( $orig, $self, @a ) = ( shift, shift, @_ );

    if ( $a[0] ) {
        if ( $a[0] =~ m/^(f|c)/i ) {
            $a[0] = lc($1);
        }
        else {
            $a[0] = undef;
        }
    }

    $self->$orig(@a);
};

=head1 METHODS

=head2 calculate

Calculate tax

Arguments should be a hash ref of the following arguments:

=over 4

=item * price

Price of product either inclusive or exclusive of tax - required.

=item * tax_included

Boolean indicating whether price is inclusive of tax or not. Defaults to 0 which means exclusive of tax.

Will throw an exception if the price us not numeric.

=back

Usage example:

    my $tax = $taxrecord->caclulate({ price => 13.47, tax_included => 1 });

    # with percentage 18 our tax is 2.05

=cut

sub calculate {
    my $self = shift;
    my $args = shift;

    my $schema = $self->result_source->schema;
    my $dtf    = $schema->storage->datetime_parser;
    my $dt     = DateTime->today;
    my $tax;

    $schema->throw_exception("argument price is missing")
      unless defined $args->{price};

    $schema->throw_exception(
        "argument price is not a valid numeric: " . $args->{price} )
      unless $args->{price} =~ m/^(\d+)*(\.\d+)*$/;

    if ( $args->{tax_included} ) {
        my $nett = $args->{price} / ( 1 + ( $self->percent / 100 ) );
        $tax = $args->{price} - $nett;
    }
    else {
        $tax = $args->{price} * $self->percent / 100;
    }

    # round & return

    my $precision = $self->precision;

    unless ( $self->rounding ) {

        return sprintf( "%.${precision}f", $tax );
    }
    else {

        $tax *= 10**$precision;

        if ( $self->rounding eq 'c' ) {
            $tax = ceil($tax) / ( 10**$precision );
        }
        elsif ( $self->rounding eq 'f' ) {
            $tax = floor($tax) / ( 10**$precision );
        }
        else {

            # should not be possible to get here
            $schema->throw_exception(
                "rounding value from database is invalid: " . $self->rounding );
        }

        return sprintf( "%.${precision}f", $tax );
    }
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
        order_by      => 'name',
        join_type     => 'left',
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
        order_by      => 'name',
        join_type     => 'left',
    }
);

=head1 PRIVATE METHODS

=head2 new

We override the new method to set default values on certain rows at create time.

=cut

sub new {
    my ( $class, $attrs ) = @_;

    $attrs->{precision} = 2 unless defined $attrs->{precision};

    my $new = $class->next::method($attrs);

    return $new;
}

=head2 sqlt_deploy_hook

Called during table creation to add indexes on the following columns:

=over 4

=item * tax_name

=item * valid_from

=item * valid_to

=back

=cut

sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;

    $table->add_index( name => 'taxes_idx_tax_name', fields => ['tax_name'] );
    $table->add_index(
        name   => 'taxes_idx_valid_from',
        fields => ['valid_from']
    );
    $table->add_index(
        name   => 'taxes_idx_valid_to',
        fields => ['valid_to']
    );
}

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
        $rset =
          $schema->resultset('Country')
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
                'tax overlaps existing date range: ' . $self->tax_name );
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
