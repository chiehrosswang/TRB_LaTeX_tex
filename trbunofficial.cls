% Transportation Research Board conference paper template
% version 4.0
% 
% David R. Pritchard, http://davidpritchard.org
% Gregory S. Macfarlane, https://gregmacfarlane.github.io/
% C. Ross Wang, https://crosswang.org
%   1.0   - Mar. 2009
%   1.1   - Sep. 2011, fixes for captions
%   2.0   - Mar. 2012, Reorganized title page incl. automatic counters
%   2.1   - Jul. 2015, Automatic total word counter and more formattings
%   2.1.1 - Jan. 2016, Minor modifications and first uploaded to Github
%   2.1.1 - May. 2016, created a lite version for people to use directly on TeX without Sweave options
%   4.0	  - Jul. 2019, updated template to be compatible with Overleaf and ShareLaTeX
%   5.0   - Aug. 2025, updated template to improve auto word counts and authorship population

% Official trb Author Instructions:
% https://trb.secure-platform.com/a/page/TRBPaperReview

% Unofficial TRB LaTeX template:
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trbunofficial}[08/31/2025 TRB LaTeX template update]
\LoadClass[titlepage, oneside, 12pt]{article}

\RequirePackage[tiny, rm, pagestyles]{titlesec}
\RequirePackage{enumitem}
\RequirePackage{ccaption}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{graphicx}
\RequirePackage[T1]{fontenc}
\RequirePackage{newtxtext}  % Times-like text
\RequirePackage{newtxmath}  % Times-like math with bold
\RequirePackage{textcomp}
\RequirePackage[pagewise, mathlines]{lineno}
\RequirePackage{geometry}
\RequirePackage[realmainfile]{currfile} % Get main filename for auto word count
\RequirePackage[sort&compress, numbers]{natbib}
\RequirePackage{xparse}
\RequirePackage{totcount}
\RequirePackage{etoolbox}   % Added for author macro
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{xurl}       % Handle long URLs to break
\urlstyle{same}             % URLs use same font as other text

\DeclareOption{numbered}{%
  \linenumbers%
}
\ProcessOptions\relax

% Vars
%------------------------------------------------------------------------------
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

% EQUATIONS
%------------------------------------------------------------------------------
\setlength{\mathindent}{1in}
% Set spacing before and after equation to be 0
\g@addto@macro\normalsize{%
  \setlength\abovedisplayskip{6pt}
  \setlength\belowdisplayskip{6pt}
  \setlength\abovedisplayshortskip{3pt}
  \setlength\belowdisplayshortskip{3pt}
}

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
\renewcommand{\fnum@figure}{\bfseries FIGURE~\thefigure}
\renewcommand{\fnum@table}{\bfseries TABLE~\thetable}
\captiontitlefont{\bfseries \boldmath}
\captiondelim{\;}


