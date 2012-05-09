package Mailer;

# Mailer - module for counting domains.

use 5.010;
use strict;
use warnings;

use Email::Valid;
require Carp;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self  = {@_};
    
    bless $self, $class;
}

sub check_email {
    my ( $self, $email ) = @_;
    
    Carp::croak("Email required for this action") unless $email;
    return Email::Valid->address($email);
}

sub split_domain {
    my ( $self, $email ) = @_;
    
    Carp::croak("Email required for this action") unless $email;
    if ( $self->check_email($email) ) {
        $email =~ s/.*@//;
        return $email;
    }
    else { return 'INVALID'; }
}

sub run {
    my ( $self, $filepath ) = @_;

    Carp::croak("Path to file with emails required for this action") unless $filepath;    
    my $fh      = $self->open_file($filepath);
    my %domains = $self->get_domains_hash($fh);
    close $fh;
    print $self->format_stat(%domains);
    return 'OK';
}

sub open_file {
    my ( $self, $filepath ) = @_;
    
    Carp::croak("Path to file with emails required for this action") unless $filepath;
    open my $fh, '<', $filepath or die($!);
    return $fh;
}

sub get_domain {
    my ( $self, $fh ) = @_;
    
        
    Carp::croak("File handler required for this action") unless $fh;
    my $email = <$fh>;
    if ($email) {
        chomp $email;
        return $self->split_domain($email);
    }
}

sub get_domains_hash {
    my ( $self, $fh ) = @_;
    
    Carp::croak("File handler required for this action") unless $fh;
    my %domains;
    while ( my $domain = $self->get_domain($fh) ) {
        $domains{$domain}++;
    }
    return %domains;
}

sub format_stat {
    my ( $self, %domains ) = @_;

    Carp::croak("Domains HASH required for this action") unless %domains;    
    my @keys = sort { $domains{$b} <=> $domains{$a} } keys %domains;
    my $result;
    $result .= "$_\t$domains{$_}\n" for @keys;
    return $result;
}

1;

__END__

=pod

=head1 NAME

Mailer - module for counting domains.

=head1 SYNOPSIS

    my $mailer = Mailer->new();
    $mailer->run('data.txt');

=head1 DESCRIPTION

Just test.

=head1 METHODS

=head2 new

    my $object = Mailer->new();

The C<new> constructor lets you create a new B<Mailer> object.

=head2 check_email

    say 'good' if $mailer->check_email('vasya@gmail.com');

This method check email with Email::Valid.

=head2 domain

    my $domain = $mailer->domain('cool@nasa.gov');

This method returns domain of email.

=head2 run

    $mailer->run('mails.txt');
    
This method get a path to file with emails and returns domaind with count data.

=head2 open_file

    my $fh = $mailer->open_file($filepath);

Returns the filehandler. Gets path to the file.

=head2 get_domain

    $response = $mailer->get_domain($fh);

Gets the filehandler and returns domain of email address in file.

=head2 get_domains_hash

    my %domains = $mailer->get_domains_hash($fh);

Gets the filehandler and returns a hash with domains as a keys and sum as
a values.

=head2 sort_hash_keys

    my @keys = $mailer->sort_hash_keys(%domains);

Returns sorted keys array of inputed domains hash.

=head2 format_stat

    $response = $mailer->format_stat(%domains);

Gets a hash with domains and sum. Returns formatted text. Such as:

                INVALID          3
                mail.ru          2
    xn--c1ad6a.xn--p1ai          1
                 vk.com          1
             rambler.ru          1

=head1 SUPPORT

No support is available

=head1 AUTHOR

Copyright 2012 Alexander Babenko.

=cut
