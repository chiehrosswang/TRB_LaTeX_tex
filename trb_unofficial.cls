% Transportation Research Board conference paper template
% version 2.1.1
% 
% David R. Pritchard, http://davidpritchard.org
%   1.0   - Mar. 2009
%   1.1   - Sep. 2011, fixes for captions
%   2.0   - Mar. 2012, Reorganized title page incl. automatic counters
%   2.1   - Jul. 2015, Automatic total word counter and more formattings
%   2.1.1 - Jan. 2016, Minor modifications and first uploaded to Github
%   2.1.1 - May. 2016, created a lite version for people to use directly on TeX without Sweave options

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

% TODO: this interferes with draft from article class. Change to some other
% option
\DeclareOption{draft}{%
  \pagewiselinenumbers%
}
\ProcessOptions\relax

% Vars
%------------------------------------------------------------------------------
\def\@allAuthors{Author}
\newcommand{\allAuthors}[1]{
  \def\@allAuthors{#1}
}

\def\@AuthorHeaders{Name1, Name2 and Name3}
\newcommand{\AuthorHeaders}[1]{
  \def\@AuthorHeaders{#1}
}


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
\sethead{\@AuthorHeaders}{}{\thepage}
}
% TODO: this call should probably go to \maketitle or \AtBeginingOfDocument
% latex hook
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
\renewcommand{\fnum@figure}{\textbf{FIGURE~\thefigure} }
\renewcommand{\fnum@table}{\textbf{TABLE~\thetable} }
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
\renewcommand{\cite}[1]{(\textit{\citenum{#1}})}
\newcommand{\trbcite}[1]{\citeauthor{#1} (\textit{\citenum{#1}})}
\setcitestyle{round}

% Reduce spacing between bibliographic items
\setlength{\bibsep}{0pt plus 0.3ex}


% LINE NUMBERING
%------------------------------------------------------------------------------ 
% Add line numbers
\renewcommand\linenumberfont{\normalfont\small}

% COUNTERS
%------------------------------------------
% TRB requires the total number of words, figures, and tables to be displayed
% on the title page. This is possible under the totcount and the xparse
% packages on CTAN.
%
% Note that a total word count is added in V 2.1 to print a single value that
% is calculated as: numberofwords + numberoffigures*250 + numberoftable*250
\newread\somefile
\RequirePackage{xparse}

% Total world count solution from Tex.SX:
% https://tex.stackexchange.com/q/255940
\newcounter{totalwordcounter}
\newcounter{wordcounter}


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
  % Prevent the call again, otherwise the figure/table counter would be added
  % again.
  \renewcommand{\totalwordcount}{\number\value{totalwordcounter}}
}

% TODO: find better way than multiple hfill and break to get numbered empty
% lines
\renewcommand{\maketitle}{%
  \begin{flushleft}
    {\MakeUppercase{\bfseries\@title}}\\
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \@author\\
    \hfill\break%
    \hfill\break%
    % \totalcount (need to have Perl interpreter [e.g. ActivePerl] and enable
    % shell escape in pdfLaTeX, see some examples below)
    % http://www.activestate.com/activeperl/downloads
    % http://stackoverflow.com/questions/3252957/how-to-execute-shell-script-from-latex
    % http://tex.stackexchange.com/questions/233511/inkscape-and-shell-escape-with-texstudio
    Word Count: \wordcount words + \total{figure} figure(s) + \total{table} table(s) = \totalwordcount~words\\
    % TODO: add if statament and variable \@totalwords to allow manual entry of
    % the number of words.
    %
    % Command out the above line and manually fill in counts using the line
    % below if you could not get the autocount work.
    % Word Count: xxxx words + \total{figure} figure(s) + \total{table} table(s) = xxxx~words\\
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
    Submission Date: \today
  \end{flushleft}
\newpage
}
