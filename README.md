Grisbi documentation
====================

The procedure to generate the Original French Manual has not changed and the English version can be obtained simply by adding a single macro definition to the make command line.  Follow the instructions below to generate the English User Manual.

How to create the English User Manual
=====================================

Currently only the make file for the html version of the English User Manual with no figures has been tested. 

To build the English version of the manual as a series of html pages issue the following make commands exactly as in the lines below

`make distclean`

`make FILE=grisbi-manuel-en html_txt`

