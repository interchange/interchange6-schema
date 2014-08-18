package Interchange6::Schema::Candy;

use base 'DBIx::Class::Candy';

sub base { $_[1] || 'DBIx::Class::Core' }
sub autotable { 1 }

1;
