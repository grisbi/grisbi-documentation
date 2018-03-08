Grisbi documentation
====================

The procedure to generate the Original French Manual has not changed, navigate to the /src directory and issue the command  
`make all`  
or the English version can be obtained by following the instructions below.

How to install picins
=====================

The LaTeX package picins (insert pictures into paragraphs) is not provided by any Debian package.

To install it locally:  
- ``wget http://mirrors.ctan.org/macros/latex209/contrib/picins.zip`` or get it from https://ctan.org/pkg/picins  
- ``unzip picins.zip``  
- ``mkdir -p ~/texmf/tex/latex``  
- ``mv picins ~/texmf/tex/latex``  
- ``texhash ~/texmf``  

See also https://wiki.debian.org/Latex or https://wiki.debian.org/fr/Latex for the French version.

How to create the English User Manual
=====================================

To build the English version of the manual as a series of html pages and as a single pdf document issue the following make command  
`make English`  

Contributing to the English User Manual
=======================================
There is still much work to be done to finish off the English User Manual and your help would be very welcaome.  Plesase read HelpTranslate-en.md for detailed instructions about how you can contribute your time and skills and make a big difference to all the English speaking users of Grisbi.




