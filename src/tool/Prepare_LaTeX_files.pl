#! /usr/bin/perl -w
use strict;
# Copyright (c) Sébastien Blondeel <Sebastien.Blondeel@ens.fr>
# This program is issued under the GNU General Public License

# Given a LaTeX source file, will replace the \url{} calls by \href{}
# calls as a pre-processing step for transformation to HTML by HeVeA
# (see http://pauillac.inria.fr/~maranget/hevea/doc/manual011.html#@default38)

# The more this level is the better, but the slower too...
my $LEVEL_OF_RECURSIVITY = 10;
my %B = ();
$B{0} = "[^{}]*";

for (my $i=1; $i<=$LEVEL_OF_RECURSIVITY; $i++) {
  $B{$i} = $B{0}."(?:\\{$B{$i-1}\\}".$B{0}.")*";
}
my $B = $B{$LEVEL_OF_RECURSIVITY};

#########################################################################

sub file_read {
  my $filename = shift;
  local undef $/;
  local *FILE;
  open (FILE, $filename) || die ("Cannot open ``$filename'' for reading: $!\n");
  my $res = <FILE>;
  close FILE;
  return $res;
}

sub file_write {
  my ($filename, $file_content) = @_;
  local *FILE;
  open (FILE, "> $filename") || die ("Cannot open ``$filename'' for writing: $!\n");
  print FILE $file_content;
  close FILE;
}

sub file_treat {
  my $filename = shift;
  my $tmp = &file_read($filename);

  # Special for Daniel Cartron: add mailto: urls in HTML format
  $tmp =~ s/(\\urldef{\\url\w+Email}(?:%[^\n]*\n)?\\url{)/$1mailto:/gs;
  
  # Footnote bracketed calls
  $tmp =~ s/((?:\\\w+)?{$B})\\footnote{(\\url\w+(?:{})?)\.?}/\\ahref{$2}{$1}/gs;
  # Bracketed calls -- watch out do not take \urldef's
  $tmp =~
  s/((?:\\\w+)?{$B}):?\s+(\\url(?:def\w+|(?!def)\w+)(?:{})?)/\\ahref{$2}{$1}/gs;
  # Bracketed calls in front of parentheses -- watch out do not take \urldef's
  $tmp =~
  s/((?:\\\w+)?{$B})\s+\((\\url(?:def\w+|(?!def)\w+)(?:{})?)\)/\\ahref{$2}{$1}/gs;
  # Special cases
  #   (GFDL English text by the FSF)
  $tmp =~ s<See\s+(http://www\.gnu\.org/copyleft/)\.><See \\href{$1}{$1}.>gs;
  
  # Circumventing HeVeA bugs (or misfeatures)
  $tmp =~ s/{\\penalty\-?\d+$B}//gs;
  $tmp =~ s/\\v(ref{$B})/\\$1/gs;
  $tmp =~ s/(\\begin|\\end){longtable}/$1\{tabular\}/gs;
  
  $tmp =~ s/\\v(ref{$B})/\\$1/gs;
  
  #These two do not demand to group the URL text between {} but
  #  often guess wrong of course...
  # s/(\S*[^\s%])\s+\((\\url\w+(?:{})?)\)/\\ahref{$2}{$1}/gs
  # s/(\S*[^\s%]):?\s+(\\url\w+(?:{})?)/\\ahref{$2}{$1}/gs


  # oplus and ominus
  $tmp =~ s/\$\\oplus\$/XXXTODOXXXOPLUSXXXTODOXXX/gs;  # (+)
  $tmp =~ s/\$\\ominus\$/XXXTODOXXXOMINUSXXXTODOXXX/gs; # (-)

  return $tmp;
}

#########################################################################

my $dir = shift;
die "$0: I need a directory name!\n" unless defined $dir;
die "$0: Directory ``$dir'' does not exist!\n" unless -d $dir;
print "$0: Directory ``$dir'' exists...\n";

foreach my $filename (@ARGV) {
  print STDERR "$0: Treating file ``$filename''\n";
  &file_write("$dir/$filename", &file_treat($filename));
}
