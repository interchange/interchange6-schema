use utf8;

package Interchange6::Schema;

=encoding utf8

=head1 NAME

Interchange6::Schema - Database Schema for Interchange 6

=head1 VERSION

0.092

=cut

our $VERSION = '0.092';

=head1 MANUAL

Please see the L<Interchange6 Schema Manual|Interchange6::Schema::Manual>
for an overview of available documentation.

=head1 DESCRIPTION

Database schema class for Interchange6 Open Source eCommerce software.

The minimum Perl version for Interchange6::Schema is 5.14.

Components used:

=over

=item * L<DBIx::Class::Helper::Schema::DateTime>

=item * L<DBIx::Class::Helper::Schema::QuoteNames>

=back

=cut

use strict;
use warnings;

use base 'DBIx::Class::Schema::Config';
use Class::Method::Modifiers;
use Interchange6::Currency;

__PACKAGE__->load_components( 'Helper::Schema::DateTime',
    'Helper::Schema::QuoteNames' );

__PACKAGE__->load_namespaces(
    default_resultset_class => 'ResultSet',
);

=head1 ATTRIBUTES

=head2 currency_iso_code

The default currency_iso_code used by
L<Interchange6::Schema::Component::CurrencyStamp>.

If not set then a query similar to the following is performed to try to find
the appropriate code:

  my $currency_iso_code = $self->resultset('Setting')->find(
      {
          scope      => 'global',
          name       => 'currency_iso_code',
          category   => '',
          website_id => $self->website_id,
      }
  );

If no currency code is found then L</currency_iso_code> is set to the default
value of 'EUR'.

=over

=item writer: set_currency_iso_code

=back

=head2 decimal_scale

The number of decimal places used for rounding and display of monetary values.
This is determined from L</currency_iso_code> using L<Interchange6::Currency>.

=over

=item writer: set_decimal_scale

=back

=head2 locale

The current locale. Defaults to 'en'.

=over

=item writer: set_locale

=back


=head2 website_id

The default website_id used by L<Interchange6::Schema::Component::WebsiteStamp>

=over

=item writer: set_website_id

=back

=cut

__PACKAGE__->mk_group_ro_accessors(
    simple => (
        [ currency_iso_code => '_ic6_currency_iso_code' ],
        [ decimal_scale     => '_ic6_decimal_scale' ],
        [ locale            => '_ic6_locale' ],
        [ website_id        => '_ic6_website_id' ]
    )
);

__PACKAGE__->mk_group_wo_accessors(
    simple => (
        [ set_currency_iso_code => '_ic6_currency_iso_code' ],
        [ set_decimal_scale     => '_ic6_decimal_scale' ],
        [ set_locale            => '_ic6_locale' ],
        [ set_website_id        => '_ic6_website_id' ]
    )
);

around currency_iso_code => sub {
    my ( $orig, $self, @args ) = @_;
    # pass args to $orig since this is a ro accessor and we want to allow
    # an exception to be thrown if args have been passed in.
    my $code = $orig->( $self, @args );
    if ( !defined $code ) {
        if ( defined $self->website_id ) {
            my $currency_iso_code = $self->resultset('Setting')->find(
                {
                    scope      => 'global',
                    name       => 'currency_iso_code',
                    category   => '',
                    website_id => $self->website_id,
                }
            );
            $code = $currency_iso_code->value if $currency_iso_code;
        }
        $code = 'EUR' unless defined $code;
        $self->set_currency_iso_code($code);
    }
    return $code;
};

after set_currency_iso_code => sub {
    my $self = shift;
    # reset decimal_scale
    $self->set_decimal_scale(undef);
    $self->decimal_scale;
};

around decimal_scale => sub {
    my ( $orig, $self, @args ) = @_;
    my $decimal_scale = $orig->( $self, @args );
    if ( !defined $decimal_scale ) {
        my $currency = Interchange6::Currency->new(
            locale => $self->locale,
            currency_code => $self->currency_iso_code,
            value => 1,
        );
        $decimal_scale = $currency->maximum_fraction_digits;
    }
    return $decimal_scale;
};

around locale => sub {
    my ( $orig, $self, @args ) = @_;
    # pass args to $orig since this is a ro accessor and we want to allow
    # an exception to be thrown if args have been passed in.
    my $locale = $orig->( $self, @args );
    if ( !defined $locale ) {
        $locale = 'en';
        $self->set_locale($locale);
    }
    return $locale;
};

=head1 METHODS

=head2 deploy

Overload L<DBIx::Class::Schema/deploy> in order to add some core fixtures
via L<Interchange6::Schema::Populate>.

=cut

{
    use Interchange6::Schema::Populate;

    sub deploy {
        my $self = shift;
        my $new  = $self->next::method(@_);

        Interchange6::Schema::Populate->new( schema => $self )->populate;

        $self->resultset('Website')->create(
            {
                fqdn        => "*",
                name        => "Default",
                description => "Default Website"
            }
        );
    }
}

1;

__END__

=head1 CREATE SQL FILES FOR DATABASE SCHEMA

This command creates SQL files for our database schema
in the F<sql/> directory:

   interchange6-create-database

=head1 POLICY FOR RELATIONSHIP ACCESSORS

=over 4

=item All lower case

=item Singular names for belongs_to and has_one relationships

=item Pluralised names for many_to_many and has_many relationships

=item Use underscores for things like C<shipment_destinations>.

=back

=head1 AUTHORS

Stefan Hornburg (Racke), C<racke@linuxia.de>

Peter Mottram, C<peter@sysnix.com>

Jeff Boes, C<jeff@endpoint.com>

Sam Batschelet C<sbatschelet@mac.com>

=head1 CONTRIBUTORS

Kaare Rasmussen
Šimun Kodžoman
Grega Pompe

=head1 LICENSE AND COPYRIGHT

Copyright 2013-2015 Stefan Hornburg (Racke), Jeff Boes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
