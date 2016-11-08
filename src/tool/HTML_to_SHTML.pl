#! /usr/bin/perl -w
use strict;

# Copiright (c) 2004 Gérald Niel
# Intégration de la doc au site web
# This program is issued under the GNU General Public License

undef $/;
my $tmp = <>;

# on supprime les commentaires
$tmp =~ s{<!--[^<>]*-->\n}{}gs;

# Remplacement des Headers par les includes
my $start = q{<?xml version="1.0" encoding="iso-8859-1"?>};
my $end = q{<body>};
$tmp =~ s{\Q$start\E.*?$end}{<!--#include virtual="../../templates/head-doc.inc.fr"-->\n<!--#include virtual="../../templates/menu.inc.fr"-->\n<!--#include virtual="../../templates/doc.inc.fr"-->\n}s;
$tmp =~ s{</body>\n</html>}{\n<!--#include virtual="../../templates/footer.inc.fr"-->}s;

# on supprime les retours chariots supperflus
$tmp =~ s{\n<br />(</h[\d0-9]>)}{$1}gs;
$tmp =~ s{\n<br />\n<br /></li>}{</li>}gs;
$tmp =~ s{\n<br />\n<br />\n}{</p>\n<p>}gs;
$tmp =~ s{\n<br />\n<br /></p>}{</p>}gs;
$tmp =~ s{<br /></p>}{</p>}gs;
$tmp =~ s{<p><br />\n<br /></p>}{}gs;

# modification des liens html -> shtml
$tmp =~ s{(<a href="[^"]*)\.html((?:\#[^"]+)?">)}{$1\.shtml$2}gs;
$tmp =~ s{(<a href=")\n([^"]*)\.html((?:\#[^"]+)?">)}{$1$2\.shtml$3}gs;
$tmp =~ s{(<a href=)\n("[^"]*)\.html((?:\#[^"]+)?">)}{$1$2\.shtml$3}gs;
$tmp =~ s{(<a href=")index\.php(">)}{$1index\.shtml$2}gs;

# ajustement du niveau des titres
$tmp =~ s{<h5}{<h6}gs;
$tmp =~ s{</h5>}{</h6>}gs;
$tmp =~ s{<h4}{<h6}gs;
$tmp =~ s{</h4>}{</h6>}gs;
$tmp =~ s{<h3}{<h5}gs;
$tmp =~ s{</h3>}{</h5>}gs;
$tmp =~ s{<h2}{<h4}gs;
$tmp =~ s{</h2>}{</h4>}gs;
$tmp =~ s{<h1}{<h3}gs;
$tmp =~ s{</h1>}{</h3>}gs;

#suppression du copyright première page
$start = q{<h3 class="c1">Manuel de l'utilisateur de Grisbi</h3>};
$end =q{<h5 class="c3">Version 0.4.5 du 11 avril 2004</h5>};
$tmp =~ s{\Q$start\E.*?$end}{<h3>Sommaire</h3>}s;

# footer hevea
$tmp =~ s{(</ul>\n)<hr size="2" />\n<blockquote><em>(Ce document a été traduit de)}{$1<p id="hevea">$2}s;
$tmp =~ s{</em></blockquote>\n\n</div>}{</p>\n</div>}s;

# images navigation
$tmp =~ s{"previous_motif.gif"}{"/images/doc/previous.gif"}gs;
$tmp =~ s{"contents_motif.gif"}{"/images/doc/toc.gif"}gs;
$tmp =~ s{"next_motif.gif"}{"/images/doc/next.gif"}gs;

# styles navigation
$tmp =~ s{<p>(<a href="[^"]*"><img src="/images/doc/previous.gif")}{<p id="navig-top">$1}s;
$tmp =~ s{<p>(<a href="[^"]*"><img src="/images/doc/toc.gif")}{<p id="navig-top">$1}s;
$tmp =~ s{<hr />\n<p>(<a href="[^"]*"><img src="/images/doc/previous.gif")}{<hr />\n<p id="navig-bottom">$1}s;
$tmp =~ s{<hr />\n<p>(<a href="[^"]*"><img src="/images/doc/toc.gif")}{<hr />\n<p id="navig-bottom">$1}s;

#nettoyages name=""
$tmp =~ s{(<a )name="[^"]*" (href="[^"]*" id="[^"]*">)}{$1$2}gs;
$tmp =~ s{(<a )name="[^"]*"\n(href="[^"]*" id="[^"]*">)}{$1$2}gs;
$tmp =~ s{(<a )name="[^"]*" (id="[^"]*">)}{$1$2}gs;
$tmp =~ s{(<a )name="[^"]*" id=\n("[^"]*">)}{$1id=$2}gs;
$tmp =~ s{<p><a (id="[^"]*")></a></p>}{<div $1></div>}gs;

#images
$tmp =~ s{(<div class="c1">[^\n]*)\n}{$1 }gs;
$tmp =~ s{<div class="c1"></div> }{}gs;
$tmp =~ s{(</div>) }{$1}gs;
$tmp =~ s{<blockquote>\n<div class="c1"><img src="([^\.]*)\.gif" /></div>\n<br />\n<div class="c1">([^<]*)</div>\n<br />\n<a id="([^"]*)"></a>\n</blockquote>}{<div class="imgs" id="$3"><img src="/images/doc/$1\.png" alt="$2" /></div>\n<p class="imgs">$2</p>}gs;
$tmp =~ s{<blockquote>\n<div class="c1"><img src="([^\.]*)\.gif" /></div>\n<br />\n<div class="c1">([^<]*)</div>\n\n<br />\n<a id="([^"]*)"></a>\n</blockquote>}{<div class="imgs" id="$3"><img src="/images/doc/$1\.png" alt="$2" /></div>\n<p class="imgs">$2</p>}gs;
$tmp =~ s{<img src="([^\.]*)\.gif" />}{<img src="/images/doc/$1\.png" alt="" />}gs;
$tmp =~ s{<img src=\n"([^\.]*)\.gif" />}{<img src="/images/doc/$1\.png" alt="" />}gs;
$tmp =~ s{<blockquote>\n<a id="([^"]*)"></a>\n<div class="c1"><img src="([^"]*)" alt="" /></div>\n<br />\n<div class="c1">([^<]*)</div>\n<br />\n</blockquote>}{<div class="imgs" id="$1"><img src="$2\" alt="$3" /></div>\n<p class="imgs">$3</p>}gs;

#tables
$tmp =~ s{(</p>\n<table)[^>]*>}{$1>}gs;
$tmp =~ s{<td align="left" nowrap="nowrap">}{<td class="monaie">}gs;
$tmp =~ s{<td align="center" nowrap="nowrap">}{<td class="abbr">}gs;
$tmp =~ s{<td align="right" nowrap="nowrap">}{<td class="taux">}gs;

# Some w3c corrections
$tmp =~ s{<hr width="50%" size="1" />}{<hr />}gs;
$tmp =~ s{<dl compact="compact">}{<dl>}gs;
$tmp =~ s{<blockquote>(C'est un processus phonologique)}{<br />$1}s;
$tmp =~ s{(lorsque la syllabe qui le suit est atone\.)</blockquote>}{$1}s;
$tmp =~ s{\n</p>\n<div class="c1">(<em>[^<]*</em></p>)}{</p>\n<p style="text-align:center;">$1}gs;
$tmp =~ s{</em></div>\n<p><br />}{</em></p>\n<p>}gs;
$tmp =~ s{<div class="c1"><em>}{<p style="text-align:center;"><em>}gs;
$tmp =~ s{</div><p><br />}{</p>\n<p>}gs;
$tmp =~ s{</p>\n<p><ul>}{<ul>}gs; 

print $tmp;
