use strict;
use warnings;

use Data::Dumper;

use Test::Most 'die', tests => 89;
use Test::MockTime qw(:all);

use Interchange6::Schema;
use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::StateLocale;
use DateTime;
use DBICx::TestDatabase;

#my ( $rset, $data, @data, %data, $result, $tax, $coderef );

my ( %countries, %states, $rset, @data, $result, %data, $data, $tax );

my $dt = DateTime->now;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my $pop_countries = Interchange6::Schema::Populate::CountryLocale->new->records;
my $pop_states    = Interchange6::Schema::Populate::StateLocale->new->records;
my $rsetcountry   = $schema->resultset('Country');
my $rsetstate     = $schema->resultset('State');
my $rsettax       = $schema->resultset('Tax');

lives_ok( sub { $schema->populate( Country => $pop_countries ) },
    "populate countries" );

lives_ok { $schema->populate( State => $pop_states ) } "populate states";

# stuff countries and states into hashes to save lots of lookups later

$rset = $schema->resultset('Country')->search( {} );
while ( my $res = $rset->next ) {
    $countries{ $res->country_iso_code } = $res;
}

$rset = $schema->resultset('State')->search( {} );
while ( my $res = $rset->next ) {
    $states{ $res->country_iso_code . "_" . $res->state_iso_code } = $res;
}

# create taxes

# EU Standard rate VAT

@data = (
    [ 'BE', 21, '1996-01-01' ],
    [ 'BG', 20, '1999-01-01' ],
    [ 'CZ', 21, '2013-01-01' ],
    [ 'DK', 25, '1992-01-01' ],
    [ 'DE', 19, '2007-01-01' ],
    [ 'EE', 20, '2009-07-01' ],
    [ 'GR', 23, '2011-01-01' ],
    [ 'ES', 21, '2012-09-01' ],
    [ 'FR', 20, '2014-01-01' ],
    [ 'HR', 25, '2012-03-01' ],
    [ 'IE', 23, '2012-01-01' ],
    [ 'IT', 22, '2013-10-01' ],
    [ 'CY', 19, '2014-01-13' ],
    [ 'LV', 21, '2009-01-01' ],
    [ 'LT', 21, '2009-09-01' ],
    [ 'LU', 15, '1992-01-01' ],
    [ 'HU', 27, '2012-01-01' ],
    [ 'MT', 18, '2004-01-01' ],
    [ 'NL', 21, '2012-10-01' ],
    [ 'AT', 20, '1984-01-01' ],
    [ 'PL', 23, '2011-01-01' ],
    [ 'PT', 23, '2011-01-01' ],
    [ 'RO', 24, '2010-07-01' ],
    [ 'SI', 22, '2013-07-01' ],
    [ 'SK', 20, '2011-01-01' ],
    [ 'FI', 24, '2013-01-01' ],
    [ 'SE', 25, '1990-07-01' ],
    [ 'GB', 20, '2011-01-04' ],
);

# set our num taxes counter
my $numtaxes = scalar @data;

foreach my $aref (@data) {

    my ( $code, $rate, $from ) = @{$aref};

    my $c_name = $countries{$code}->name;

    lives_ok(
        sub {
            $rsettax->create(
                {
                    tax_name         => "$code VAT Standard",
                    description      => "$c_name VAT Standard Rate",
                    percent          => $rate,
                    country_iso_code => $code,
                    valid_from       => $from,
                }
            );
        },
        "Create $c_name VAT Standard Rate"
    );
}

# some country-level taxes + EU reverse charge

#<<<
@data = (
    [ 'DE VAT Reduced', 'DE VAT Reduced Rate',          7, '1983-07-01', 'DE' ],
    [ 'DE VAT Exempt',  'DE VAT Exempt',                0, '1968-01-01', 'DE' ],
    [ 'MT VAT Reduced', 'Malta VAT Reduced Rate',       5, '1995-01-01', 'MT' ],
    [ 'MT VAT Hotel',   'Malta VAT Hotel Accomodation', 7, '2011-01-01', 'MT' ],
    [ 'MT VAT Exempt',  'Malta VAT Exempt',             0, '1995-01-01', 'MT' ],
    [ 'GB VAT Reduced', 'GB VAT Reduced Rate',          5, '1997-09-01', 'GB' ],
    [ 'GB VAT Exempt',  'GB VAT Exempt',                0, '1973-04-01', 'GB' ],
    [ 'EU reverse charge', 'EU B2B reverse charge',    0, '2000-01-01', undef ],
    [ 'CA GST',         'Canada Goods and Service Tax', 5, '2008-01-01', 'CA' ],
);
#>>>

