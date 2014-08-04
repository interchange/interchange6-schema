package Role::Fixtures;

use Interchange6::Schema::Populate::CountryLocale;
use Interchange6::Schema::Populate::MessageType;
use Interchange6::Schema::Populate::StateLocale;
use Interchange6::Schema::Populate::Zone;
use Sub::Quote qw/quote_sub/;

use Test::Roo::Role;

# accessors are ordered in this array based on the order in which
# clear_all_fixtures needs to receive them so that there are no FK issues in
# the database during row deletion

my @accessors =
  qw(addresses taxes zones states countries products attributes users message_types);

# Create all of the accessors and clearers. Builders should be defined later.

foreach my $accessor (@accessors) {
    has $accessor => (
        is        => 'lazy',
        clearer   => "_clear_$accessor",
        predicate => 1,
    );

    next if $accessor eq 'products';    # see below

    my $cref = q{
        my $self = shift;
        $self->$accessor->delete_all;
        my $_clear_accessor = "_clear_$accessor";
        $self->$_clear_accessor;
    };
    quote_sub "main::clear_$accessor", $cref, { '$accessor' => \$accessor };
}

# clearing products is not so simple...

sub clear_products {
    my $self = shift;

    # find canonical products
    my $rset = $self->products->search( { canonical_sku => undef } );
    while ( my $product = $rset->next ) {
        my $rset = $product->variants;

        # delete variants before canonical product
        $product->variants->delete_all;
        $product->delete;
    }
    $self->_clear_products;
}

=head1 METHODS

All attributes have a corresponding C<clear_$attribute> method which deletes all rows from the corresponding table and clears the accessor. 

=head2 clear_all_fixtures

This additional method calls all of the clear_$accessor methods.

=cut

sub clear_all_fixtures {
    my $self = shift;
    foreach my $accessor (@accessors) {
        my $clear_accessor = "clear_$accessor";
        $self->$clear_accessor;
    }
}

=head1 ATTRIBUTES

Fixtures are not installed in the database until the attribute is called. This is achieved by all accessors being lazy and so builders exist for each accessor to install the fixtures on demand.

=head2 addresses

Depends on users, states (possibly) and countries.

=cut

sub _build_addresses {
    my $self = shift;
    my $rset = $self->schema->resultset('Address');

    my ( $user, $notvoid );

    # we must have users and countries before we can proceed
    $self->users     unless $self->has_users;
    $self->countries unless $self->has_countries;

    my $customers =
      $self->users->search( { username => { like => 'customer%' } },
        { order_by => 'username' } );

    $user = $customers->next;

    $notvoid = $rset->populate(
        [
            [qw(users_id type city country_iso_code)],
            [ $user->id, 'billing',  'Qormi',  'MT' ],
            [ $user->id, 'shipping', 'London', 'GB' ],
            [ $user->id, 'shipping', 'Paris',  'FR' ],
        ]
    );

    $user = $customers->next;

    my $state_on = $self->states->search(
        {
            country_iso_code => 'CA',
            state_iso_code   => 'ON'
        },
        { rows => 1 }
    )->single;

    my $state_ny = $self->states->search(
        {
            country_iso_code => 'US',
            state_iso_code   => 'NY'
        },
        { rows => 1 }
    )->single;

    $notvoid = $rset->populate(
        [
            [qw(users_id type city states_id country_iso_code)],
            [ $user->id, 'billing',  'London',   $state_on->id, 'CA' ],
            [ $user->id, 'billing',  'New York', $state_ny->id, 'US' ],
            [ $user->id, 'shipping', 'Hancock',  $state_ny->id, 'US' ],
        ]
    );

    $user = $customers->next;

    $notvoid = $rset->populate(
        [
            [qw(users_id type city country_iso_code)],
            [ $user->id, 'billing',  'Wedemark', 'DE' ],
            [ $user->id, 'shipping', 'Aachen',   'DE' ],
        ]
    );

    return $rset;
}

=head2 countries

Populated via L<Interchange6::Schema::Populate::CountryLocale>.

=cut

sub _build_countries {
    my $self    = shift;
    my $rset    = $self->schema->resultset('Country');
    my $pop     = Interchange6::Schema::Populate::CountryLocale->new->records;
    my $notvoid = $rset->populate($pop) or die "Failed to populate Country";
    return $rset;
}

=head2 products

=cut

sub _build_products {
    my $self = shift;
    my $rset = $self->schema->resultset('Product');

    # we must have attributes before we can proceed
    $self->attributes unless $self->has_attributes;

    my $product_data = {
        sku  => 'G0001',
        name => 'Six Tulips',
        short_description =>
          'What says I love you better than 1 dozen fresh roses?',
        description =>
'Surprise the one who makes you smile, or express yourself perfectly with this stunning bouquet of one dozen fresh red roses. This elegant arrangement is a truly thoughtful gift that shows how much you care.',
        price         => '19.95',
        uri           => 'six-tulips',
        weight        => '4',
        canonical_sku => undef,
    };

    $rset->create($product_data)->add_variants(
        {
            color => 'yellow',
            size  => 'small',
            sku   => 'G0001-YELLOW-S',
            name  => 'Six Small Yellow Tulips',
            uri   => 'six-small-yellow-tulips'
        },
        {
            color => 'yellow',
            size  => 'large',
            sku   => 'G0001-YELLOW-L',
            name  => 'Six Large Yellow Tulips',
            uri   => 'six-large-yellow-tulips'
        },
        {
            color => 'pink',
            size  => 'small',
            sku   => 'G0001-PINK-S',
            name  => 'Six Small Pink Tulips',
            uri   => 'six-small-pink-tulips'
        },
        {
            color => 'pink',
            size  => 'medium',
            sku   => 'G0001-PINK-M',
            name  => 'Six Medium Pink Tulips',
            uri   => 'six-medium-pink-tulips'
        },
        {
            color => 'pink',
            size  => 'large',
            sku   => 'G0001-PINK-L',
            name  => 'Six Large Pink Tulips',
            uri   => 'six-large-pink-tulips'
        },
    );

    return $rset;
}

