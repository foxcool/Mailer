package Mailer;

use 5.010;
use strict;
use warnings;

use Email::Valid;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self  = {@_};
    bless $self, $class;
}

sub email_check {
    my ($self, $email) = @_;
    return Email::Valid->address($email);
}

sub domain {
    my ($self, $email) = @_;
    if ( $self->email_check($email) ) {
        $email =~ s/.*@//;
        return $email;
    }
    else { return 'INVALID'; }
}

sub run {
    my ($self, $filepath) = @_;
    my $fh = $self->open_file($filepath);
    my %domains;
    while ( my $domain = $self->get_domain($fh) ) {
        $domains{$domain}++;
    };
    close $fh;
    print $self->format_stat(%domains);
}

sub open_file {
    my ($self, $filepath) = @_;
    die('Required file with emails!') unless $filepath;  
    open my $fh, '<', $filepath or die($!);
    return $fh;
}

sub get_domain {
    my ($self, $fh) = @_;
    my $email = <$fh>;
    if ($email) {
        chomp $email;
        return $self->domain($email);
    }
}

sub sort_hash_keys {
    my ($self, %domains) = @_;
    return sort { $domains{$b} <=> $domains{$a} } keys %domains if wantarray;
}

sub format_stat {
    my ($self, %domains) = @_;
    my @keys = $self->sort_hash_keys(%domains);
    my $result;
    $result .= sprintf ( "%20s %10s\n", $_, $domains{$_} ) for @keys;
    return $result;
}

1;

__END__

=pod

=head1 NAME

Mailer - module for checking email.

=head1 SYNOPSIS

  my $mailer = Mailer->new();
  
  print 'Email is VALID!' if $mailer->email_check($address);

=head1 DESCRIPTION

Just test.

=head1 METHODS

=head2 new

  my $object = Mailer->new();

The C<new> constructor lets you create a new B<Mailer> object.

=head2 email_check

This method check email with Email::Valid.

=head2 domain

This method returns domain of email.

=head1 SUPPORT

No support is available

=head1 AUTHOR

Copyright 2012 Alexander Babenko.

=cut
