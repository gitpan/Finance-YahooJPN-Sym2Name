#!/usr/local/bin/perl -w
use 5.008;
use strict;
use warnings;

use Module::Build;

Module::Build->new(
    module_name       => 'Finance::YahooJPN::Sym2Name',
    dist_version_from => 'Sym2Name.pm',
    dist_author       => 'Masanori HATA <http://www.mihr.net> (Saitama, JAPAN)',
    dist_abstract     => 'to convert a Japanese stock symbol to the name',
    license           => 'perl',
    requires          => {
        'perl'         => '5.8.0',
    },
    recommends        => {
        'perl'         => '5.12.2',
    },
    pm_files          => {
        'Sym2Name.pm'   => 'lib/Finance/YahooJPN/Sym2Name.pm',
    },
    test_files        => ['t/Sym2Name.t'],
    create_readme     => 1,
    )->create_build_script;
