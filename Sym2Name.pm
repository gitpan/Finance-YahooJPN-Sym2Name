package Finance::YahooJPN::Sym2Name;

use 5.008;
use strict;
use warnings;
use utf8;

our $VERSION = '0.04'; # 2011-06-14 (since 2002-03-26)
our @ISA    = qw(Exporter);
our @EXPORT = qw(sym2name);

use Exporter;
use Carp;
use IO::Socket;

my $Server = 'stocks.finance.yahoo.co.jp';

=head1 NAME

Finance::YahooJPN::Sym2Name - converts a Japanese stock symbol to the name

=head1 SYNOPSIS

  use Finance::YahooJPN::Sym2Name;
  
  # get the name of company of stock symbol code '6758'
  my $stockname = sym2name('6758');
  
  print $stockname; # it prints 'SONY CORPORATION'

=head1 DESCRIPTION

This module converts a Japanese stock symbol code to the name of company. Japanese stock markets use 4-digit code number as stock symbol. You can get either English or Japanese name of company.

=head1 FUNCTIONS

=over

=item sym2name($symbol [, $lang])

This function returns a string of the name of company from C<$symbol> (a stock symbol code of 4-digit number).

In case it were a missing code number, the module returns string '(n/a)';

C<$lang> attribute specifies language mode of the company's name. A C<$lang> value is 'eng' (in English) or 'jpn' (in Japanese). This attribute is omittable and the default value is 'eng'.

Note that string data under 'jpn' C<$lang> mode is encoded with UTF-8 character encoding.

=cut

sub sym2name ($;$) {
    my($symbol, $lang) = @_;
    
    unless ($symbol =~ /^\d{4}$/) {
        croak "stock symbol code must be specified with 4-digit code number";
    }
    
    my $url = "http://stocks.finance.yahoo.co.jp/stocks/profile/?code=$symbol";
    my @html = fetch($url);
    
    # in case it were a missing code number
    foreach my $line (@html) {
        if ($line =~ m/一致する銘柄は見つかりませんでした/) {
            return '(n/a)';
        }
    }
    
    my %name;
    # find and extract the name of company in Japanese
    foreach my $line (@html) {
        $line =~ m/<title>(.+?)【$symbol】.*?<\/title>/;
        utf8::decode($name{'jpn'} = $1);
    }
    $name{'jpn'} =~ s/\(株\)//;
    $name{'jpn'} =~ s/^\s*//;
    $name{'jpn'} =~ s/\s*$//;
    
    # find and extract the name of company in English
    for (my $i = 0; $i < @html; $i++) {
        if ($html[$i] eq '<th nowrap>英文社名</th>') {
            $html[$i + 1] =~ m/<td colspan="3">(.+?)<\/td>/;
            $name{'eng'} = $1;
            $name{'eng'} = full2half($name{'eng'});
            last;
        }
    }
    
    if ($lang and lc($lang) eq 'jpn') {
        return $name{'jpn'};
    }
    else {
        return $name{'eng'};
    }
}

sub fetch ($) {
    my $abs_path = shift;
    
    my $sock = IO::Socket::INET->new(
        PeerAddr => $Server,
        PeerPort => 'http(80)',
        Proto    => 'tcp',
        ) or die "Couldn't connect to $Server";
    
    print $sock <<"EOF";
GET $abs_path HTTP/1.1
Host: $Server

EOF
    
    chomp(my @html = <$sock>);
    close $sock;
    
    foreach my $line (@html) {
        utf8::decode($line);
    }
    return @html;
}

sub full2half ($) {
	my $string = shift;
	
	$string =~ tr/０-９Ａ-Ｚａ-ｚ/0-9A-Za-z/;
	$string =~ tr[―～　＿｜．，：；！？][-~ _|.,:;!?];
	$string =~ tr/（）［］｛｝＜＞《》【】‘’“”/()[]{}<><>[]`\'""/;
	$string =~ tr[－＋／＊％＝×][-+/*%=*];
	$string =~ tr/‐＠＃＄￥＆＾・/-@#$\\&^-/;
	
	return $string;
}

1;
__END__

=back

=head1 AUTHOR

Masanori HATA L<http://www.mihr.net/> (Saitama, JAPAN)

=head1 COPYRIGHT

Copyright ©2002-2011 Masanori HATA. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

