use 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'         => 'Finance::YahooJPN::Sym2Name',
	'VERSION_FROM' => 'Sym2Name.pm',
	'PREREQ_PM'    => {
		'Exporter'    => '5.566',
		'Carp'        => '1.01',
		'LWP::Simple' => '1.36',
		'Encode'      => '1.98',
	},
	($] >= 5.005 ? (
		'ABSTRACT' => 'converts a Japanese stock symbol to the name',
		'AUTHOR'   => 'Masanori HATA <lovewing@geocities.co.jp>',
	) : ()),
);
