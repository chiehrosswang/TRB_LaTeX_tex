# TRB_LaTeX_tex
A LaTeX template for Transportation Research Board Annual Meeting papers.

This is a light version of the former TRB LaTeX [template](https://github.com/chiehrosswang/TRB_LaTeX_rnw). The previous version was built primarily for people using R, Sweave, and LaTeX. This version is created for people who need a straight-forward LaTeX template for TRB papers.

More instruction and details about the project can be found inside the ``trb_template.tex``. The document uses external shell commands hence it needs to be compiled with ``-shell-escape`` option. This is necessary for word count feature which uses ``texcount`` program. For example:

    latexmk trb_template.tex -pdf -pvc -shell-escape

Perl is necessary for ``texcount`` to work and needs a Perl interpreter e.g. [ActivePerl](http://www.activestate.com/activeperl/downloads).


# Usage
1. Copy the files `trb.bst` and `trbunofficial.cls` into the directory for your document
1. Change the preamble of your document to correspond to the template (`trb_template.tex`)
1. Run `latexmk` to make your document as shown above. Note that `latexmk` watches for changes and recompiles the document automatically.
1. Note also that if you use source control on your document (strongly recommended), you need to check in the template files into the repository as well.


# Troubleshooting
### Shell escape for ``texcount``
Using ``-shell-escape`` in TexStudio ([original source](http://tex.stackexchange.com/questions/233511/inkscape-and-shell-escape-with-texstudio)):

Go to ``Options->Configure texstudio``. Click on ``Commands``. Add ``-shell-escape`` flag to ``pdflatex``:

    pdflatex.exe -synctex=1 -interaction=nonstopmode -shell-escape %.tex

### Main TeX file name no longer matters
The file name of the primary TeX file (e.g., `trb_template.tex`) is automatically used for calculating total words.  If you changed the file name, you will not need to change the corresponding filename in the `trbunofficial.cls` file.  This is enabled by including the `[realmainfile]{currfile}` package and `\quickwordcount{\currfilebase}` command in the `trbunofficial.cls` file.


### Texts counted toward total word count
Note that the current version of this template count all words (e.g., title and authors) except the disclaimer/copyright notice on the title page.  It also counts texts in the references.  This should be consistent with the current TRB guideline available here: https://trb.secure-platform.com/a/page/TRBPaperReview.


# Overleaf
This template has been published on Overleaf, and it can be found here: https://www.overleaf.com/latex/templates/transportation-research-board-trb-latex-template/jkfndnnkkksw