=head2 attributes

Colours, sizes and heights for products.

FIXME: attributes for other things to be added?

=cut

sub _build_attributes {
    my $self = shift;
    my $rset = $self->schema->resultset('Attribute');

    # 'merikan spelling ;-)
    my $color_data = {
        name             => 'color',
        title            => 'Color',
        type             => 'variant',
        priority         => 2,
        attribute_values => [
            { value => 'black',  title => 'Black' },
            { value => 'white',  title => 'White' },
            { value => 'green',  title => 'Green' },
            { value => 'red',    title => 'Red' },
            { value => 'yellow', title => 'Yellow', priority => 1 },
            { value => 'pink',   title => 'Pink', priority => 2 },
        ]
    };
    $rset->create($color_data);

    my $size_data = {
        name             => 'size',
        title            => 'Size',
        type             => 'variant',
        priority         => 1,
        attribute_values => [
            { value => 'small',  title => 'Small',  priority => 2 },
            { value => 'medium', title => 'Medium', priority => 1 },
            { value => 'large',  title => 'Large',  priority => 0 },
        ]
    };
    $rset->create($size_data);

    my $height_data = {
        name             => 'height',
        title            => 'Height',
        type             => 'specification',
        attribute_values => [
            { value => '10', title => '10cm' },
            { value => '20', title => '20cm' },
        ]
    };
    $rset->create($height_data);

    return $rset;
}

=head2 message_types

Populated via L<Interchange6::Schema::Populate::MessageType>.

=cut

sub _build_message_types {
    my $self = shift;
    my $rset = $self->schema->resultset('MessageType');

    my $pop = Interchange6::Schema::Populate::MessageType->new->records;
    my $notvoid = $rset->populate($pop) or die "Failed to populate MessageType";
    return $rset;
}

=head2 states

Populated via L<Interchange6::Schema::Populate::StateLocale>.

=cut

sub _build_states {
    my $self = shift;
    my $rset = $self->schema->resultset('State');

    # we must have countries before we can proceed
    $self->countries unless $self->has_countries;

    my $pop = Interchange6::Schema::Populate::StateLocale->new->records;
    my $notvoid = $rset->populate($pop) or die "Failed to populate State";
    return $rset;
}

=head2 taxes

=cut

sub _build_taxes {
    my $self = shift;
    my %countries;
    my $rset = $self->schema->resultset('Tax');

    # we must have countries and states before we can proceed
    $self->countries unless $self->has_countries;
    $self->states    unless $self->has_states;

    # EU Standard rate VAT
    my @data = (
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
    foreach my $aref (@data) {

        my ( $code, $rate, $from ) = @{$aref};

        my $c_name =
          $self->countries->find( { country_iso_code => $code } )->name;

        $rset->create(
            {
                tax_name         => "$code VAT Standard",
                description      => "$c_name VAT Standard Rate",
                percent          => $rate,
                country_iso_code => $code,
                valid_from       => $from,
            }
        );
    }

    # Canada GST/PST/HST/QST
    my %data = (
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
    foreach my $code ( sort keys %data ) {

        my $state = $self->states->find(
            { country_iso_code => 'CA', state_iso_code => $code } );

        $rset->create(
            {
                tax_name         => "CA $code $data{$code}[0]",
                description      => "CA " . $state->name . " $data{$code}[0]",
                percent          => $data{$code}[1],
                country_iso_code => 'CA',
                states_id        => $state->states_id
            }
        );
    }

    return $rset;
}

=head2 users

    [qw( username email password )],
    [ 'customer1', 'customer1@example.com', 'c1passwd' ],
    [ 'customer2', 'customer2@example.com', 'c1passwd' ],
    [ 'customer3', 'customer3@example.com', 'c1passwd' ],
    [ 'admin1',    'admin1@example.com',    'a1passwd' ],
    [ 'admin2',    'admin2@example.com',    'a2passwd' ],

=cut

sub _build_users {
    my $self    = shift;
    my $rset    = $self->schema->resultset('User');
    my $notvoid = $rset->populate(
        [
            [qw( username email password )],
            [ 'customer1', 'customer1@example.com', 'c1passwd' ],
            [ 'customer2', 'customer2@example.com', 'c1passwd' ],
            [ 'customer3', 'customer3@example.com', 'c1passwd' ],
            [ 'admin1',    'admin1@example.com',    'a1passwd' ],
            [ 'admin2',    'admin2@example.com',    'a2passwd' ],
        ]
    );
    return $rset;
}

=head2 zones

Populated via L<Interchange6::Schema::Populate::Zone>.

=cut

sub _build_zones {
    my $self = shift;
    my $rset = $self->schema->resultset('Zone');

    # we need to pass min value of states_id to ::Populate::Zone
    # also kicks in states and countries builders if not already set

    my $min_states_id = $self->states->search(
        {},
        {
            select => [ { min => 'states_id' } ],
            as     => ['min_id'],
        }
    )->first->get_column('min_id');

    my $pop =
      Interchange6::Schema::Populate::Zone->new(
        states_id_initial_value => $min_states_id )->records;

    my $notvoid = $rset->populate($pop) or die "Failed to populate Zone";
    return $rset;
}

1;
