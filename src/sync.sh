#!/bin/bash

set -e

# update the web site at sourceforge.net
pushd $(dirname $0)/html_img
rsync --recursive --verbose --update .  ludov@web.sourceforge.net:/home/project-web/grisbi/htdocs/html/
popd

# Update the English manual
pushd $(dirname $0)/html_img-en
rsync --recursive --verbose --update .  ludov@web.sourceforge.net:/home/project-web/grisbi/htdocs/html-en/
popd
