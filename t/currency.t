use utf8;
use strict;
use warnings;
use open qw( :encoding(UTF-8) :std );

use Test::Exception;
use Test::More;
use Interchange6::Currency;

my ( $obj1, $obj2, $obj3 );

subtest 'create currency objects' => sub {

    lives_ok {
        $obj1 = Interchange6::Currency->new(
            locale        => 'en',
            currency_code => 'GBP',
            value         => 3.4,
          )
    }
    "create \$obj1 en/GBP currency object with value 3.4";

    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

    lives_ok {
        $obj2 = Interchange6::Currency->new(
            locale        => 'fr',
            currency_code => 'GBP',
            value         => 2.2,
          )
    }
    "create \$obj2 fr/GBP currency object with value 2.2";

    cmp_ok $obj2->value,     '==', 2.2,          "value is 2.2";
    cmp_ok $obj2->as_string, 'eq', '2,20 £GB', '->as_string gives 2,20 £GB';
    cmp_ok "$obj2", 'eq', '2,20 £GB', 'stringify via "" gives 2,20 £GB';

    lives_ok {
        $obj3 = Interchange6::Currency->new(
            locale        => 'en',
            currency_code => 'EUR',
            value         => 4.7,
          )
    }
    "create \$obj3 en/EUR currency object with value 4.7";

    cmp_ok $obj3->value,     '==', 4.7,       "value is 4.7";
    cmp_ok $obj3->as_string, 'eq', '€4.70', '->as_string gives €4.70';
    cmp_ok "$obj3", 'eq', '€4.70', 'stringify via "" gives €4.70';
};

subtest 'simple method tests' => sub {

    lives_ok { $obj1->add(2) } '$obj1->add(2)';
    cmp_ok $obj1->value,     '==', 5.4,      "value is 5.4";
    cmp_ok $obj1->as_string, 'eq', '£5.40', '->as_string gives £5.40';
    cmp_ok "$obj1", 'eq', '£5.40', 'stringify via "" gives £5.40';

    lives_ok { $obj1->subtract(2) } '$obj1->subtract(2)';
    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

    lives_ok { $obj1->multiply(2) } '$obj1->multiply(2)';
    cmp_ok $obj1->value,     '==', 6.8,      "value is 6.8";
    cmp_ok $obj1->as_string, 'eq', '£6.80', '->as_string gives £6.80';
    cmp_ok "$obj1", 'eq', '£6.80', 'stringify via "" gives £6.80';

    lives_ok { $obj1->divide(2) } '$obj1->divide(2)';
    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

    cmp_ok $obj1->modulo(2), '==', 1.4, '$obj1->modulo(2) is 1.4';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";

    cmp_ok $obj1->cmp_value(3), '==', 1, '$obj1->cmp_value(3) is +1';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";

    cmp_ok $obj1->cmp_value(3.4), '==', 0, '$obj1->cmp_value(3.4) is 0';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";

    cmp_ok $obj1->cmp_value(4), '==', -1, '$obj1->cmp_value(4) is -1';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";
};

subtest 'maths with 2 currency objects' => sub {

    lives_ok { $obj1->add($obj2) } '$obj1->add($obj2)';
    cmp_ok $obj1->value,     '==', 5.6,      "value is 5.6";
    cmp_ok $obj1->as_string, 'eq', '£5.60', '->as_string gives £5.60';
    cmp_ok "$obj1", 'eq', '£5.60', 'stringify via "" gives £5.60';

    dies_ok { $obj1->add($obj3) } '$obj1->add($obj3) dies';

    lives_ok { $obj1->subtract($obj2) } '$obj1->subtract($obj2)';
    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

    dies_ok { $obj1->subtract($obj3) } '$obj1->subtract($obj3) dies';

    lives_ok { $obj1->multiply($obj2) } '$obj1->multiply($obj2)';
    cmp_ok $obj1->value,     '==', 7.48,     "value is 7.48";
    cmp_ok $obj1->as_string, 'eq', '£7.48', '->as_string gives £7.48';
    cmp_ok "$obj1", 'eq', '£7.48', 'stringify via "" gives £7.48';

    dies_ok { $obj1->multiply($obj3) } '$obj1->multiply($obj3) dies';

    lives_ok { $obj1->divide($obj2) } '$obj1->divide($obj2)';
    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

    dies_ok { $obj1->divide($obj3) } '$obj1->divide($obj3) dies';

    cmp_ok $obj1->modulo($obj2), '==', 1.2, '$obj1->modulo($obj2) is 1.2';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";

    dies_ok { $obj1->modulo($obj3) } '$obj1->modulo($obj3) dies';

    cmp_ok $obj1->cmp_value($obj2), '==', 1, '$obj1->cmp_value($obj2) is +1';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";

    dies_ok { $obj1->cmp_value($obj3) } '$obj1->cmp_value($obj3) dies';
};

