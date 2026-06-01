# TRB_LaTeX_tex

A LaTeX template for preparing papers for the **Transportation Research Board (TRB) Annual Meeting**. This template offers a pragmatic starting point for authors using LaTeX (and related literate programming tools) while matching TRB submission guidance.

## Usage

1. Copy `trb.bst` and `trbunofficial.cls` into your project directory.
1. Update your preamble in `trb_template.tex` to supplement those already in `trbunofficial.cls`.
2. Run `latexmk`, which automatically recompiles when source files change.
3. If using version control (recommended), commit the template files to your repository.

## Main .tex file name flexibility
The template automatically detects the main TeX file name for word counting.  If you rename your main file, no changes are needed in `trbunofficial.cls`.

This works by including:
```bash
\usepackage[realmainfile]{currfile}
\quickwordcount{\currfilebase}
```

## Automated page count
The title page now includes an automated page count. Starting with the 2027 TRB Annual Meeting cycle, TRB replaced the 7,500-word limit with a 20-page limit for paper submissions.

## Automated submission date
The included `latexmkrc` file ensures the submission date on the title page auto-populates according to TRB’s event clock: https://trb.secure-platform.com/a/page/TRBPaperReview/trbamfaq#due

# Overleaf

This template is also available on Overleaf: https://www.overleaf.com/latex/templates/transportation-research-board-trb-latex-template/jkfndnnkkksw
