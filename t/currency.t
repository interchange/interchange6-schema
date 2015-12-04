use utf8;
use strict;
use warnings;
use open qw( :encoding(UTF-8) :std );

use Test::Exception;
use Test::More;
use Interchange6::Currency;

my $cur_obj;

lives_ok {
    $cur_obj = Interchange6::Currency->new(
        locale        => 'en',
        currency_code => 'GBP',
        value         => 3.45,
      )
}
"create en/GBP currency object with value 3.45";

cmp_ok $cur_obj->value,     '==', 3.45,     "value is 3.45";
cmp_ok $cur_obj->stringify, 'eq', '£3.45', '->stringify gives £3.45';
cmp_ok "$cur_obj", 'eq', '£3.45', 'stringify via "" gives £3.45';

lives_ok {
    $cur_obj = Interchange6::Currency->new(
        locale        => 'nl',
        currency_code => 'GBP',
        value         => 3.45,
      )
}
"create nl/GBP currency object with value 3.45";

cmp_ok $cur_obj->value,     '==', 3.45,       "value is 3.45";
cmp_ok $cur_obj->stringify, 'eq', '£ 3,45', '->stringify gives £ 3,45';
cmp_ok "$cur_obj", 'eq', '£ 3,45', 'stringify via "" gives £ 3,45';

done_testing;