subtest 'overloaded assignment operators' => sub {

    lives_ok { $obj1 += 2 } '$obj1 += 2';
    cmp_ok $obj1->value,     '==', 5.4,      "value is 5.4";
    cmp_ok $obj1->as_string, 'eq', '£5.40', '->as_string gives £5.40';
    cmp_ok "$obj1", 'eq', '£5.40', 'stringify via "" gives £5.40';

    lives_ok { $obj1 -= 2 } '$obj1 -= 2';
    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

    lives_ok { $obj1 *= 2 } '$obj1 *= 2';
    cmp_ok $obj1->value,     '==', 6.8,      "value is 6.8";
    cmp_ok $obj1->as_string, 'eq', '£6.80', '->as_string gives £6.80';
    cmp_ok "$obj1", 'eq', '£6.80', 'stringify via "" gives £6.80';

    lives_ok { $obj1 /= 2 } '$obj1 /= 2';
    cmp_ok $obj1->value,     '==', 3.4,      "value is 3.4";
    cmp_ok $obj1->as_string, 'eq', '£3.40', '->as_string gives £3.40';
    cmp_ok "$obj1", 'eq', '£3.40', 'stringify via "" gives £3.40';

};

subtest 'overloaded binary infix operators' => sub {

    cmp_ok $obj1 cmp $obj1, '==', 0, '$obj1 cmp $obj1 == 0';
    cmp_ok $obj1 + 3 cmp $obj1, '==', 1, '$obj1 + 3 cmp $obj1 == 1';
    cmp_ok $obj1 cmp $obj1 + 3, '==', -1, '$obj1 cmp $obj1 +3 == -1';

    cmp_ok $obj1 <=> $obj1, '==', 0, '$obj1 <=> $obj1 == 0';
    cmp_ok $obj1 + 3 <=> $obj1, '==', 1, '$obj1 + 3 <=> $obj1 == 1';
    cmp_ok $obj1 <=> $obj1 + 3, '==', -1, '$obj1 <=> $obj1 +3 == -1';

    ok $obj1 > $obj2, '$obj1 > $obj2';
    ok $obj1 > 1.2, '$obj1 > 1.2';
    ok $obj2 < $obj1, '$obj2 < $obj1';
    ok $obj2 < 9, '$obj2 < 9';

};

subtest 'other overloaded infix operators' => sub {

    cmp_ok $obj1 + 3, '==', 6.4, '$obj1 + 3 == 6.4';
    cmp_ok 3 + $obj1, '==', 6.4, '3 + $obj1 == 6.4';
    cmp_ok $obj1 + 3, 'eq', '£6.40', '$obj1 + 3 eq £6.40';
    cmp_ok 3 + $obj1, 'eq', '£6.40', '3 + $obj1 eq £6.40';

    cmp_ok $obj1 - 1, '==', 2.4, '$obj1 - 1 == 2.4';
    cmp_ok 5 - $obj1, '==', 1.6, '5 - $obj1 == 1.6';
    cmp_ok $obj1 - 1, 'eq', '£2.40', '$obj1 - 1 eq £2.40';
    cmp_ok 5 - $obj1, 'eq', '£1.60', '5 - $obj1 eq £1.60';

    cmp_ok $obj1 * 2, 'eq', '£6.80', '$obj1 * 2 eq £6.80';
    cmp_ok $obj1 / 2, 'eq', '£1.70', '$obj1 / 2 eq £1.70';

    cmp_ok $obj1 % 2, '==', 1.4,      '$obj1 % 2 == 1.4';
    cmp_ok $obj1 % 2, 'eq', '£1.40', '$obj1 % 2 eq £1.40';
    cmp_ok $obj1->value, '==', 3.4, "\$obj1 value is still 3.4";

};

done_testing;
