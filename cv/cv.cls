\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{cv}

\ProvidesClass{\thispackage}[2024/07/08 Tianyi and Alejandro's CV document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{adjustbox}
\RequirePackage[backend=biber, maxbibnames=99, sorting=ddnt]{biblatex}
\RequirePackage[outline]{contour}
\RequirePackage[inline]{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{lastpage}
\let\CheckCommand\providecommand    % Suppress spurious microtype warning: https://tex.stackexchange.com/a/511714
\RequirePackage{microtype}
\RequirePackage{titlesec}
\RequirePackage[normalem]{ulem}
\RequirePackage[hidelinks]{hyperref}

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

\newcommand{\itemspace}{\medskipamount}

% See enumitem documentation, section 4, inline lists
\newlist{commalist}{description*}{20}
\setlist[commalist]{
    itemjoin={{, }},
    afterlabel={},      % Remove space after non-existent label
    mode=unboxed
}

\contourlength{0.075em}             % Contour width for links
\contournumber{256}                 % Countour count (fidelity) for links
\renewcommand{\ULdepth}{0.175em}     % Underline depth for links

\NewDocumentCommand{\link}{om}{\textcolor{blue}{\uline{\phantom{\IfValueTF{#1}{#1}{#2}}}\llap{\contour{white}{\href{#2}{\IfValueTF{#1}{#1}{#2}}}}}}
\NewDocumentCommand{\dates}{mm}{#1 -- #2}

\NewDocumentCommand{\email}{m}{\gdef\@email{#1}}
\NewDocumentCommand{\@email}{}{\ClassWarning{\thispackage}{No \noexpand\email provided}}

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



\newcommand{\separator}{~\textbullet~}
\RenewDocumentCommand{\maketitle}{}{%
    \ifbool{addressdefined}{%
        \begin{center}
            {\Huge\bfseries\@author}
        \end{center}

        \@address
    }{%
        \begin{adjustbox}{valign=t, stack=l}
            {\Huge\bfseries\@author}
        \end{adjustbox}
    }
    \hfill
    \begin{adjustbox}{valign=t, stack=l}
        Email: \link[\@email]{mailto:\@email}

        \ifbool{phonedefined}{%
            Phone: \@phone%
        }{}

        \ifbool{homepagedefined}{%
            Homepage: \link[\@homepage]{https://\@homepage}%
        }{}

        \ifbool{datedefined}{%
            Last Updated: \@date%
        }{}
    \end{adjustbox}
    \bigskip
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

\NewDocumentCommand{\education}{mmmmm}{%
    \textbf{#1} \hfill #4

    \nopagebreak
    \textit{#2} \hfill #3

    \IfBlankF{#5}{\nopagebreak#5}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentCommand{\experience}{mmmmm}{%
    \textbf{#1} \hfill #4

    \nopagebreak
    \textit{#2} \hfill #3

    \IfBlankF{#5}{\nopagebreak#5}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

% The "entry" command is basically the same as the "experience" command, but I kept them separate so that I may choose to style them differently in the future
\NewDocumentCommand{\entry}{mmmmm}{%
    \textbf{#1}\IfBlankF{#4}{\hfill #4}

    \IfBlankF{#2}{\nopagebreak\textit{#2}}\IfBlankF{#3}{\IfBlankT{#2}{\nopagebreak}\hfill #3}

    \IfBlankF{#5}{\nopagebreak#5}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}
}


% Bold author name in publications: https://tex.stackexchange.com/a/327046
\DeclareDocumentCommand{\boldbibname}{mmm}{%
    \def\@firstname{#1}%
    \def\@firstinit{#2}%
    \def\@lastname{#3}
}

\RenewDocumentCommand{\mkbibnamegiven}{m}{%
    \ifboolexpr{
        ( test {\ifdefequal{\@firstname}{\namepartgiven}} or test {\ifdefequal{\@firstinit}{\namepartgiven}} )
        and test {\ifdefequal{\@lastname}{\namepartfamily}}
    }{\mkbibbold{#1}}{#1}%
}

\RenewDocumentCommand{\mkbibnamefamily}{m}{%
    \ifboolexpr{
        ( test {\ifdefequal{\@firstname}{\namepartgiven}} or test {\ifdefequal{\@firstinit}{\namepartgiven}} )
        and test {\ifdefequal{\@lastname}{\namepartfamily}}
    }{\mkbibbold{#1}}{#1}%
}

\raggedright
