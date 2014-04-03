#!perl
use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 7;
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

my %media_data = (
                  file => 'product/image.jpg',
                  uri => '/images/items/image.jpg',
                  mime_type => 'image/jpeg',
                 );

my %other_media_data = (
                        file => 'product/image2.jpg',
                        uri => '/images/items/image2.jpg',
                        mime_type => 'image/jpeg',
                       );

my %thumb = (
             file => 'thumbs/image.jpg',
             uri => '/images/thumbs/image.jpg',
             mime_type => 'image/jpeg',
            );

# create the image types

foreach my $t (qw/image_detail
                  image_cart
                  image_listing
                  video/) {
    $schema->resultset('MediaType')->create({ type => $t });
}



my $product = $schema->resultset('Product')->create(\%product_data);

foreach my $media_hashref (\%media_data, \%other_media_data) {
    my $m = $product->add_to_media($media_hashref);
    $m->create_related('MediaDisplay', {
                                        sku => $product->sku,
                                        MediaType => {
                                                      type => 'image_detail',
                                                     }
                                       });
}

# insert the thumb too

$product->add_to_media(\%thumb)
  ->create_related('MediaDisplay', {
                                    sku => $product->sku,
                                    MediaType => {
                                                  type => 'image_cart',
                                                 }
                                   });




my @thumbs = $product->media_by_type('image_cart');

ok(@thumbs == 1, "Only one result for image_cart");
if (@thumbs) {
    my $th = shift(@thumbs);
    is $th->uri, '/images/thumbs/image.jpg', "Found thumb uri";
    is $th->file, 'thumbs/image.jpg';
}

my @images = $product->media_by_type('image_detail');

ok(@images == 2, "Found the two images");

is $images[0]->uri, '/images/items/image.jpg', "Found first image";
is $images[1]->uri, '/images/items/image2.jpg', "Found the second";
