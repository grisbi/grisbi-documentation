# How to assist in the production of the English manual

Please use a markdown file reading program (for example ReText) or read it on the GitHib website to display this file formatted as I intended it to be read.

I (*Bob Anderson*) will coordinate contributions to the English manual, at least until all the chapters of the Grisbi version 1.0 User Manual have been translated into English.  

For this reason please contribute your work to my fork of the manual at  
<https://github.com/doubledodge/grisbi-documentation>

I will in turn make sure the upstream master version at  
<https://github.com/grisbi/grisbi-documentation>  
is kept synchronised as new chapters are completed.

The manual is written in LaTeX format and my preference is to receive translations with all the LaTeX commands contained in the French version embedded in your translation.  Then all I need do is process your pull requests to my fork. 

 On the other hand, the most urgent need at this stage is for usable translations of the French to the closest possible English translation.  

Even if you are not prepared to deal with the many LaTeX commands scattered throughout the text or don't want to use Git or run the `make` process I will be happy to take a well written plain English text and combine that with the LaTeX commands myself if necessary.  Contributions from competent linguists, particularly with a little understanding of accountancy, will be welcome in any form.  Contributions in the form of corrections and testing of the already translated chapters are also welcome.  I will describe in more detail how each form of contribution is best produced and submitted below.

## Communication
The **most important first step** is to ask Jean-Luc Duflot (<jl.duflot@laposte.net>) to subscribe you to the grisbi-documentation list so you are in touch with me and the rest of the documentation contributors. Please allow Jean-Luc a few days to respond as this is a managed list; there is no automatic subscription option set.  

This is a low volume mailing list so you will not be overwhelmed with messages.  When you join this list then out of courtesy to the rest of the developers (who are mostly French speakers) please communicate any general comments to this list in French.  If your message is directed only at the mechanics of the English translation then of course communicate in English but make sure the words `English Translation` appear somewhere in your subject heading so that French manual contributors can choose not to read what you posted.
## How to contribute
### Contributing plain text translations
If you do not want to bother with LaTeX formatting then simply provide us with a translation from the text copied from the French manual and we will add the  LaTeX commands to your text.  Probably the simplest way to get a copy of the French Manual as a plain text file is to go to  
<https://sourceforge.net/projects/grisbi/files/Documentation/manual_1.0/>  
and download `grisbi-manuel-html-1.0.tar.gz`.  Once you unzip this archive just open it in your web browser then save the page as a text file and use that as a base for creating your English Translation. Typically you will find the option to save a page that you are browsing as a text file by right clicking somewhere in the page that you are browsing, then selecting `save page as..`. When you have completed your translation then just attach your translation as a text file and send it to the grisbi-documentation mailing list.

Alternatively if you are happy to translate the full French .tex file into English, continue as follows:  

### Contributing fully tested LaTeX chapters via Github
You will first have to install the necessary tools and then clone your own copy of the Manual.  You will also need to create your own free Github account and upload your own sub fork there in order to submit your pull requests via Github.  You can then create, build and review your own translated chapters on your local machine.  Then when all is finished submit your new chapters as pull requests to my fork.  The following description is aimed at Linux operating system users.
#### Forking your own copy of the Grisbi manual
You will need to install Git and the LaTeX tools on your machine.  You will find Git in your Linux distribution repository.  See the files  
`/grisbi-documentation/installation_extensions_Latex.txt` and  
`/grisbi-documentation/manual_compilation_en.txt`  
for help with the installation of LaTeX and the necessary extensions that the Grisbi Manual will need.

Then while logged in to your Github account, go to  
<https://github.com/doubledodge/grisbi-documentation>  
and click the *Fork* button.  You will now have your own fork of the manaul source.
Now clone your fork from the command line on your local machine with

        git clone https://github.com/YourGitAccount/grisbi-documentation

#### Working with the Grisbi LaTeX structure
To create a new chapter in the English version of the manual copy your chosen chapter's French .tex file from the subfolder `/home/YourOwnDirectoryStructure/grisbi-documentation/src/1.0/fr` to `/home/YourOwnDirectoryStructure/grisbi-documentation/src/1.0/en` and add -en to the end of the file name.  Replace the existing dummy file of the same name with your new file (the existing short files that have the names ending in -en were just created as a temporary fix so the full manual generation make file runs without errors).  Take care not to change any of the LaTeX commands that the copied-from-the-French .tex file contains and carefully replace all the French text with a suitable English translation.  Then test your newly edited file by issuing the command

        make English
from `/grisbi-documentation/src/1.0/en` this will generate both the html and pdf versions but with the French Manual images.

While you are testing and polishing your new chapter, instead of waiting for the full 'make' process to run you will find you can generate just the pdf file much faster by entering the alternative command

        make FILE=grisbi-manuel-en pdf_img
Please make sure you have tested your work on your own git clone on your local machine by running the full `make English` process before submission

**Warning** If you use your own LaTeX file viewer instead of running the above `make` commands, you will find that there are many special LaTeX macros that have been defined specially for Grisbi and these will cause processing errors until you define quite a few dummy macros to suppress these. You are strongly advised to stick to the `make` method to check your work unless you are very comfortable working with LaTeX files.

#### Some notes on the Grisbi LaTeX special commands
While many of the special commands are clear in their effect, here are some of the more tricky commands you will come across while performing your translations and some guidance on how to deal with them.

* `\indexword{TextAsAppearsInTheManaul}\index{Index entry}`  
The entry in the field `\indexword{` will need to be translated into English so that the manual reads correctly.  I have for the moment left the `\index{` field in French for now as I will leave the generation of the manual index until all chapters have been translated.

* `\vref{manual cross reference}` and `\label{manual cross reference target}`  
Leave these entries unchanged or the cross references will be broken and may result in LaTeX compilation errors.

* `\menu{Text that references a Grisbi menu entry}`  
 You will need to refer to the running Grisbi program to see how the user interface has been translated to English and replace the French menu entry accordingly.
 
* `\vspacepdf{5mm}`  
 These commands have been retained to keep a uniform layout consistent with the orginal French manual
 
* `\og emphasised text \fg{}`  
 This pair of commands have been kept wherever they appear although I am not clear on their effect at this stage
 
* ` \gls{Glossary Entry}`  
 If may need to edit the text of a Glossary Entry to make the English translation read correctly.  If you do edit a glossary entry then you **must** also make precisely the same edit in the corresponding entry in in the file `grisbi-manuel-glossary-en.tex` .  If you forget then the whole LaTeX compilation will fail.  
 
 As a general rule, rerun the `make` process frequently to narrow down the cause of LaTeX compilation failures.  Even an accidentally deleted curly brace can cause some difficult to track down LaTeX compilation failures.  It follows that the fewer edits you do between LaTeX compiles the easier such silly errors are to narrow down and fix.

#### Creating your pull request
You may find that my own fork has moved on a version or two since you started work on your own chapter.  You first need to bring your local copy of the manual up to date with my latest changes by issuing the command

        git rebase upstream/master
now update your local copy of your Grisbi manual project to your own Github fork with

        git push -f

Now on your Github web page click the *create pull request* button and this will alert me to your new chapter which I will then merge with my fork ready to submit to the upstream master version.
