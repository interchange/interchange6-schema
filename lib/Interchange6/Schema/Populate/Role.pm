package Interchange6::Schema::Populate::Role;

=head1 NAME

Interchange6::Schema::Populate::Role

=head1 DESCRIPTION

This module provides population capabilities for the Role result class

=cut

use strict;
use warnings;

use Moo;

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per role ready to use with populate schema method. Initial roles are:

=over

=item * admin

Shop administrator with full permissions.

=item * user

All non-anonymous users have this role.

=item * anonymous

Anonymous users.

=back

=cut

sub records {
    return [
        {
            name        => "admin",
            label       => "Admin",
            description => "Shop administrator with full permissions",
            website_id  => undef,
        },
        {
            name        => "user",
            label       => "User",
            description => "All users have this role",
            website_id  => undef,
        },
        {
            name        => "anonymous",
            label       => "Anonymous",
            description => "Anonymous users",
            website_id  => undef,
        }
    ];
}

1;
