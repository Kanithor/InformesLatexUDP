% udparticle.cls
% Article for the UDP documents
% Adin Ramirez adin.ramirez (at) mail.udp.cl
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{udparticle} [2013/09/27 v0.01 Article of the UDP]


% --- Class structure: declaration of options part
% ---
% This class extends the article class
% Read all the documentclass options; pass them to article,
% unless the file "<currentoption>.udp" exists, then it is loaded
\DeclareOption*{\InputIfFileExists{\CurrentOption.udp}{}{
%
\PassOptionsToClass{\CurrentOption}{article}}}
% --- Class structure: execution of options part
% ---
\ProcessOptions \relax
% --- Class structure: declaration of options part
% ---
\LoadClass{article}

% Page layout
\RequirePackage[left=2.5cm,right=2.5cm,top=2cm,bottom=2cm]{geometry}

% For using the empty verification
\RequirePackage{etoolbox}

% Headers and footers
\RequirePackage{fancyhdr}
\fancypagestyle{firstpage}{
%
\fancyhf{}
% clear all six fields
\fancyhead[L]{\@myheader}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{followingpage}{
%
\fancyhf{}
% clear all six fields
\fancyhead[L]{\@headertext}
\fancyhead[R]{\thepage}
\renewcommand{\headrulewidth}{0.7pt}
\renewcommand{\footrulewidth}{0pt}
}
\pagestyle{followingpage}
\AtBeginDocument{\thispagestyle{firstpage}}

\let\ps@plain\ps@firstpage% add this because maketitle triggers a \thispagestyle{plain}

%% Definitions and commands

% Contains all the udp logos and other stuff
\RequirePackage{udp}

% Set header text for following pages
\def\@headertext{}
\newcommand{\setheadertext}[1]{\def\@headertext{#1}}
\let\headertext\setheadertext

\def\@myheader{%
\ifdefempty{\@logo}{}{%ifnotempty
\begin{minipage}{\@logosz}
\@logo\\%
\tiny \textbf{\@headertext}
\end{minipage}%
}%ifnotmtarg
}%end \@myheader

% Re-define the title
\def\@maketitle{%
  \newpage
%  \vspace*{-\topskip}      % remove the initial space
  \begingroup\centering    % instead of \begin{center}
  \let \footnote \thanks
  \hrule height \z@        % to avoid the insertion of lineskip glue
    {\LARGE \@title \par}%
    \vskip 1.5em 
    {\large
      \lineskip .5em 
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
%    \vskip 1em 
%    {\large \@date}%
  \par\endgroup            % instead of \end{center}
  \vskip 1.5em             % <--- modify this to adjust the separation
}

% Set the spanish system (ironically, the comments are in english, but.. who cares)
\RequirePackage[spanish,es-lcroman,es-tabla]{babel}
\decimalpoint% changes the coma in the numbers to period
\RequirePackage[utf8]{inputenc}
\RequirePackage{csquotes}