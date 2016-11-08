#! /usr/bin/perl -w
use strict;
# Copyright (c) Sébastien Blondeel <Sebastien.Blondeel@ens.fr>
# This program is issued under the GNU General Public License

# Corrects some bugs produces by HeVeA 1.06

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

sub _check_no_li {
  my $chunk = shift;

  if ($chunk =~ m{
      <LI><BR>[\x20\t]*\n
      [\x20\t]*<BR>[\x20\t]*\n
      [\x20\t]*(.+?)<BR>[\x20\t]*\n}sxi) {

    my $item = $1;

    unless ($item =~ m/<LI>/si) {
      my $_item = $item;
      $_item =~ s/\s+/ /gs;
      print STDERR "$0: simplified BUG in list item ``$_item''\n";
      return "<li>$item</li>\n" 
    } else {
      return $chunk;
    }

  } else { # should not happen

    return $chunk;

  }
  
}

sub file_treat {
  my $filename = shift;
  my $tmp = &file_read($filename);

  # Two passes because of overlapping
  for (my $i = 1; $i <= 2; $i++) {
    $tmp =~ s{
      (<LI><BR>[\x20\t]*\n
      [\x20\t]*<BR>[\x20\t]*\n
      [\x20\t]*.+?<BR>[\x20\t]*\n)}
      {&_check_no_li($1)}gsxie;
  }

  # oplus and ominus
  $tmp =~ s/XXXTODOXXXOPLUSXXXTODOXXX/\&\#x2295;/gs;  # (+)
  $tmp =~ s/XXXTODOXXXOMINUSXXXTODOXXX/\&\#x2296;/gs; # (-)

  return $tmp;
}

#########################################################################

foreach my $filename (@ARGV) {
  print STDERR "$0: Treating file ``$filename''\n";
  my $tmp = &file_read($filename);
  &file_write($filename, &file_treat($filename));
}
