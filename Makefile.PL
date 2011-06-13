use 5.008;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'         => 'Finance::YahooJPN::Sym2Name',
	'VERSION_FROM' => 'Sym2Name.pm',
	($] >= 5.005 ? (
		'ABSTRACT' => 'to convert a Japanese stock symbol to the name',
		'AUTHOR'   => 'Masanori HATA <http://www.mihr.net/>',
	) : ()),
);
