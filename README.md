# TRB_LaTeX_tex

A LaTeX template for Transportation Research Board Annual Meeting papers.

This is a lighter version of the former TRB LaTeX
[template](https://github.com/chiehrosswang/TRB_LaTeX_rnw). The previous
version was built primarily for people using R, Sweave, and LaTeX. Therefore,
this version is created for people who need a straight-forward LaTeX template
for TRB papers.

More instruction and details about the project can be found inside the
``trb_template.tex``. The document uses external shell commands hence it needs
to be compiled with ``--shell-escape`` option. This is necessary for word count
feature which uses ``texcount`` program. For example for continuous compilation
use:

    latexmk trb_template.tex -pdf -pvc -shell-escape

For one shot compilation use:

    latexmk trb_template.tex --shell-escape -pdf -f -interaction=nonstopmode

Perl is necessary for ``texcount`` to work and needs a Perl interpreter e.g. [ActivePerl](http://www.activestate.com/activeperl/downloads).

# Troubleshooting
Using ``--shell-escape`` in TexStudio ([original source](http://tex.stackexchange.com/questions/233511/inkscape-and-shell-escape-with-texstudio)):

Go to ``Options->Configure texstudio``. Click on ``Commands``. Add ``-shell-escape`` flag to ``pdflatex``:

    pdflatex.exe -synctex=1 -interaction=nonstopmode -shell-escape %.tex
