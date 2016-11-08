#! /usr/bin/perl -w
use strict;
# Copyright (c) Sébastien Blondeel <Sebastien.Blondeel@ens.fr>
# This program is issued under the GNU General Public License

my $DEBUG = 0;
my $MAX_WIDTH = 800; # use 0 to deactivate

my $tex_file  = shift || die "No TeX file specified!\n";
my $html_file = shift || die "No HTML file specified!\n";
print STDERR "$0: TeX file=``$tex_file'' HTML file=``$html_file''\n";
my $do_the_links = shift || 0;

my $tex  = &file_read($tex_file);
print STDERR "$0: TeX file=``$tex_file'' (", length($tex), " bytes)\n";

my $html = &file_read($html_file);
print STDERR "$0: HTML file=``$html_file'' (", length($html), " bytes)\n";

# We clean the whole-line comments from the TeX
$tex =~ s/^%.*//gm;

my $files_included = 0;
my $MAX_FILES_INCLUDED = 1000;
while ($tex =~ s/\n[ \t]*(\\include|\\input){([^{}]+)}[ \t]*\n/&file_input_include($1, $2)/se) {
  my $filename = $1;

  # We clean the whole-line comments from the TeX
  $tex =~ s/^%.*//gm;

  $files_included ++;
  die "Too many files included ($MAX_FILES_INCLUDED) -- possibly a loop\n"
    if $files_included > $MAX_FILES_INCLUDED;
  print STDERR "$0: included file ``$filename''\n";

}

my $IFILLUSTRATION = 1;
# Trying to guess if we have images or not
if ( ( ($tex =~ m/\n\\Illustrationtrue/s) && ($tex !~ m/\n\\Illustrationfalse/s) ) 
     || ($tex =~ m/\n\\Illustrationfalse.*\n\\Illustrationtrue/s) ) {
  print STDERR "$0: Recognized a configuration with images activated\n";
  $IFILLUSTRATION = 1;
} elsif ( ( ($tex =~ m/\n\\Illustrationfalse/s) && ($tex !~ m/\n\\Illustrationtrue/s) ) 
     || ($tex =~ m/\n\\Illustrationtrue.*\n\\Illustrationfalse/s) ) {
  print STDERR "$0: Recognized a configuration with images not activated\n";
  $IFILLUSTRATION = 0;
} else {
  print STDERR "$0: XXX Could recognize the situation with respect to images\n";
  exit 1;
}

if ($IFILLUSTRATION == 0) {
  $tex =~ s/\\ifIllustration.*?(?:\\else|\\fi)//gs;
}

my @tex_images = ();
my @html_images = ();

# The more this level is the better, but the slower too...
my $LEVEL_OF_RECURSIVITY = 10;
my %B = ();
$B{0} = "[^{}]*";
for (my $i=1; $i<=$LEVEL_OF_RECURSIVITY; $i++) {
  $B{$i} = $B{0}."(?:\\{$B{$i-1}\\}".$B{0}.")*";
}
my $B = $B{$LEVEL_OF_RECURSIVITY};

while ($tex =~ m/\\includegraphics(?:\[[^\[\]]+\])?{($B)}/gs) {
  push @tex_images, $1;
}
while ($html =~ m/<IMG SRC="([^"]+)">/gs) {
  push @html_images, $1;
}

if ($DEBUG) {
  print "TeX images:\n";
  print join(" -- ", @tex_images), "\n";
  print "HTML images:\n";
  print join(" -- ", @html_images), "\n";
}

unless ((scalar @tex_images) == (scalar @html_images)) { 

  my $tex_n  = scalar @tex_images;
  my $html_n = scalar @html_images;

  my $n = $tex_n;
  $n = $html_n if $html_n > $tex_n;

  for (my $i = 0; $i < $n; $i ++) {

    my ($tex_i, $html_i) = ("", "");
    $tex_i = $tex_images[$i] if $i < $tex_n;
    $html_i = $html_images[$i] if $i < $html_n;

    print STDERR "$i\tTeX: ``$tex_i''\tHTML:``$html_i''\n";

  }

  die "Not the same number of images!\n"

}

while (my $tex_image = pop @tex_images) {
  my $html_image = pop @html_images;
  my $command = "test -e $html_image || ln -s ../$tex_image.png $html_image";

  print $command, "\n";
  system $command if $do_the_links; 
}

sub file_read {
  my $filename = shift;
  local *FILE;
  local undef $/;
  my $res = "";
  open (FILE, $filename) ||
    die "Cannot open «$filename» for reading: $!\n";
    $res = <FILE>;
  close FILE; 
  return $res;
}

sub file_input_include {
  my ($command, $filename) = @_;
  die "$0: file_input_include: Unknown command ``$command''\n"
    unless $command eq "\\input" || $command eq "\\include";
  return &file_read($filename) if -e $filename;
  return &file_read($filename.".tex") if -e $filename.".tex";
  die "$0: file_input_include: $command not found: ``$filename''\n";
}
