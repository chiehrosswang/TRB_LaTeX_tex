% ======================================================================
% Transportation Research Board (TRB) conference paper template
% Class: trbunofficial.cls
% Version: 5.0  (2025-08-31)
%
% Authors/Maintainers
%   David R. Pritchard   — http://davidpritchard.org
%   Gregory S. Macfarlane — https://gregmacfarlane.github.io/
%   C. Ross Wang          — https://crosswang.org
%
% Changelog (selected)
%   1.0   — Mar 2009: Initial release
%   1.1   — Sep 2011: Fixes for captions
%   2.0   — Mar 2012: Reorganized title page incl. automatic counters
%   2.1   — Jul 2015: Automatic total word counter and more formatting
%   2.1.1 — Jan 2016: Minor modifications; first GitHub upload
%   2.1.1 — May 2016: “Lite” version for TeX (no Sweave)
%   4.0   — Jul 2019: Overleaf / ShareLaTeX compatibility
%   5.0   — Aug 2025: Improved auto word counts and authorship population
%
% Official TRB Author Instructions:
%   https://trb.secure-platform.com/a/page/TRBPaperReview
% ======================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trbunofficial2}[2025/08/31 TRB LaTeX template update]
\LoadClass[titlepage,oneside,12pt]{article}

% ----------------------------------------------------------------------
% Packages
% ----------------------------------------------------------------------
\RequirePackage[tiny,rm,pagestyles]{titlesec}
\RequirePackage{enumitem}
\RequirePackage{ccaption}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{graphicx}
\RequirePackage[T1]{fontenc}
\RequirePackage{newtxtext}   % Times-like text
\RequirePackage{newtxmath}   % Times-like math with bold
\RequirePackage{textcomp}
\RequirePackage[pagewise,mathlines]{lineno}
\RequirePackage{geometry}
\RequirePackage[realmainfile]{currfile} % main filename for texcount
\RequirePackage[sort&compress,numbers]{natbib}
\RequirePackage{xparse}
\RequirePackage{totcount}
\RequirePackage{etoolbox}    % utilities (author macros)
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{xurl}        % allow URL line breaks with hyperref
\urlstyle{same}

% ----------------------------------------------------------------------
% Class options
%   numbered — turn on line numbers
% ----------------------------------------------------------------------
\DeclareOption{numbered}{\linenumbers}
\ProcessOptions\relax

% ----------------------------------------------------------------------
% Page geometry and basic formatting
% ----------------------------------------------------------------------
\geometry{textwidth=6.5in,textheight=9.0in}
\geometry{top=1in,left=1in}
\geometry{headheight=0.3in,headsep=0.2in}

\setlength{\parindent}{0.5in}
\setlength{\mathindent}{0pt}