# update our num taxes counter
$numtaxes += scalar @data;

lives_ok(
    sub {
        $result = $schema->populate(
            'Tax',
            [
                [
                    'tax_name', 'description',
                    'percent',  'valid_from',
                    'country_iso_code',
                ],
                @data
            ]
        );
    },
    "Populate tax table"
);

cmp_ok( $rsettax->count, '==', $numtaxes, "$numtaxes taxes in the table" );

# Canada GST/PST/HST/QST

%data = (
    BC => [ 'PST', 7 ],
    MB => [ 'RST', 8 ],
    NB => [ 'HST', 13 ],
    NL => [ 'HST', 13 ],
    NS => [ 'HST', 15 ],
    ON => [ 'HST', 13 ],
    PE => [ 'HST', 14 ],
    QC => [ 'QST', 9.975 ],
    SK => [ 'PST', 10 ],
);

# increment our num taxes counter
$numtaxes += scalar keys %data;

foreach my $code ( sort keys %data ) {

    lives_ok(
        sub {
            $rsettax->create(
                {
                    tax_name    => "CA $code $data{$code}[0]",
                    description => "CA "
                      . $states{"CA_$code"}->name
                      . " $data{$code}[0]",
                    percent          => $data{$code}[1],
                    country_iso_code => 'CA',
                    states_id        => $states{"CA_$code"}->states_id
                }
            );
        },
        "Create CA $code $data{$code}[0]"
    );
}

# test some incorrect tax entries

$data->{country_iso_code} = 'FooBar';
throws_ok(
    sub { $rsettax->create($data) },
    qr/iso_code not valid/,
    "Fail create with bad country_iso_code"
);

cmp_ok( $rsettax->count, '==', $numtaxes, "$numtaxes taxes in the table" );

# create an old IE rate

$data = {
    tax_name         => 'IE VAT Standard',
    description      => 'Ireland VAT Standard Rate',
    country_iso_code => 'IE',
    percent          => 21,
    valid_from       => '2010-01-01',
    valid_to         => '2011-12-31'
};

lives_ok(
    sub { $result = $rsettax->create($data) },
    "Create previous IE VAT Standard rate"
);

$numtaxes++;
cmp_ok( $rsettax->count, '==', $numtaxes, "$numtaxes taxes in the table" );

throws_ok(
    sub { $result = $rsettax->create($data) },
    qr/overlaps existing date range/,
    "Fail to create identical tax"
);

cmp_ok( $rsettax->count, '==', $numtaxes, "$numtaxes taxes in the table" );

$data->{valid_from} = '2011-01-01';
$data->{valid_to}   = undef;
throws_ok(
    sub { $result = $rsettax->create($data) },
    qr/overlaps existing date range/,
    "Fail to create valid_from in tax 1 and valid_to undef"
);

$data->{valid_from} = '2013-01-01';
throws_ok(
    sub { $result = $rsettax->create($data) },
    qr/overlaps existing date range/,
    "Fail to create valid_from in tax 2 and valid_to undef"
);

$data->{valid_from} = '2009-01-01';
throws_ok(
    sub { $result = $rsettax->create($data) },
    qr/overlaps existing date range/,
    "Fail to create valid_from before tax 1 and valid_to undef"
);

$data->{valid_to} = '2010-01-01';
throws_ok(
    sub { $result = $rsettax->create($data) },
    qr/overlaps existing date range/,
    "Fail to create valid_from before tax 1 and valid_to in tax 1"
);

$data->{valid_from} = '2011-01-01';
$data->{valid_to}   = '2013-01-01';
throws_ok(
    sub { $result = $rsettax->create($data) },
    qr/overlaps existing date range/,
    "Fail to create valid_from in tax 1 and valid_to in tax 2"
);

# calculate tax

lives_ok( sub { $tax = $rsettax->current_tax('MT VAT Standard') },
    "Get current MT tax" );

