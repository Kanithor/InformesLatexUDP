\def\fileversion{1.0}
\def\filedate{2014/05/02}

\typeout{Package: `udpamc (udp automultiplechoice)' \fileversion\space <\filedate>}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{udpamc}[\filedate\space\fileversion]

% helper macros (for more automation)
\newcommand\batchPassOptionsToClass[2]
{%
  \edef\@tempa{#1} % option list
  \@for\@tempb:=\@tempa\do{
    \DeclareOption{\@tempb}{\PassOptionsToClass{\CurrentOption}{#2}}
  }
}

\newcommand\batchPassOptionsToPackage[2]
{%
  \edef\@tempa{#1}% option list
  \@for\@tempb:=\@tempa\do{%
    \DeclareOption{\@tempb}{\PassOptionsToPackage{\CurrentOption}{#2}}%
  }%
}

% declare all options that should be passed to article
\batchPassOptionsToClass
  {a4paper,legalpaper} % list all options that should be passed to article here
  {article}

% pass all other options to the automultiplechoice package
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{automultiplechoice}}
% (or use \batchPassOptionsToPackage, if need to pass some options to other packages)

% process options (only once in your class file)
\ProcessOptions\relax

\LoadClass{article}
\RequirePackage[box,lang=ES]{automultiplechoice}

% for patching
\RequirePackage{etoolbox}

% for logos
\RequirePackage{udp}
\setlogo{EITFI}

% Set the spanish system (ironically, the comments are in english, but.. who cares)
\RequirePackage[spanish,es-lcroman,es-tabla]{babel}
\decimalpoint% changes the coma in the numbers to period
\RequirePackage[utf8]{inputenc}
\RequirePackage{csquotes}

% for using square and blacksquare in instructions
\RequirePackage{amssymb}

% My variables for holding information
\def\@instructions{}
\newcommand{\instructions}[1]{\def\@instructions{#1}}

\def\@rightheader{}
\def\@leftheader{}
\newcommand{\rightheader}[1]{\def\@rightheader{#1}}
\newcommand{\leftheader}[1]{\def\@leftheader{#1}}

% depracated (message)
\newcommand{\coursecode}[1]{\PackageWarning{udpamc}{\noexpand\coursecode is deprecated, prefer \noexpand\leftheader or \noexpand\rightheader commands}\def\@rightheader{#1}}
\newcommand{\testname}[1]{\PackageWarning{udpamc}{\\testname is deprecated, prefer \\leftheader or \\rightheader commands}\def\@leftheader{#1}}

% patch the definition of NAC in the spanish toolbox
\AMCtext{none}{Ninguna de estas respuestas es correcta.}
\def\nac{\AMC@loc@none}

% patch the question beginning (question sheet)
\def\AMCbeginQuestion#1#2{\par\noindent{\bf #1.} #2}
% patch the question beginning (form answer)
\def\AMCformQuestion#1{\vspace{\AMCformVSpace}\par{\bf Pregunta \makebox[1.5em][l]{#1:}}}

% Sets the vertical space between answer and question
\AMCinterBrep=0ex%space between answers
\AMCinterBquest=3ex% space after question

% Sets the new aspect for the students code 
\AMCcodeHspace=.2em
\AMCcodeVspace=.2em
\AMCcodeBoxSep=.1em

% creates the header for the automultichoice
\newcommand{\makename}{%
  \fancyhead[C]{\begin{minipage}{0.3\textwidth}\getlogo\end{minipage}\hspace{0.2\textwidth} \begin{minipage}{0.3\textwidth}\AMCIDBoxesABC\end{minipage}}%
  % código del curso
  \def\@test@{\@rightheader\@leftheader}
  \def\@myhead{%
  \ifdefempty{\@test@}{}{% at least one is not empty
    \noindent{\bf \@leftheader \hfill \@rightheader}%
  }
  \vspace{10pt}\\%<- this enter is needed
  \ifdefempty{\@instructions}{}{\noindent\textbf{Instrucciones.} \@instructions}
  \vspace{10pt}\\%<- this enter is needed
  % identificación
  {\setlength{\parindent}{0pt}\hspace*{\fill}\AMCcode{rut}{8}\hspace*{\fill}
  \begin{minipage}[b]{6.5cm}
  $\longleftarrow{}$ Marque su RUT sin c\'odigo verificador (el n\'umero despu\'es del gui\'on), y escriba sus nombres y apellidos abajo.
  \vspace{3ex}
  \hfill\namefield{\fbox{    
      \begin{minipage}{.9\linewidth}
        Nombre(s) y apellido(s):\\\\
        \vspace*{.5cm}\dotfill\\
        \vspace*{.5cm}\dotfill
        \vspace*{1mm}
      \end{minipage}
    }}\hfill\vspace{1ex}\end{minipage}\hspace*{\fill}
  }
  \vspace{10pt}}
  % setup depending number of columns
  \if@twocolumn
    \twocolumn[\@myhead]
  \else
    \@myhead
  \fi
}

% Header with instructions alone
\newcommand{\makeinstructions}{%
  \fancyhead[C]{\begin{minipage}{0.3\textwidth}\getlogo\end{minipage}\hspace{0.2\textwidth} \begin{minipage}{0.3\textwidth}\AMCIDBoxesABC\end{minipage}}%
  % código del curso
  \def\@test@{\@rightheader\@leftheader}
  \def\@myhead{%
  \ifdefempty{\@test@}{}{% at least one is not empty
    \noindent{\bf \@leftheader \hfill \@rightheader}%
  }
  \vspace{10pt}\\%<- this enter is needed
  \ifdefempty{\@instructions}{}{\noindent\textbf{Instrucciones.} \@instructions}
  \vspace{10pt}\\}%<- this enter is needed
  % setup depending number of columns
  \if@twocolumn
    \twocolumn[\@myhead]
  \else
    \@myhead
  \fi
}

% patch the onecopy to reset automatically figures and tables
\let\oldonecopy\onecopy
\renewcommand{\onecopy}[2]{\oldonecopy{#1}{%
  % reset
  \setcounter{figure}{0}
  \setcounter{table}{0}
  % content
  #2%
}}

% patch for two column answers
% patch multicol answers
\RequirePackage{multicol}
\def\twocolanswers{%
  \BeforeBeginEnvironment{choices}{\begin{multicols}{2}\AMCBoxedAnswers}%
  \AfterEndEnvironment{choices}{\end{multicols}}%
}

% patch ~ in AMC, so when using spanish it doesn't break
\patchcmd{\AMCopen@lines}{~ }%<- this space is needed
{\hspace*{0pt}}
{}{}

% Add functionality to hold boxes
% http://tex.stackexchange.com/q/195005/7561
% Mi código para generar cajas para código automaticamente
\newcounter{myboxcounter}
\setcounter{myboxcounter}{0}
\newenvironment{specialbox}[1][]{%
  \ifstrempty{#1}{%
    \addtocounter{myboxcounter}{1}%
    \expandafter\newsavebox\csname foobox\roman{myboxcounter}\endcsname%
    \global\expandafter\setbox\csname foobox\roman{myboxcounter}\endcsname\hbox\bgroup\color@setgroup\ignorespaces%
  }{%
    \expandafter\newsavebox\csname foobox#1\endcsname%
    \global\expandafter\setbox\csname foobox#1\endcsname\hbox\bgroup\color@setgroup\ignorespaces%
  }
}{%
  \color@endgroup\egroup
}

\newcommand{\insertbox}[1][]{%\stepcounter{myboxcounter}%
  \ifstrempty{#1}%
  {\expandafter\usebox\csname foobox\roman{myboxcounter}\endcsname}%
  {\expandafter\usebox\csname foobox#1\endcsname}%
}