#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use lib 'lib';
use Test::More 'no_plan';

use Mailer;

note 'Action create object';

my $mailer = Mailer->new();
isa_ok( $mailer, 'Mailer' );

note 'Action test email_check()';

my $response = $mailer->email_check('info@mail.ru');
ok( $response, 'info@mail.ru - is a valid address' );

$response = $mailer->email_check('support@vk.com');
ok( $response, 'support@vk.com - is a valid address' );

$response = $mailer->email_check('ddd@rambler.ru');
ok( $response, 'ddd@rambler.ru - is a valid address' );

$response = $mailer->email_check('roxette@mail.ru');
ok( $response, 'roxette@mail.ru - is a valid address' );

$response = $mailer->email_check('sdfsdf@@@@@rdfdf');
ok( !$response, 'sdfsdf@@@@@rdfdf - is a INVALID address' );

$response = $mailer->email_check('example@localhost');
ok( !$response, 'example@localhost - is a INVALID address' );

$response = $mailer->email_check('иван@иванов.рф');
ok( !$response, 'иван@иванов.рф - is a INVALID address' );

$response = $mailer->email_check('ivan@xn--c1ad6a.xn--p1ai');
ok( $response, 'ivan@xn--c1ad6a.xn--p1ai - is a valid address' );

$response = $mailer->email_check('support.of.white-house@mail.whitr-vk.gov');
ok( $response,
    'support.of.white-house@mail.whitr-vk.gov - is a valid address' );

note 'Action test domain()';

$response = $mailer->domain('ivan@xn--c1ad6a.xn--p1ai');
is( $response, 'xn--c1ad6a.xn--p1ai', 'Domain: xn--c1ad6a.xn--p1ai' );

$response = $mailer->domain('info@mail.ru');
is( $response, 'mail.ru', 'Domain: mail.ru' );

$response = $mailer->domain('sdfsdf@@@@@rdfdf');
is( $response, 'INVALID', 'Domain: INVALID' );

$response = $mailer->domain('support.of.white-house@mail.whitr-vk.gov');
is( $response, 'mail.whitr-vk.gov', 'Domain: mail.whitr-vk.gov' );

note 'Action test open_file()';

my $fh = eval { $mailer->open_file('./t/mails.txt') };
ok( !$@, 'Opening OK' );

$response = eval { $mailer->open_file() };
is(
    $@,
    "Required file with emails! at lib/Mailer.pm line 44.\n",
    'Opening NOT OK'
);

$response = eval { $mailer->open_file('sksfs/fs/fs/f/s') };
is(
    $@,
    "No such file or directory at lib/Mailer.pm line 45.\n",
    'Opening NOT OK'
);

note 'Action test get_domain()';

$response = $mailer->get_domain($fh);
is( $response, 'mail.ru', 'Get domain OK');