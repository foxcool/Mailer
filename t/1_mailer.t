#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use lib 'lib';
use Test::More tests => 21;

use Mailer;

note 'Action create object';

my $mailer = Mailer->new();
isa_ok( $mailer, 'Mailer' );

note 'Action test check_email()';

my $response = $mailer->check_email('info@mail.ru');
ok( $response, 'info@mail.ru - is a valid address' );

$response = $mailer->check_email('support@vk.com');
ok( $response, 'support@vk.com - is a valid address' );

$response = $mailer->check_email('ddd@rambler.ru');
ok( $response, 'ddd@rambler.ru - is a valid address' );

$response = $mailer->check_email('roxette@mail.ru');
ok( $response, 'roxette@mail.ru - is a valid address' );

$response = $mailer->check_email('sdfsdf@@@@@rdfdf');
ok( !$response, 'sdfsdf@@@@@rdfdf - is a INVALID address' );

$response = $mailer->check_email('example@localhost');
ok( !$response, 'example@localhost - is a INVALID address' );

$response = $mailer->check_email('иван@иванов.рф');
ok( !$response, 'иван@иванов.рф - is a INVALID address' );

$response = $mailer->check_email('ivan@xn--c1ad6a.xn--p1ai');
ok( $response, 'ivan@xn--c1ad6a.xn--p1ai - is a valid address' );

$response = $mailer->check_email('support.of.white-house@mail.whitr-vk.gov');
ok( $response,
    'support.of.white-house@mail.whitr-vk.gov - is a valid address' );

note 'Action test split_domain()';

$response = $mailer->split_domain('ivan@xn--c1ad6a.xn--p1ai');
is( $response, 'xn--c1ad6a.xn--p1ai', 'Domain: xn--c1ad6a.xn--p1ai' );

$response = $mailer->split_domain('info@mail.ru');
is( $response, 'mail.ru', 'Domain: mail.ru' );

$response = $mailer->split_domain('sdfsdf@@@@@rdfdf');
is( $response, 'INVALID', 'Domain: INVALID' );

$response = $mailer->split_domain('support.of.white-house@mail.whitr-vk.gov');
is( $response, 'mail.whitr-vk.gov', 'Domain: mail.whitr-vk.gov' );

note 'Action test open_file()';

my $fh = eval { $mailer->open_file('./t/mails.txt') };
ok( !$@, 'Opening OK' );

$response = eval { $mailer->open_file() };
ok( $@, 'Opening NOT OK' );

$response = eval { $mailer->open_file('sksfs/fs/fs/f/s') };
ok( $@, 'Opening NOT OK' );

note 'Action test get_domain()';

$response = $mailer->get_domain($fh);
is( $response, 'mail.ru', 'Get domain OK');
close $fh;

note 'Action test get_domains_hash()';

$fh = $mailer->open_file('./t/mails.txt');
my %domains = $mailer->get_domains_hash($fh);
close $fh;
is( $domains{'rambler.ru'}, 1, 'Get domains HASH OK');

note 'Action test format_stat()';

$response = $mailer->format_stat(%domains);
like( $response, qr/INVALID/, 'format_stat OK' );

note 'Action test run()';
$response = $mailer->run('./t/mails.txt');
is( $response, 'OK', 'Run method works OK' );
