package Test::Inventory;

use Test::Exception;
use Test::Roo::Role;

test 'inventory tests' => sub {

    my $self = shift;

    my $schema = $self->ic6s_schema;

    my $product;

    cmp_ok( $self->products->count, '>', 0, "we have products" );
    cmp_ok( $self->inventory->count, '>', 0, "we have inventory" );

    lives_ok( sub { $product = $self->products->find('os28077') },
        "find product os28077" );
    cmp_ok( $product->quantity_in_stock, '==', 97, "97 in stock" );

    lives_ok( sub { $product = $self->products->find('os28070') },
        "find product os28070" );
    cmp_ok( $product->quantity_in_stock, '==', 0, "0 in stock" );

    lives_ok( sub { $product = $self->products->find('os29000') },
        "find product os29000 (no inventory row)" );
    cmp_ok( $product->quantity_in_stock, '==', 0, "0 in stock" );

    lives_ok( sub { $product = $self->products->find('os28004-SYN-WHT') },
        "find product os28004-SYN-WHT (a variants)" );
    cmp_ok( $product->quantity_in_stock, '==', 42, "42 in stock" );

    lives_ok( sub { $product = $self->products->find('os28004') },
        "find product os28004 (canonical with variants)" );
    cmp_ok( $product->quantity_in_stock, '==', 253, "253 in stock" );

    lives_ok( sub { $product = $self->products->find('os28066') },
        "find product os28066 (canonical with one variant missing from inv.)" );
    cmp_ok( $product->quantity_in_stock, '==', 317, "317 in stock" );

    lives_ok( sub { $product = $self->products->find('sv13213') },
        "find product sv13213 (service with inventory_exempt=>1)" );
    ok( ! defined $product->quantity_in_stock, "quantity_in_stock is undef" );

};

1;
