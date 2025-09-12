# TRB_LaTeX_tex

A LaTeX template for preparing papers for the **Transportation Research Board (TRB) Annual Meeting**.

This is a lightweight version of the earlier [TRB LaTeX + R/Sweave template](https://github.com/chiehrosswang/TRB_LaTeX_rnw).  
- The previous version was built for workflows combining R, Sweave, and LaTeX.  
- This version is designed for those who need a **straightforward LaTeX-only template** for TRB papers.

The template uses external shell commands for the word count feature (via `texcount`). You must compile with the `-shell-escape` option. For example:

```bash
latexmk trb_template.tex -pdf -pvc -shell-escape
```

Note: `texcount` requires Perl. Install a Perl interpreter such as [ActivePerl](http://www.activestate.com/activeperl/downloads).

## Usage

1. Copy `trb.bst` and `trbunofficial.cls` into your project directory.
1. Update your preamble in `trb_template.tex` to supplement those already in `trbunofficial.cls`.
1. Run `latexmk` with the `-shell-escape` option (see above). `latexmk` automatically recompiles when source files change.
1. If using version control (recommended), commit the template files to your repository.


## Troubleshooting & features
### Enable shell-escape in TeXstudio
If you are using TeXstudio, enable ``-shell-escape``:

1. Go to Options → Configure TeXstudio → Commands → pdflatex
1. Update the command to:
```bash
pdflatex.exe -synctex=1 -interaction=nonstopmode -shell-escape %.tex
```

## Main .tex file name flexibility
The template automatically detects the main TeX file name for word counting.  If you rename your main file, no changes are needed in `trbunofficial.cls`.

This works by including:
```bash
\usepackage[realmainfile]{currfile}
\quickwordcount{\currfilebase}
```

## Word count rules

The total word count includes:
* Title page text (except the footnote)
* Paper body
* References

Excluded:
* Title page footnote
* Text inside tables (each table is counted as 250 words, regardless of content)

See [TRB’s guidelines](https://trb.secure-platform.com/a/page/TRBPaperReview)


## Automated submission date
The included `latexmkrc` file ensures the submission date on the title page auto-populates according to TRB’s event clock: https://trb.secure-platform.com/a/page/TRBPaperReview/trbamfaq#due

# Overleaf

This template is also available on Overleaf: https://www.overleaf.com/latex/templates/transportation-research-board-trb-latex-template/jkfndnnkkksw