cmp_ok( $tax->calculate( { price => 13.47, tax_included => 1 } ),
    '==', 2.05, "Tax on gross 13.47 should be 2.05" );

cmp_ok( $tax->calculate( { price => 13.47, tax_included => 0 } ),
    '==', 2.42, "Tax on nett 13.47 should be 2.42" );

lives_ok( sub { $tax = $rsettax->current_tax('IE VAT Standard') },
    "Get current IE tax" );

cmp_ok( $tax->calculate( { price => 13.47, tax_included => 0 } ),
    '==', 3.10, "Tax on nett 13.47 should be 3.10" );

lives_ok( sub { set_absolute_time('2011-01-01T00:00:00Z') },
    "Mock time to 2011-01-01T00:00:00Z" );

lives_ok( sub { $tax = $rsettax->current_tax('IE VAT Standard') },
    "Get IE tax for this historical date" );

cmp_ok( $tax->calculate( { price => 13.47, tax_included => 0 } ),
    '==', 2.83, "Tax on nett 13.47 should be 2.83" );

lives_ok( sub { restore_time() }, "Unmock time" );

lives_ok( sub { $tax = $rsettax->current_tax('IE VAT Standard') },
    "Get current IE tax" );

cmp_ok( $tax->calculate( { price => 13.47, tax_included => 0 } ),
    '==', 3.10, "Tax on nett 13.47 should be 3.10" );

# some weird precision/ceil/floor taxes

$data = {
    tax_name         => 'testing',
    description      => 'description',
    country_iso_code => 'IE',
    percent          => 21.333,
    valid_from       => '2010-01-01',
    precision        => 2,
};
lives_ok( sub { $tax = $rsettax->create($data) }, "Create 21.33% precision 2" );
cmp_ok( $tax->calculate( { price => 13.47 } ),
    '==', 2.87, "Tax on nett 13.47 should be 2.87" );

lives_ok( sub { $tax->rounding( 'f' ) }, "set rounding floor" );
cmp_ok( $tax->rounding, 'eq', 'f', "rounding is f" );
cmp_ok( $tax->calculate( { price => 13.47 } ),
    '==', 2.87, "Tax on nett 13.47 should be 2.87" );

lives_ok( sub { $tax->rounding( 'c' ) }, "set rounding ceiling" );
cmp_ok( $tax->rounding, 'eq', 'c', "rounding is c" );
cmp_ok( $tax->calculate( { price => 13.47 } ),
    '==', 2.88, "Tax on nett 13.47 should be 2.88" );

lives_ok( sub { $tax->rounding( undef ) }, "set rounding default" );
is( $tax->rounding, undef, "rounding is undef" );
lives_ok( sub { $tax->precision( 3 ) }, "set precision 3" );
cmp_ok( $tax->calculate( { price => 13.47 } ),
    '==', 2.874, "Tax on nett 13.47 should be 2.874" );

lives_ok( sub { $tax->rounding( 'f' ) }, "set rounding floor" );
cmp_ok( $tax->calculate( { price => 13.47 } ),
    '==', 2.873, "Tax on nett 13.47 should be 2.873" );

lives_ok( sub { $tax->rounding( 'c' ) }, "set rounding ceiling" );
cmp_ok( $tax->calculate( { price => 13.47 } ),
    '==', 2.874, "Tax on nett 13.47 should be 2.874" );

# rounding input checks

$data = {
    tax_name         => '1',
    description      => 'description',
    percent          => 21.333,
    valid_from       => '2010-01-01',
    rounding         => 'c',
};
lives_ok( sub { $tax = $rsettax->create($data) }, "new tax with rounding c" );
cmp_ok( $tax->rounding, 'eq', 'c', "rounding is c" );
lives_ok( sub { $tax->rounding(2)}, "set rounding 2 (bad)" );
is( $tax->rounding, undef, "rounding undef as expected" );
lives_ok( sub { $tax->rounding(2)}, "set rounding to ceiling" );
is( $tax->rounding, undef, "rounding undef as expected" );
lives_ok( sub { $tax->rounding('C')}, "set rounding to C" );
cmp_ok( $tax->rounding, 'eq', 'c', "rounding is c" );
lives_ok( sub { $tax->rounding('F')}, "set rounding to F" );
cmp_ok( $tax->rounding, 'eq', 'f', "rounding is f" );
