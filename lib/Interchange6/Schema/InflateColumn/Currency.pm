package Interchange6::Schema::InflateColumn::Currency;

=head1 NAME

Interchange6::Schema::InflateColumn::Currency

=cut

use strict;
use warnings;
use base qw/DBIx::Class/;
use Interchange6::Currency;
use Safe::Isa;
use namespace::clean;

__PACKAGE__->load_components(qw/Helper::Row::OnColumnChange/);

=head1 SYNOPSIS

 __PACKAGE__->load_components('+Interchange6::Schema::InflateColumn::Currency');
 __PACKAGE__->add_columns(
   price => { data_type => 'numeric', size => [13,3], is_currency => 1 },
   currency_iso_code => { data_type => 'char', size => 3 },
 );

=head1 METHODS

=head2 register_column

Override L<DBIx::Class::Row/register_column> to add C<inflate_column> method
to any columns defined with C<< is_currency => 1 >>. Column is inflated
to L<Interchange6::Schema> object.  This would not normally be directly
called by end users.

=head1 COLUMN_INFO

=head2 is_currency

Must be set to true to cause inflation of the column.

=head2 currency_code_column

Name of the column that contains the 3 letter ISO currency code for this
column. Defaults to C<currency_iso_code>.

=cut

sub register_column {
    my ( $self, $column, $info, @rest ) = @_;

    $self->next::method( $column, $info, @rest );

    return unless $info->{'is_currency'};

    my $currency_code_column =
      $info->{'currency_code_column'} || 'currency_iso_code';

    $self->inflate_column(
        $column => {
            inflate => sub {
                my ( $value, $obj ) = @_;
                my $code;

                if ( $obj->result_source->has_column($currency_code_column) ) {
                    my $code = $obj->$currency_code_column;
                }
                if ( !$code ) {
                    $code = $obj->result_source->schema->currency_iso_code;
                }

                return Interchange6::Currency->new(
                    value         => $value,
                    currency_code => $code,
                    locale        => $obj->result_source->schema->locale,
                );
            },
            deflate => sub {
                my ( $value, $obj ) = @_;
                return $value->$_can('value') ? $value->value : $value;
            },
        }
    );

    # FIXME: this SUCKS big time but so far I haven't found a way around this.
    # To see why this is needed just comment out the following line then run
    # all tests and you will see that $product->update({price => $newprice})
    # seems to work fine but then on checking the price you still see the old
    # one.
    $self->after_column_change( price => { method => 'discard_changes' } );
}

1;
