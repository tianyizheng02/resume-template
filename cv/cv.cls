\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{cv}

\ProvidesClass{\thispackage}[2026/09/28 Tianyi and Alejandro's CV document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{adjustbox}
\RequirePackage[maxbibnames=99, sorting=ddnt]{biblatex}
\RequirePackage[inline]{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{lastpage}
\RequirePackage{microtype}
\RequirePackage{titlesec}
\RequirePackage{xcolor}
\RequirePackage{xurl}   % Allow line breaks in bibliography URLs, must place after biblatex
\RequirePackage{hyperref}




% Styling ======================================================================

% Only color URLs, all other links should match text color
\hypersetup{
    hidelinks,
    colorlinks=true,
    allcolors=.,
    urlcolor=blue,
}

\pagestyle{fancy}
\fancyhfoffset{0pt}
\fancyhead{}
\renewcommand{\headrule}{}
\fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
\fancypagestyle{plain}{}    % Redefine plain to be same as fancy

\setcounter{secnumdepth}{0}

\titleformat{\section}{\Large\bfseries}{}{}{}[\titlerule]
\titlespacing{\section}{0em}{1.5em}{1em}

\g@addto@macro\bfseries{\boldmath}  % Make math bold in bold text

\setlist{nosep}
\setlist[itemize]{leftmargin=1.5em}     % Indentation for itemize bullet points
\setlist[enumerate]{leftmargin=1.5em}   % Indentation for enumerate numbers

\newlength{\itemspace}
\setlength{\itemspace}{2ex}





% Contact Info =================================================================

\newbool{emaildefined}
\NewDocumentCommand{\email}{m}{%
    \gdef\@email{#1}%
    \booltrue{emaildefined}%
}

\newbool{pronounsdefined}
\NewDocumentCommand{\pronouns}{m}{%
    \gdef\@pronouns{#1}%
    \booltrue{pronounsdefined}%
}

\newbool{phonedefined}
\NewDocumentCommand{\phone}{m}{%
    \gdef\@phone{#1}%
    \booltrue{phonedefined}%
}

\newbool{datedefined}
\RenewDocumentCommand{\date}{m}{%
    \gdef\@date{#1}%
    \booltrue{datedefined}%
}

\newbool{homepagedefined}
\NewDocumentCommand{\homepage}{m}{%
    \gdef\@homepage{#1}%
    \booltrue{homepagedefined}%
}

\newbool{addressdefined}
\NewDocumentCommand{\address}{m}{%
    \gdef\@address{%
        \begin{adjustbox}{valign=t, stack=l}
            #1
        \end{adjustbox}
    }
    \booltrue{addressdefined}%
}




% Header =======================================================================

\RenewDocumentCommand{\maketitle}{}{%
    \ifbool{addressdefined}{%
        \begin{center}
            {\Huge\bfseries\@author}
            \ifbool{pronounsdefined}{\LARGE\ (\@pronouns)}{}
        \end{center}

        \@address
    }{%
        \begin{adjustbox}{valign=t, stack=l}
            {\Huge\bfseries\@author}
            \ifbool{pronounsdefined}{\LARGE\ (\@pronouns)}{}
        \end{adjustbox}
    }
    \hfill
    \begin{adjustbox}{valign=t, stack=l}
        \ifbool{emaildefined}{%
            Email: \href{mailto:\@email}{\nolinkurl{\@email}}%
        }{}

        \ifbool{phonedefined}{%
            Phone: \@phone%
        }{}

        \ifbool{homepagedefined}{%
            Homepage: \href{https://\@homepage}{\nolinkurl{\@homepage}}%
        }{}

        \ifbool{datedefined}{%
            Updated: \@date%
        }{}
    \end{adjustbox}
    \medskip
    % Unset commands, copied from the definition of \maketitle from the article document class
    % https://tex.stackexchange.com/a/452985/270231
    \let\thanks\relax
    \let\maketitle\relax
    \let\@maketitle\relax
    \let\@thanks\@empty
    \let\@author\@empty
    \let\@date\@empty
    \let\@title\@empty
    \let\title\relax
    \let\author\relax
    \let\date\relax
    \let\and\relax
}




% Body =========================================================================

\NewDocumentCommand{\education}{mmmmm}{%
    \noindent
    \begin{minipage}{\textwidth}
        \textbf{#1}\IfBlankF{#4}{\hfill #4}%
        \IfBlankF{#2}{\par}\IfBlankF{#3}{\par}%
        \IfBlankF{#2}{\textit{#2}}\IfBlankF{#3}{\hfill #3}%
        \IfBlankF{#5}{\par #5}
    \end{minipage}
    \addvspace{\itemspace}%
}

% The "entry" command is basically the same as the "education" command, but I kept them separate so that I may choose to style them differently in the future
\NewDocumentCommand{\experience}{mmmmm}{%
    \noindent
    \begin{minipage}{\textwidth}
        \textbf{#1}\IfBlankF{#4}{\hfill #4}%
        \IfBlankF{#2}{\par}\IfBlankF{#3}{\par}%
        \IfBlankF{#2}{\textit{#2}}\IfBlankF{#3}{\hfill #3}%
        \IfBlankF{#5}{\par #5}
    \end{minipage}
    \addvspace{\itemspace}%
}

% The "entry" command is basically the same as the "experience" command, but I kept them separate so that I may choose to style them differently in the future
\NewDocumentCommand{\entry}{mmmmm}{%
    \noindent
    \begin{minipage}{\textwidth}
        \textbf{#1}\IfBlankF{#4}{\hfill #4}%
        \IfBlankF{#2}{\par}\IfBlankF{#3}{\par}%
        \IfBlankF{#2}{\textit{#2}}\IfBlankF{#3}{\hfill #3}%
        \IfBlankF{#5}{\par #5}
    \end{minipage}
    \addvspace{\itemspace}
}




% Publications =================================================================

% Bold author name in publications: https://tex.stackexchange.com/a/327046
\DeclareDocumentCommand{\boldbibname}{mmm}{%
    \def\@firstname{#1}%
    \def\@firstinit{#2}%
    \def\@lastname{#3}
}

\RenewDocumentCommand{\mkbibnamegiven}{m}{%
    \ifboolexpr{
        (
            test {\ifdefequal{\@firstname}{\namepartgiven}}
            or test {\ifdefequal{\@firstinit}{\namepartgiven}}
        )
        and test {\ifdefequal{\@lastname}{\namepartfamily}}
    }{\mkbibbold{#1}}{#1}%
}

\RenewDocumentCommand{\mkbibnamefamily}{m}{%
    \ifboolexpr{
        (
            test {\ifdefequal{\@firstname}{\namepartgiven}}
            or test {\ifdefequal{\@firstinit}{\namepartgiven}}
        )
        and test {\ifdefequal{\@lastname}{\namepartfamily}}
    }{\mkbibbold{#1}}{#1}%
}

% Controls spacing between entries and labels ([1], etc), set to 2\labelsep by default
\setlength{\biblabelsep}{\labelsep}
