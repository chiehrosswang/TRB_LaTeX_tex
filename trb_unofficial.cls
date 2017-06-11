% Official trb manual for authors:
% http://onlinepubs.trb.org/onlinepubs/AM/InfoForAuthors.pdf
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trb}[2017/06/10 TRB latex template]

\LoadClass[titlepage, oneside, letterpage, 12pt]{article}


\RequirePackage[tiny, rm]{titlesec}
\RequirePackage{enumitem}
\RequirePackage{ccaption}
\RequirePackage{amsmath}

% Times for text and math
\RequirePackage{mathptmx}

% Some pdf conversion tricks? Unsure.
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}

\RequirePackage[pagewise]{lineno}

\RequirePackage{geometry}


% TODO: add option to specify draft version for review
\DeclareOption{draft}{%
  \pagewiselinenumbers%
}
\ProcessOptions\relax

% Page layout
%------------------------------------------------------------------------------ 
\geometry{textwidth=6.5in, textheight=9.0in}
\geometry{top=1in, left=1in}
\geometry{headheight=0.3in, headsep=0.2in}


% Text formatting
%------------------------------------------------------------------------------ 
\setlength{\parindent}{0.5in}


% Header
%------------------------------------------------------------------------------
\newpagestyle{main}{
\sethead{\@author}{}{\thepage}
}
% TODO: this call should probably go to \maketitle
\pagestyle{main}

% HEADINGS
%------------------------------------------------------------------------------
% Line spacing: 12pt before section titles
\renewcommand*{\refname}{\uppercase{References}}
\titleformat{\section}{\bfseries}{}{0pt}{\uppercase}
\titlespacing*{\section}{0pt}{12pt}{*0}
\titleformat{\subsection}{\bfseries}{}{0pt}{}
\titlespacing*{\subsection}{0pt}{12pt}{*0}
\titleformat{\subsubsection}{\itshape}{}{0pt}{}
\titlespacing*{\subsubsection}{0pt}{12pt}{*0}

% LISTS
%------------------------------------------------------------------------------ 
% Adjust lists a little. Not quite perfectly fitting TRB style, but vaguely
% close at least.
\setlist[1]{labelindent=0.5in,leftmargin=*}
\setlist[2]{labelindent=0in,leftmargin=*}
\setlist{nosep} % eliminate extra verticle spacings between items

% CAPTIONS
%------------------------------------------------------------------------------ 
% Get the captions right. Authors must still be careful to use "Title Case"
% for table captions, and "Sentence case." for figure captions.
\makeatletter
\renewcommand{\fnum@figure}{\textbf{FIGURE~\thefigure} }
\renewcommand{\fnum@table}{\textbf{TABLE~\thetable} }
\makeatother
\captiontitlefont{\bfseries \boldmath}
\captiondelim{\;}
%\precaption{\boldmath}


% CITATIONS
%------------------------------------------
% TRB uses an Author (num) citation style. I haven't found a way to make
% LaTeX/Bibtex do this automatically using the standard \cite macro, but
% this modified \trbcite macro does the trick.

% TODO: sort&compress option?
\RequirePackage[sort&compress, numbers]{natbib}
\renewcommand{\cite}[1]{({\it \citenum{#1}})}
\newcommand{\trbcite}[1]{\citeauthor{#1} ({\it \citenum{#1}})}
\setcitestyle{round}

% Reduce spacing between bibliographic items
\setlength{\bibsep}{0pt plus 0.3ex}


% LINE NUMBERING
%------------------------------------------------------------------------------ 
% Add line numbers
\renewcommand\linenumberfont{\normalfont\small}


% COUNTERS
%------------------------------------------
% TRB requires the total number of words, figures, and tables to be displayed on
% the title page. This is possible under the totcount and the xparse packages on CTAN.
%
% Note that a total word count is added in V 2.1 to print a single value that is 
% calculated as: numberofwords + numberoffigures*250 + numberoftable*250

\newread\somefile
\RequirePackage{xparse}

% Total world count solution from Tex.SX: http://tex.stackexchange.com/questions/255940/print-a-total-word-count-that-sums-up-the-number-of-words-tables-and-figures
\newcounter{totalwordcounter}
\newcounter{wordcounter}
\makeatletter

\NewDocumentCommand{\wordcount}{s}{%
  \immediate\write18{texcount -sum -1 \jobname.tex > count.txt}%
  \immediate\openin\somefile=count.txt%
  \read\somefile to \@@localdummy%
  \immediate\closein\somefile%
  \setcounter{wordcounter}{\@@localdummy}%
  \IfBooleanF{#1}{%
  \@@localdummy%   print only if not starred version
  }%
}
\makeatother

\RequirePackage{totcount}
	\regtotcounter{table} 	%count tables
	\regtotcounter{figure} 	%count figures

\newcommand{\wordfigure}{250} % number of words per figure
\newcommand{\wordtable}{250} % number of words per table

\newcommand{\totalwordcount}{%
  \wordcount*% The star allows just getting the number, not printing it
  \setcounter{totalwordcounter}{\value{wordcounter}}%
  \addtocounter{totalwordcounter}{\numexpr\wordfigure*\totvalue{figure}}%
  \addtocounter{totalwordcounter}{\numexpr\wordtable*\totvalue{table}} % 
  \number\value{totalwordcounter}% Output the number
  \renewcommand{\totalwordcount}{\number\value{totalwordcounter}}% Prevent the call again, otherwise the figure/table counter would be added again. 
}
