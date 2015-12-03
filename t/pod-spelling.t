use strict;
use warnings;
use Test::More;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

eval "use Test::Spelling";
plan skip_all => "Test::Spelling required" if $@;
add_stopwords(<DATA>);
all_pod_files_spelling_ok();

__END__
ajax
AttributeValue
auth
autotable
Batschelet
bb
Boes
CartProduct
CGI
Checksum
checksum
CountryLocale
DBD
DBIC
diag
EAN
eCommerce
FK
FOREIGNBUILDARGS
fqdn
Grega
GST
gtin
html
Hornburg
iso
Kaare
Kodžoman
logout
MediaDisplay
MediaProduct
MediaType
MerchandisingAttribute
MerchandisingProduct
MessageType
Mottram
multicreate
multipler
nav
NavigationAttribute
NavigationAttributeValue
NavigationProduct
nullable
OrderComment
OrderStatus
Orderline
orderline
orderlines
OrderlinesShipping
PaymentOrder
Pluralised
Pompe
PostgreSQL
PNG
png
PriceModifier
ProductAttribute
ProductAttributeValue
ProductReview
PRs
QST
Racke
rels
RESULTSET
ResultSet
resultset
resultsets
salestax
Šimun
SKU
sku
StateLocale
SysPete
TODO
UriRedirect
UserAttribute
UserAttributeValue
UserRole
viewable
wishlist
ZoneCountry
ZoneState
