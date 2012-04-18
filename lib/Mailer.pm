use 5.010;
use strict;
use warnings;

use Email::Valid;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self = bless {@_}, $class;
    return $self;
}

sub email_check {
    my ($self, $email) = @_;
    return Email::Valid->address($email);
}

sub domain {
    my ($self, $email) = @_;
    return $email =~ s/.*@//;
}

1;

__END__

=pod

=head1 NAME

Mailer - My author was too lazy to write an abstract

=head1 SYNOPSIS

  my $object = Mailer->new(
      foo  => 'bar',
      flag => 1,
  );
  
  $object->dummy;

=head1 DESCRIPTION

The author was too lazy to write a description.

=head1 METHODS

=head2 new

  my $object = Mailer->new(
      foo => 'bar',
  );

The C<new> constructor lets you create a new B<Mailer> object.

So no big surprises there...

Returns a new B<Mailer> or dies on error.

=head2 dummy

This method does something... apparently.

=head1 SUPPORT

No support is available

=head1 AUTHOR

Copyright 2012 Anonymous.

=cut
