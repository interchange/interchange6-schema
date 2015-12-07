package Interchange6::Schema::InflateColumn::Currency;
use strict;
use warnings;

use base qw/DBIx::Class Class::Accessor::Grouped/;
use Interchange6::Currency;
use namespace::clean;

__PACKAGE__->mk_group_accessors(
    'simple', qw/
      currency_code currency_format currency_code_column
      /
);

sub register_column {
    my ( $self, $column, $info, @rest ) = @_;
    $self->next::method( $column, $info, @rest );

    return unless defined $info->{'is_currency'};

    my $currency_class =
         $info->{'currency_class'}
      || $self->currency_class
      || 'Interchange6::Currency';

    my $currency_iso_code =
      $info->{'currency_iso_code'} || $self->currency_iso_code;

    my $currency_code_column =
      $info->{'currency_code_column'} || $self->currency_code_column;

    my $currency_format = $info->{'currency_format'} || $self->currency_format;

    $self->inflate_column(
        $column => {
            inflate => sub {
                my ( $value, $obj ) = @_;
                my $locale;
                my $code =
                    $currency_code_column
                  ? $obj->$currency_code_column || $currency_iso_code
                  : $currency_iso_code;

                return Interchange6::Currency->new(
                    value         => $value,
                    currency_code => $code,
                    locale        => $locale
                );
            },
            deflate => sub {
                return shift->value;
            },
        }
    );
}

1;