% Header (author short names left, page number right)
\def\@AuthorHeaders{}%
\newcommand{\AuthorHeaders}[1]{\def\@AuthorHeaders{#1}}
\newpagestyle{main}{\sethead{\@AuthorHeaders}{}{\thepage}}
\pagestyle{main}

% ----------------------------------------------------------------------
% Headings
% ----------------------------------------------------------------------
\renewcommand*{\refname}{\uppercase{References}}
\titleformat{\section}{\bfseries}{}{0pt}{\uppercase}
\titlespacing*{\section}{0pt}{12pt}{*0}
\titleformat{\subsection}{\bfseries}{}{0pt}{}
\titlespacing*{\subsection}{0pt}{12pt}{*0}
\titleformat{\subsubsection}{\itshape}{}{0pt}{}
\titlespacing*{\subsubsection}{0pt}{12pt}{*0}

% ----------------------------------------------------------------------
% Equations (left-aligned; compact display skips)
% ----------------------------------------------------------------------
\setlength{\mathindent}{0in}
\g@addto@macro\normalsize{%
  \setlength\abovedisplayskip{6pt}%
  \setlength\belowdisplayskip{6pt}%
  \setlength\abovedisplayshortskip{3pt}%
  \setlength\belowdisplayshortskip{3pt}%
}

% ----------------------------------------------------------------------
% Lists (compact; margins approximating TRB style)
% ----------------------------------------------------------------------
\setlist[1]{labelindent=0.5in,leftmargin=*}
\setlist[2]{labelindent=0in,leftmargin=*}
\setlist{nosep} % eliminate extra vertical spacing between items

% ----------------------------------------------------------------------
% Captions (FIGURE/TABLE label styles)
% ----------------------------------------------------------------------
\renewcommand{\fnum@figure}{\bfseries FIGURE~\thefigure}
\renewcommand{\fnum@table}{\bfseries TABLE~\thetable}
\captiontitlefont{\bfseries \boldmath}
\captiondelim{\;}

% ----------------------------------------------------------------------
% Citations (author–number style in text)
% ----------------------------------------------------------------------
\renewcommand{\cite}[1]{(\textit{\citenum{#1}})}
\renewcommand{\citep}[1]{\citeauthor{#1} (\textit{\citenum{#1}})}
\setcitestyle{round}

% References list spacing and labels (1. Author...; left-indented label)
\setlength{\bibsep}{0pt plus 0.3ex}
\renewcommand\@biblabel[1]{#1.\hspace{0.25in}}

% Line numbering font
\renewcommand\linenumberfont{\normalfont\small}

% ----------------------------------------------------------------------
% Word counting (texcount) — words + 250 per table (configurable)
% ----------------------------------------------------------------------
\newread\wcfile
\newcounter{totalwordcounter}
\newcounter{wordcounter}

% words-per-table factor (default 250)
\def\@WordsPerTable{250}
\newcommand{\WordsPerTable}[1]{\def\@WordsPerTable{#1}}

% Optional manual override for total words (0 = disabled) 
\def\@TotalWords{0} 
\newcommand{\TotalWords}[1]{\def\@TotalWords{#1}}

% Count total tables via totcount
\regtotcounter{table}

% Run texcount on the main file; stash result in <job>-wc; read it back
\newcommand{\quickwordcount}[1]{%
  \immediate\write18{texcount -1 -merge -incbib -sum -q -total -template="{SUM}" #1.tex output.bbl | tr -cd '0-9' > #1-wc}%
  \IfFileExists{#1-wc}{%
    \immediate\openin\wcfile=#1-wc
    \read\wcfile to \@@localdummy
    \immediate\closein\wcfile
    \write18{rm \wcfile}
    \setcounter{wordcounter}{\@@localdummy}%
    \@@localdummy
  }{}%
}

% Compute and print total word count; then freeze macro to a pure number
\newcommand{\totalwordcount}{%
  \setcounter{totalwordcounter}{\value{wordcounter}}%
  \addtocounter{totalwordcounter}{\numexpr\@WordsPerTable*\totvalue{table}}%
  \number\value{totalwordcounter}%
  \renewcommand{\totalwordcount}{\number\value{totalwordcounter}}%
}

% ----------------------------------------------------------------------
% Author block macros
%   \TRBauthor[*]{Name}{Affiliation}{email}[address][orcid]
%   Star (*) marks the corresponding author.
% ----------------------------------------------------------------------
\newif\ifTRB@havecorr \TRB@havecorrfalse
\newcommand*\TRB@authors{}%
\def\TRB@append#1{\g@addto@macro\TRB@authors{#1}}%

% Clickable email if hyperref is loaded; monospace otherwise
\@ifpackageloaded{hyperref}{%
  \newcommand\TRB@email[1]{\href{mailto:#1}{#1}}%
}{%
  \newcommand\TRB@email[1]{\texttt{#1}}%
}

% Require non-empty email; warn (not error) if it lacks '@' (when xstring loaded)
\def\TRB@requireemail#1{%
  \edef\TRB@tmpa{\detokenize{#1}}%
  \ifx\TRB@tmpa\@empty
    \PackageError{trb}{Empty email in \string\TRBauthor}{%
      Use \string\TRBauthor[*]{Name}{Affiliation}{email}[address][orcid].}%
  \fi
  \@ifpackageloaded{xstring}{%
    \IfSubStr{\TRB@tmpa}{\detokenize{@}}{}{%
      \PackageWarning{trb}{Email `#1' has no @; continuing}%
    }%
  }{}%
}

% Star mark helpers
\def\TRB@mark@none{}%
\def\TRB@mark@star{\textsuperscript{*}}%

% Build one author block
%   #1 corr mark, #2 Name, #3 Affil, #4 email, #5 address|relax, #6 orcid|relax
\def\TRB@build@author#1#2#3#4#5#6{%
  \TRB@requireemail{#4}%
  \TRB@append{%
    \textbf{#2}#1\\%
    #3\\%
    \ifx\relax#5\relax\else #5\\\fi
    Email:~\TRB@email{#4}%
    \ifx\relax#6\relax\else\\ ORCID:~#6\fi
    \\[12pt]%
  }%
  \ifx#1\TRB@mark@star
    \global\TRB@havecorrtrue
    \xdef\TRB@corremail{#4}%
  \fi
}

% Parse optional [address] and [orcid] after mandatory email
\def\TRB@optA@afterEmail#1#2#3#4{%
  \@ifnextchar[{\TRB@optAddr@afterEmail{#1}{#2}{#3}{#4}}%
               {\TRB@build@author{#1}{#2}{#3}{#4}\relax\relax}%
}
\def\TRB@optAddr@afterEmail#1#2#3#4[#5]{%
  \@ifnextchar[{\TRB@optOrcid@afterAddr{#1}{#2}{#3}{#4}{#5}}%
               {\TRB@build@author{#1}{#2}{#3}{#4}{#5}\relax}%
}
\def\TRB@optOrcid@afterAddr#1#2#3#4#5[#6]{%
  \TRB@build@author{#1}{#2}{#3}{#4}{#5}{#6}%
}

% Public author command (starred = corresponding author)
\def\TRBauthor{\@ifstar{\TRB@author@star}{\TRB@author@nostar}}
\def\TRB@author@nostar#1#2#3{\TRB@optA@afterEmail{\TRB@mark@none}{#1}{#2}{#3}}
\def\TRB@author@star  #1#2#3{\TRB@optA@afterEmail{\TRB@mark@star}{#1}{#2}{#3}}

% Install into \author for \maketitle
\newcommand{\TRBsetauthors}{\author{\TRB@authors}}

% ----------------------------------------------------------------------
% Title-page footnotes (disclaimers / copyright)
%   Use \TRBtitlefootnote{<text>} before \maketitle.
% ----------------------------------------------------------------------
\newcommand*\TRB@titlefootnotes{}%
\NewDocumentCommand{\TRBtitlefootnote}{m}{%
  \begingroup
    \renewcommand\thefootnote{}%
    \renewcommand\@makefntext[1]{\parindent=0pt\noindent ##1}%
    \footnotetext[0]{#1}%
  \endgroup
}
\newcommand*\TRB@printTitleFootnotes{%
  \TRB@titlefootnotes
  \gdef\TRB@titlefootnotes{}%
}

% ----------------------------------------------------------------------
% Title page
%   NOTE: The multiple \hfill\break lines insert blank, line-numbered lines
%   to mimic common Word templates. If you do not need blank numbered lines,
%   you may replace them with vertical skips.
% ----------------------------------------------------------------------
\renewcommand{\maketitle}{%
  \TRBsetauthors
  \thispagestyle{empty}
  \begin{flushleft}
    {\large\bfseries\@title}\\
    \hfill\break%
    \hfill\break%
    \@author
    \hfill\break%
    \hfill\break%
    \ifTRB@havecorr \textsuperscript{*}~Corresponding author\\ \fi
    \hfill\break%
    \if\@TotalWords 0
      Word Count:~\quickwordcount{\currfilebase}~words $+$ \total{table} table(s) $\times$ \@WordsPerTable\ $=$ \totalwordcount~words\\
    \else
      Word Count:~\@TotalWords\ words $+$ \total{table} table(s) $\times$ \@WordsPerTable\ $=$ \the\numexpr\@TotalWords + \totvalue{table}*\@WordsPerTable~words\\
    \fi
    \hfill\break%
    \hfill\break%
    Submission Date: \trbdate
  \end{flushleft}
  % Title-page footnotes
  \TRB@printTitleFootnotes
  \newpage
}

% ----------------------------------------------------------------------
% Submission date helper (last timezone on earth: GMT-12)
% ----------------------------------------------------------------------
\usepackage{advdate}
\newcommand{\trbdate}{{\AdvanceDate[-1]\today}}