package Finance::YahooJPN::Sym2Name;

use 5.008;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01'; # 2003-09-22 (since 2002-03-26)
our @ISA    = qw(Exporter);
our @EXPORT = qw(sym2name);

use Exporter;
use Carp;
use LWP::Simple;
use Encode;

=head1 NAME

Finance::YahooJPN::Sym2Name - converts a stock symbol to the name

=head1 SYNOPSIS

  use Finance::YahooJPN::Sym2Name;
  
  # get the name of company of stock symbol code '6758'
  my $stockname = sym2name('6758');
  
  print $stockname;

=head1 DESCRIPTION

This module converts a stock symbol code to the name of company. Japanese stock markets use 4-digit code number as stock symbol. You can get either English or Japanese name of company.

=head1 FUNCTIONS

=over

=item sym2name($symbol [, $lang])

This function returns a string of the name of company from C<$symbol> (a stock symbol code of 4-digit number).

C<$lang> attribute specifies language mode of the company's name. A C<$lang> value is 'eng' (in English) or 'jpn' (in Japanese). This attribute is omittable and the default value is 'eng'.

Note that string data under 'jpn' C<$lang> mode is encoded with UTF-8 character encoding.

=cut

sub sym2name ($;$) {
	my($symbol, $lang) = @_;
	
	unless ($symbol =~ /^\d{4}$/) {
		croak "stock symbol code must be specified with 4-digit code number";
	}
	
	my $url = "http://profile.yahoo.co.jp/biz/fundamental/$symbol.html";
	my $html = fetch($url);
	
	# find and extract the name of company in Japanese
	$html =~ m/<TD bgColor="#6699cc">\n<FONT size="\+1"><B>(.*?)（.*）<\/B><\/FONT>\n/;
	my $name_jpn = $1;
	$name_jpn =~ s/\(株\)//;
	$name_jpn =~ s/^\s//;
	$name_jpn =~ s/\s$//;
	
	# find and extract the name of company in English
	$html =~ m/【英文社名】(.*?)<\/TD>/;
	my $name_eng = $1;
	$name_eng = full2half($name_eng);
	
	$lang = lc($lang);
	if ($lang eq 'jpn') { return encode('utf8', $name_jpn); }
	else                { return $name_eng; }
}

sub fetch ($) {
	my $url = shift;
	
	my $remotedoc = decode('euc-jp', get($url));
	
	return $remotedoc;
}

sub full2half ($) {
	my $string = shift;
	
	$string =~ tr/０-９Ａ-Ｚａ-ｚ/0-9A-Za-z/;
	$string =~ tr[―～　＿｜．，：；！？][-~ _|.,:;!?];
	$string =~ tr/（）［］｛｝＜＞《》【】‘’“”/()[]{}<><>[]`\'""/;
	$string =~ tr[－＋／＊％＝×][-+/*%=*];
	$string =~ tr/＠＃＄￥＆＾/@#$\&^/;
	
	return $string;
}

1;
__END__

=head1 AUTHOR

Masanori HATA E<lt>lovewing@geocities.co.jpE<gt> (Saitama, JAPAN)

=head1 COPYRIGHT

Copyright (c)2002-2003 Masanori HATA. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

