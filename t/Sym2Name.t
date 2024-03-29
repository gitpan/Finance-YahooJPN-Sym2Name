#!/usr/local/bin/perl -w
use 5.008;
use strict;
use warnings;
use utf8;

use Test::More tests => 5;

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Sym2Name.t'
# Note: This test requires internet connection.

BEGIN {
	use_ok('Finance::YahooJPN::Sym2Name')
};

my $name0 = sym2name('0000');
my $name1 = sym2name('6758');
my $name2 = sym2name('6758', 'eng');
my $name3 = sym2name('6758', 'jpn');

my $expected0 = '(n/a)';
my $expected1 = 'SONY CORPORATION';
my $expected2 = 'SONY CORPORATION';
my $expected3 = 'ソニー';

is( $name0, $expected0, "\$symbol = (missing code number)" );
is( $name1, $expected1, "\$lang = (omit)" );
is( $name2, $expected2, "\$lang = 'eng'" );
is( $name3, $expected3, "\$lang = 'jpn'" );
