#!perl
use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 39;
use Test::Warnings;
use DBICx::TestDatabase;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

my %product_data = (sku => 'G000X',
                    name => 'Six Tulips',
                    short_description => 'What says I love you',
                    description => 'Surprise',
                    price => '19.95',
                    uri => 'six-tulips',
                    weight => '4',
                    canonical_sku => undef,
                   );

my @media = ({
              file => 'product/image.jpg',
              uri => 'image.jpg',
              mime_type => 'image/jpeg',
             },
             {
              file => 'product/image2.jpg',
              uri => 'image2.jpg',
              mime_type => 'image/jpeg',
             },
             {
              file => 'product/image3.jpg',
              uri => 'image3.jpg',
              mime_type => 'image/jpeg',
             });

# create the image types
diag "Populating the types and the displays";
$schema->resultset('MediaType')->create({ type => 'video' })
  ->add_to_media_displays({ type => 'video',
                            name => 'video',
                            path => '/video/',
                            size => '' });

my $imagetype = $schema->resultset('MediaType')->create({ type => 'image' });

foreach my $display (qw/image_cart image_detail image_thumb/) {
    $imagetype->add_to_media_displays({
                                       type => $display,
                                       name => $display,
                                       path => "/images/$display",
                                       size => "testsize",
                                      })
}

my $product = $schema->resultset('Product')->create(\%product_data);
foreach my $media_hashref (@media) {
    my $m = $product->add_to_media({ %$media_hashref,
                                     media_type => { type => 'image' },
                                   });
}

# create another product with 1 media

my $second = $schema->resultset('Product')->create({
                                                    sku => '1media',
                                                    name => "test",
                                                    short_description => 'test',
                                                    description => 'long desc',
                                                    price => '10.00',
                                                    uri => '1media',
                                                    weight => 4,
                                                    canonical_sku => undef,
                                                   });
$second->add_to_media({ %{$media[0]}, media_type => { type => 'image' }});

my @second_media = $second->media;

ok(@second_media == 1, $second->sku . " has only one media ");

my @first_media = $product->media;

ok(@first_media == 3, $product->sku . "has 3 media");

foreach my $m (@first_media, @second_media) {
    is $m->media_type->type, 'image', $m->uri . " is an image";
    is $m->type, 'image', "Shortcut works";
    my %to_find = (
                image_cart => 1,
                image_detail => 1,
                image_thumb => 1,
               );
    foreach my $display ($m->media_type->media_displays) {
        my $display_type = $display->type;
        diag "Found $display_type";
        delete $to_find{$display_type};
    }
    ok !%to_find, "All the display type found";
    my @displays = $m->displays;
    foreach my $d (@displays) {
        unlike $d->type, qr/video/, $d->type . ' is not a video';
        like $d->path, qr!/images/!, "found the path " . $d->path;
    }
}

