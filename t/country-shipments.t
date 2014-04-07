#!perl
use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 13;
use DBICx::TestDatabase;

my $schema = DBICx::TestDatabase->new('Interchange6::Schema');

ok($schema);

my $us = $schema->resultset('Country')->create({
                                                country_iso_code => 'US',
                                                name =>'United States',
                                                show_states => 1,
                                                active => 1
                                               });

my $it = $schema->resultset('Country')->create({
                                                country_iso_code => 'IT',
                                                name =>'Italy',
                                                show_states => 0,
                                                active => 1
                                               });

foreach my $zone (980..988) {
    $us->add_to_zones({
                       zone => "US postal $zone",
                      });
}

$it->add_to_zones({
                   zone => "Itaglia",
                  });


foreach my $z ($us->zones) {
    like $z->zone, qr/US postal/, "Found the zone: " . $z->zone;
};

is $it->zones->first->zone, "Itaglia", "Italy has one zone";

my $carrier = $schema->resultset('ShipmentCarrier')->create({
                                                             name => 'UPS',
                                                             title => 'UPS',
                                                             active => 1,
                                                            });

$it->zones->first->add_to_shipment_methods({
                                            name => 'EXPRESS',
                                            title => 'test',
                                            ShipmentCarrier => $carrier,
                                           });

is $it->zones->first->shipment_methods->first->title, "test";

ok $it->zones->first->shipment_destinations->first->active;



