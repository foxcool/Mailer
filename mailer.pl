#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use lib './lib';

use Mailer;

my $mailer   = Mailer->new();
my $filepath = shift;
$mailer->run($filepath);
