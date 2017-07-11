#TODO overfull, underfull rules...

FILE=grisbi-manuel
VERSION=1.0
INCLUDES:=$(wildcard grisbi-manuel*.tex) $(wildcard tool/*.pl) Makefile
FIGURES_PNG:=$(wildcard image/screenshot/*.png) $(wildcard image/icon/*.png)
FIGURES_EPS:=$(patsubst %.png,%.eps,$(FIGURES_PNG))

XDVI=xdvi -s 0 -geometry -0+0 -margins 0cm -nopostscript
XPDF=xpdf -geometry 600x768+0+0 -z page
GV=gv

all:
	@echo '********************************************************'
	@echo '* BUILDING THE TEXT-ONLY PDF VERSION'
	@echo '********************************************************'
	$(MAKE) clean
	$(MAKE) pdf_txt
	@echo '********************************************************'
	@echo '* BUILDING THE TEXT-ONLY HTML VERSION'
	@echo '********************************************************'
	$(MAKE) clean
	$(MAKE) html_txt
	@echo '********************************************************'
	@echo '* BUILDING THE IMAGES PDF VERSION'
	@echo '********************************************************'
	$(MAKE) clean
	$(MAKE) pdf_img
	@echo '********************************************************'
	@echo '* BUILDING THE IMAGES HTML VERSION'
	@echo '********************************************************'
	$(MAKE) clean
	$(MAKE) html_img
	@echo '********************************************************'
	@echo '* BUILDING THE IMAGES shtml VERSION'
	@echo '********************************************************'
	$(MAKE) clean
	$(MAKE) shtml_img
	@echo '********************************************************'
	@echo '* RESULTING FILES:'
	@echo '********************************************************'
	@ls -ald html_{img,txt} shtml_img
	@du -ks html_{img,txt} shtml_img
	@echo '********************************************************'
	@echo '* TRANSFER THE FILES ON THE SERVER AND MIRRORS'
	@echo '********************************************************'
	$(MAKE) clean
	$(MAKE) transfer


pdf:	$(FILE).pdf
	@test -d pdf || mkdir pdf
	@echo See copy in pdf/
	@cp $(FILE).pdf pdf/$(FILE)-$(VERSION).pdf
	
pdf_indexglossary: $(FILE).pdf
	@texindy grisbi-manuel.idx
	@makeglossaries grisbi-manuel.glo
	@echo Remove pdf file
	@rm $(FILE).pdf
	@echo Compile again in pdf by make pdf to get index and glossary.

pdf_img:	img pdf
	@test -d pdf_img || mkdir pdf_img
	@echo That is now different : see copy in pdf_img/
	@mv $(FILE).pdf pdf_img/$(FILE)-img-$(VERSION).pdf
	@rm -R pdf

pdf_img_indexglossary:	img pdf
	@test -d pdf_img || mkdir pdf_img
	@mv $(FILE).pdf pdf_img/$(FILE)-img-$(VERSION).pdf
	@texindy grisbi-manuel.idx
	@makeglossaries grisbi-manuel.glo
	@echo Remove pdf file
	@rm pdf_img/$(FILE)-img-$(VERSION).pdf
	@echo Compile again in pdf by make pdf_img to get index and glossary.

pdf_txt:	txt pdf
	@test -d pdf || mkdir pdf
	@mv $(FILE).pdf pdf/$(FILE)-txt-$(VERSION).pdf	


html:	html/$(FILE).html

html/$(FILE).html:   $(INCLUDES)
	$(MAKE) boolean
	@#TODO recognize the French language and switch to French mode
	@mkdir -p .hevea_tmpdir html
	@perl tool/Prepare_LaTeX_files.pl .hevea_tmpdir *tex
# copy of macros.sty for html_img	
	cp -p macros.sty .hevea_tmpdir/
# must also get images
	ln -sf ../image .hevea_tmpdir/image			
# use -fix instead of calling hevea twice
	cd .hevea_tmpdir && \
	hevea -fix -O -I ../hva $(FILE).tex  	   
	cd .hevea_tmpdir && \
	perl -i -pe 's/<HR WIDTH="80%" SIZE=2>//gs' $(FILE).html
	cd .hevea_tmpdir && \
	perl ../tool/HeVeA_postprocess.pl $(FILE).html
	@echo File grisbi-manuel.html done	 
	cd .hevea_tmpdir && \
	hacha $(FILE).html
	@echo Note that errors « Warning: Undefined label: ... » are not significant and result only from an hevea bug.
	@echo File index.html done	 		
# rename the file displayed in one page	
	cd .hevea_tmpdir && mv $(FILE).html $(FILE)-1page.html
	@echo Rename the file displayed in 1 page done
# copy files into html/	
	cd .hevea_tmpdir &&  cp -p *.css ../html/     
	cd .hevea_tmpdir && cp -p *.html ../html/        
	cd .hevea_tmpdir && cp -p *.gif ../html/	
# create symbolic link to change the name of the file displayed in several pages	
	cd html && ln -s index.html $(FILE).html
	@echo Symbolic link to "grisbi-manuel.html" done	
	@echo Compilation in html completed		     
# create the archive for html
	cd html && tar -czf $(FILE)-html-$(VERSION).tar.gz $(FILE)* index.html *.gif 
	@test -d tgz_html || mkdir tgz_html
	@mv html/$(FILE)-html-$(VERSION).tar.gz tgz_html/$(FILE)-html-$(VERSION).tar.gz
	@echo Archive in tgz_html/ done	

html_img:	img html  	
	@rm -R tgz_html
	@echo Remove tgz_html/ directory -html without image- because the html files include now the image legend...	 	
	@#in case we compile with illustrations
	@(test -L .hevea_tmpdir/$(FILE)001.png && cp -pd .hevea_tmpdir/*.png html/) || true
	@cd html && (test -e image || cp -Rf ../image ../html)
	@echo Images added to html/	
	@mv html fr	
	@cp topic.dat fr/topic.dat
# create the archive for html_img
	@tar -czf $(FILE)-html_img-$(VERSION).tar.gz fr/$(FILE)* fr/image fr/index.html fr/*.gif INSTALL fr/topic.dat
	@test -d tgz_html_img || mkdir tgz_html_img
	@mv $(FILE)-html_img-$(VERSION).tar.gz tgz_html_img/$(FILE)-html_img-$(VERSION).tar.gz
	@mv fr html_img
	@echo Archive in tgz_html_img/ done

	
html_txt:	txt html
	@mv html fr
	@cp topic.dat fr/topic.dat
	@tar -czhf $(FILE)-txt-$(VERSION).tar.gz fr/$(FILE)* fr/index.html fr/*.gif INSTALL fr/topic.dat --exclude fr/$(FILE).html
	@test -d tgz || mkdir tgz
	@mv $(FILE)-txt-$(VERSION).tar.gz tgz/$(FILE)-txt-$(VERSION).tar.gz
	@mv fr html_txt


ps:	$(FILE).ps

ps_img:	img ps
	@mv $(FILE).ps $(FILE)-img-$(VERSION).ps

ps_txt:	txt ps
	@mv $(FILE).ps $(FILE)-txt-$(VERSION).ps


dvi: 	$(FILE).dvi

dvi_img:	img dvi
	@mv $(FILE).ps $(FILE)-img-$(VERSION).ps

dvi_txt:	txt dvi
	@mv $(FILE).dvi $(FILE)-txt-$(VERSION).dvi


shtml:	shtml/$(FILE).shtml

shtml_img:	img shtml
	@mv shtml shtml_img
	@cd shtml_img && rename 's/gif/png/' grisbi-manuel*.gif

shtml_txt:	txt shtml
	@mv shtml shtml_txt


img:
	@echo Linking to image mode
	@ln -sf $(FILE)-boolean-illustration-true.tex \
		$(FILE)-boolean-illustration.tex

txt:
	@echo Linking to text mode
	@ln -sf $(FILE)-boolean-illustration-false.tex \
		$(FILE)-boolean-illustration.tex

default:
	@echo Linking to default mode
	@ln -sf $(FILE)-boolean-illustration-false.tex \
		$(FILE)-boolean-illustration.tex

boolean:
	@echo Checking img/txt mode is set
	@test -L $(FILE)-boolean-illustration.tex || make default

v: dvi
	@$(XDVI) $(FILE) &

gv:	ps
	@$(GV) $(FILE) &

xpdf:	pdf
	@$(XPDF) $(FILE).pdf &

t test:
	$(MAKE) mrproper dvi ps pdf html
	$(MAKE) mrproper

w3m links lynx: html
	@$@ $(FILE).html

%.eps:	%.png
	@echo Convert $< $@
	@convert $< $@
 

shtml/$(FILE).shtml:	html/$(FILE).html
	@mv html shtml
	@cd shtml && rm -f *.shtml
	@cd shtml && for file in *.html; do tidy -f ../tidy-err.txt -config ../tool/tidy.cfg $$file > $$file.tmp; mv $$file.tmp $$file; done
	@cd shtml && for file in *.html; do perl ../tool/HTML_to_SHTML.pl < $$file > `echo $$file | sed -e 's/\.html$$/\.shtml/'`; done
	@cd shtml && rm -f $(FILE).html
	@cd shtml && rm -f *.html

$(FILE).dvi:	$(INCLUDES) $(FIGURES_EPS)
	$(MAKE) boolean
	@echo Generating $@...
	@# 3 fois pour la table des matières.
	@latex --interaction=batchmode $(FILE).tex || \
	  (grep -A5 '^! ' $(FILE).log; exit 1)
	@latex --interaction=batchmode $(FILE).tex
	@# famous problem with LaTeX: pagestyle in tableofcontents
	@# perl -i -pe 's/^/\\thispagestyle{fancy}\n/s' $(FILE).toc
	@latex --interaction=batchmode $(FILE).tex
	@grep Warning $(FILE).log || true
	@echo Done.

$(FILE).ps:	$(FILE).dvi
	$(MAKE) boolean
	@echo Generating $@...
	@dvips -q -t a4 -o $(FILE).ps $(FILE).dvi
	@echo Done.

$(FILE).pdf:	$(FILE).tex $(INCLUDES)
	$(MAKE) boolean
	@echo Generating $@...
	@pdflatex --interaction=batchmode $(FILE).tex || \
	  (grep -A5 '^! ' $(FILE).log; exit 1)
	@pdflatex --interaction=batchmode $(FILE).tex
	@pdflatex --interaction=batchmode $(FILE).tex
	@thumbpdf $(FILE).pdf
	@pdflatex --interaction=batchmode $(FILE).tex
	@grep Warning $(FILE).log || true
	@echo one.

transfer: transferpdf transferphp transfertgz transferpaq

transferpdf:
	ncftpput -f config/login_nerim.cfg /doc pdf/$(FILE)*.pdf
	ncftpput -f config/login_free.cfg /doc pdf/$(FILE)*.pdf
	ncftpput -f config/login_gegeweb.cfg /grisbi/doc pdf/$(FILE)*.pdf
	ncftpput -f config/login_grisbi.cfg /web-grisbi.org/htdocs/telechargement/doc pdf/$(FILE)*.pdf

transfertgz:
	ncftpput -f config/login_nerim.cfg /doc tgz/$(FILE)*
	ncftpput -f config/login_free.cfg /doc tgz/$(FILE)*
	ncftpput -f config/login_gegeweb.cfg /grisbi/doc tgz/$(FILE)*
	ncftpput -f config/login_grisbi.cfg /web-grisbi.org/htdocs/telechargement/doc tgz/$(FILE)*

transferpaq:
	ncftpput -f config/login_nerim.cfg /doc paq/$(FILE)*.tgz
	ncftpput -f config/login_free.cfg /doc paq/$(FILE)*.tgz
	ncftpput -f config/login_gegeweb.cfg /grisbi/doc paq/$(FILE)*.tgz
	ncftpput -f config/login_grisbi.cfg /web-grisbi.org/htdocs/telechargement/doc paq/$(FILE)*.tgz

transferphp:
	ncftpput -f config/login_grisbi.cfg /web-grisbi.org/htdocs/ php_img/$(FILE)*.*
	ncftpput -f config/login_grisbi.cfg /web-grisbi.org/htdocs/modules/Manuel php_img/index.php

clean:
	@echo -n Cleaning intermediate files...
	@#la commande @rm -f *.{aux,log,out,toc,tpt,bak,haux,lof,htoc,idx,ind,xdy,glg,glo,gls} ne fonctionne pas
	@rm -f *.aux *.bak *.glg *.glo *.gls *.haux *.htoc *.idx *.ind *.lof *.log *.out *.toc *.tpt *.xdy
	@rm -rf .hevea_tmpdir
	@rm -f thumb*.*
	@echo "  done."

mrp mrproper: distclean

distclean:	clean
	@echo -n Cleaning result files...
	@rm -f $(FILE){-img,-txt,}.{dvi,ps,pdf,html,shtml} $(FIGURES_EPS) \
	  $(FILE)-boolean-illustration.tex \
	@rm $(FILE).pdf	  
	@rm -Rf fr html html_img html_txt shtml shtml_img shtml_txt pdf pdf_img tgz_html tgz_html_img paq
	@echo "  done."
