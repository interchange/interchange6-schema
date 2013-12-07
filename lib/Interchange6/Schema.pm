use utf8;
package Interchange6::Schema;

=head1 NAME

Interchange6::Schema - Database Schema for Interchange 6

=head1 VERSION

0.005

=head1 CREATE SQL FILES FOR DATABASE SCHEMA

This command creates SQL files for our database schema
in the F<sql/> directory:

   interchange6-create-database

=head1 AUTHORS

Stefan Hornburg (Racke), C<racke@linuxia.de>

Jeff Boes, C<jeff@endpoint.com>

Sam Batschelet C<sbatschelet@mac.com>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Stefan Hornburg (Racke), Jeff Boes.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

our $VERSION = '0.005';

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2013-11-08 09:31:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:A+AhSjuWjRp6Y39vdVcJxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