% CITATIONS
%------------------------------------------
% TRB uses an Author (num) citation style. I haven't found a way to make
% LaTeX/Bibtex do this automatically using the standard \cite macro, but
% this modified \trbcite macro does the trick.
\renewcommand{\cite}[1]{(\textit{\citenum{#1}})}
\renewcommand{\citep}[1]{\citeauthor{#1} (\textit{\citenum{#1}})}
\setcitestyle{round}

% Reduce spacing between bibliographic items
\setlength{\bibsep}{0pt plus 0.3ex}


% LINE NUMBERING
%------------------------------------------------------------------------------ 
% Adjust the fond of the line numbering
\renewcommand\linenumberfont{\normalfont\small}


% REFERENCES
% Remove square brackets from the numbering and add indentation to bibliography 
% in the REFERENCES section
\renewcommand\@biblabel[1]{#1.\hspace{0.25in}} 

% COUNTERS
%------------------------------------------------------------------------------ 
% Total word count is calculated as: numberofwords + numberoftable*250

\newread\wcfile     % word count temp file
\newcounter{totalwordcounter}
\newcounter{wordcounter}

% default: 250 number of words per table
\def\@WordsPerTable{250}
\newcommand{\WordsPerTable}[1]{%
	\def\@WordsPerTable{#1}
}

% TODO: there must be a better way to define this to avoid using 0
% Variable to control manual word counting
\def\@TotalWords{0}
\newcommand{\TotalWords}[1]{%
	\def\@TotalWords{#1}
}

% From totcount package
\regtotcounter{table} 	%count tables
% \regtotcounter{figure} 	%count figures

\newcommand{\quickwordcount}[1]{%
	\immediate\write18{texcount -1 -merge -incbib -sum -q -total -template="{SUM}" #1.tex output.bbl | tr -cd '0-9' > #1-wc}%
        \IfFileExists{#1-wc}{%
	   \immediate\openin\wcfile=#1-wc%
            \read\wcfile to \@@localdummy%
    	\immediate\closein\wcfile%
            \write18{rm \wcfile}
    	\setcounter{wordcounter}{\@@localdummy}%
    	\@@localdummy%
        }
}

\newcommand{\totalwordcount}{%
	\setcounter{totalwordcounter}{\value{wordcounter}}%
	\addtocounter{totalwordcounter}{\numexpr\@WordsPerTable*\totvalue{table}}%
	\number\value{totalwordcounter}% Output the number
	\renewcommand{\totalwordcount}{\number\value{totalwordcounter}}
}


% ===== TRB author macro =====
\newif\ifTRB@havecorr \TRB@havecorrfalse 
\newcommand*\TRB@authors{}%
\def\TRB@append#1{\g@addto@macro\TRB@authors{#1}}%

% clickable email if hyperref is loaded; otherwise monospace
\@ifpackageloaded{hyperref}{%
  \newcommand\TRB@email[1]{\href{mailto:#1}{#1}}%
}{%
  \newcommand\TRB@email[1]{\texttt{#1}}%
}

% require a non-empty email; warn (not error) if it lacks '@'
\def\TRB@requireemail#1{%
  \edef\TRB@tmpa{\detokenize{#1}}%
  \ifx\TRB@tmpa\@empty
    \PackageError{trb}{Empty email in \string\TRBauthor}{%
      Use \string\TRBauthor[*]{Name}{Affiliation}{email}[orcid][note].}%
  \fi
  % If xstring is loaded, warn when '@' is missing
  \@ifpackageloaded{xstring}{%
    \IfSubStr{\TRB@tmpa}{\detokenize{@}}{}{%
      \PackageWarning{trb}{Email `#1' has no @; continuing}%
    }%
  }{}%
}

% star mark helpers
\def\TRB@mark@none{}%
\def\TRB@mark@star{\textsuperscript{*}}%

% build one author block
% #1 corr author mark, #2 Name, #3 Affil, #4 email, #5 orcid or \relax
\def\TRB@build@author#1#2#3#4#5{%
  \TRB@requireemail{#4}%
  \TRB@append{%
    \textbf{#2}#1\\%
    #3\\%
    Email:~\TRB@email{#4}%
    \ifx\relax#5\relax\else\\ ORCID:~#5\fi%
    \\[12pt]%
  }%
  % if this author is starred, remember it
  \ifx#1\TRB@mark@star
    \global\TRB@havecorrtrue
    \xdef\TRB@corremail{#4}%
  \fi
}

% parse optional [orcid] AFTER mandatory email (no [note] anymore)
\def\TRB@optA@afterEmail#1#2#3#4{%
  \@ifnextchar[{\TRB@optB@afterEmail{#1}{#2}{#3}{#4}}{\TRB@build@author{#1}{#2}{#3}{#4}\relax}%
}
\def\TRB@optB@afterEmail#1#2#3#4[#5]{%
  \TRB@build@author{#1}{#2}{#3}{#4}{#5}%
}

% \TRBauthor[*]{Name}{Affiliation}{email}[orcid][note]
\def\TRBauthor{\@ifstar{\TRB@author@star}{\TRB@author@nostar}}
\def\TRB@author@nostar#1#2#3{\TRB@optA@afterEmail{\TRB@mark@none}{#1}{#2}{#3}}
\def\TRB@author@star  #1#2#3{\TRB@optA@afterEmail{\TRB@mark@star}{#1}{#2}{#3}}

% install into \author for \maketitle
\newcommand{\TRBsetauthors}{\author{\TRB@authors}}


% TODO: find better way than multiple hfill and break to get numbered empty
% lines. Is it really necessary to have empty lines numbered? Its just the way
% users of word deal with that.
\renewcommand{\maketitle}{%
        \TRBsetauthors
	\thispagestyle{empty}
	\begin{flushleft}
		{\large{\bfseries\@title}}\\
		\hfill\break%
		\hfill\break%
		\@author
		\hfill\break%
		\hfill\break%
            \ifTRB@havecorr \textsuperscript{*}~Corresponding author\\ \fi
		\hfill\break%
		\if\@TotalWords 0
		Word Count: \quickwordcount{\currfilebase}~words $+$ \total{table} table(s) $\times$ \@WordsPerTable\ $=$ \totalwordcount~words\\
		\else
		Word Count: \@TotalWords\ words $+$ \total{table} table(s) $\times$ \@WordsPerTable\ $=$ \the\numexpr\@TotalWords + \totvalue{table}*\@WordsPerTable~words\\
		\fi
		\hfill\break%
		\hfill\break%
		Submission Date: \trbdate
	\end{flushleft}
	\newpage
}


% Set date to be the last time possible anywhere on earth (GMT-12), which is exactly one day behind New Zealand's time zone (GMT+12).
\usepackage{advdate}
\newcommand{\trbdate}{{\AdvanceDate[-1]\today}}
