package Interchange6::Schema::Populate::MessageType;

=head1 NAME

Interchange6::Schema::Populate::MessageType

=head1 DESCRIPTION

This module provides population capabilities for the MessageType schema

=cut

use Moo;

=head1 METHODS

=head2 records

Returns array reference containing one hash reference per message type ready to use with populate schema method.

=cut

sub records {

    my @types = qw( blog_post order_comment product_review );

    return [ map { { name => $_ } } @types ];
}

1;
