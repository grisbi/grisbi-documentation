#! /usr/bin/perl -w
use strict;
# Copyright (c) Sébastien Blondeel <Sebastien.Blondeel@ens.fr>
# This program is issued under the GNU General Public License

undef $/;
my $tmp = <>;

$tmp =~ 
s{<!DOCTYPE\s+HTML\s+PUBLIC\s+"-//W3C//DTD\s+HTML\s+4\.0\s+Transitional//EN"
  \s+"http://www\.w3\.org/TR/REC-html40/loose\.dtd">}
 {<?php
  if (!isset(\$mainfile)) \{include("mainfile.php");\}}sx;

$tmp =~ s/<HTML>//s;
$tmp =~ s{</?HEAD>}{}gs;
$tmp =~ s{<TITLE>([^<>]*)</TITLE>}{}s;

$tmp =~ s{\s*<META\s+http-equiv="Content-Type"\s+content="text/html;\s+charset=ISO-8859-15?">}{\n  include("header.php");}sx;

$tmp =~ s{\s*<META\s+name="GENERATOR"\s+content="hevea \d+\.\d+">\s*}{\n  OpenTable();\n}s;

$tmp =~ s/<BODY BGCOLOR="#[\da-fA-F]+">/?>\n/s;

$tmp =~ s{</BODY>}{\n\n<?php\n  CloseTable();}s;
$tmp =~ s{</HTML>}{  include("footer.php");\n?>}s;

$tmp =~ s{(<A HREF="[^"]*)\.html((?:\#[^"]+)?">)}{$1\.php$2}gs;

$tmp =~ s{(<A HREF=")index\.php(">)}{$1modules.php?name=Manuel$2}gs;

print $tmp;
