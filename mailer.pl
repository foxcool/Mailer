#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use lib './lib';

use Mailer;

my $mailer = Mailer->new();
my %domains;

while (<>) {
    chomp;
    $domains{$mailer->domain($_)}++;
}

my @sorted_keys = sort { $domains{$b} <=> $domains{$a} } keys %domains;
foreach (@sorted_keys) {
    say sprintf ( "%20s %10s", $_, $domains{$_} );
}