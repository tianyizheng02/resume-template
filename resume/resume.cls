\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{resume}

\ProvidesClass{\thispackage}[2024/09/10 Tianyi and Alejandro's resume document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{adjustbox}                  % Boxes with adjustable widths
\RequirePackage{anyfontsize}                % Font size for name
\RequirePackage[outline]{contour}           % Contours for links
\RequirePackage[inline]{enumitem}           % List spacing
\RequirePackage[margin=0.5in]{geometry}     % Margins
\RequirePackage{graphicx}                   % Icons
\RequirePackage[hidelinks]{hyperref}        % Links
\let\CheckCommand\providecommand            % Suppress spurious microtype warning: https://tex.stackexchange.com/a/511714
\RequirePackage{microtype}                  % Better typography
\RequirePackage{titlesec}                   % Section headers
\RequirePackage[normalem]{ulem}             % Underlined text
\RequirePackage{xcolor}                     % Colored text



\contourlength{0.075em}             % Contour width for links
\contournumber{256}                 % Countour count (fidelity) for links
\renewcommand{\ULdepth}{0.15em}     % Underline depth for links

% Icons from Tabler icons, https://github.com/tabler/tabler-icons
\graphicspath{{./icons/}}   % Filepath for icons

% Page styling
\pagestyle{empty}
\linespread{1.3}
\setlist{nosep}

\setlist[itemize]{leftmargin=1.5em}     % Indentation for itemize bullet points



\NewDocumentCommand{\name}{m}{\gdef\@name{#1}}
\NewDocumentCommand{\@name}{}{\ClassWarning{\thispackage}{No \noexpand\name provided}}

\newbool{pronounsdefined}
\NewDocumentCommand{\pronouns}{m}{%
    \gdef\@pronouns{#1}%
    \booltrue{pronounsdefined}%
}

\NewDocumentCommand{\email}{m}{\gdef\@email{#1}}
\NewDocumentCommand{\@email}{}{\ClassWarning{\thispackage}{No \noexpand\email provided}}

\NewDocumentCommand{\linkedin}{m}{\gdef\@linkedin{#1}}
\NewDocumentCommand{\@linkedin}{}{\ClassWarning{\thispackage}{No \noexpand\linkedin provided}}

\NewDocumentCommand{\website}{m}{\gdef\@website{#1}}
\NewDocumentCommand{\@website}{}{\ClassWarning{\thispackage}{No \noexpand\website provided}}

\NewDocumentCommand{\github}{m}{\gdef\@github{#1}}
\NewDocumentCommand{\@github}{}{\ClassWarning{\thispackage}{No \noexpand\github provided}}

\newlength{\namesize}
\setlength{\namesize}{28pt}
\NewDocumentCommand{\makeheader}{}{
    \begin{adjustbox}{valign=t}
        \textbf{\fontsize{\namesize}{1.2\namesize}\selectfont\@name}
        \ifbool{pronounsdefined}{\fontsize{0.75\namesize}{0.9\namesize}\selectfont\ (\@pronouns)}{}
    \end{adjustbox}
    \hfill
    \begin{adjustbox}{valign=t}
        \setlength{\tabcolsep}{0em}
        \begin{tabular}{l@{\qquad}l}
            \icon{mail}
            \link[\@email]{mailto:\@email}
            &
            \icon{linkedin}
            \link[\@linkedin]{https://www.linkedin.com/in/\@linkedin}\\

            \icon{browser}
            \link[\@website]{https://\@website}
            &
            \icon{github}
            \link[\@github]{https://github.com/\@github}
        \end{tabular}
    \end{adjustbox}
    \medskip
    % Unset commands, modeled of the definition of \maketitle from the article document class
    % https://tex.stackexchange.com/a/452985/270231
    \let\makeheader\relax
    \let\name\relax
    \let\@name\@empty
    \let\pronouns\relax
    \let\@pronouns\@empty
    \let\email\relax
    \let\@email\@empty
    \let\linkedin\relax
    \let\@linkedin\@empty
    \let\website\relax
    \let\@website\@empty
    \let\github\relax
    \let\@github\@empty
}

% Unset unused commands, copied from the definition of \maketitle from the article document class
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



% Custom section headings
\setcounter{secnumdepth}{0}  % Disable section numbering
\titleformat{\section}{\large}{}{}{}[\titlerule]
\titlespacing{\section}{0em}{0.75em}{0.75em}

% Custom commands
\newcommand{\itemspace}{\medskipamount}
\newcommand{\linespace}{\smallskipamount}
\NewDocumentCommand{\link}{om}{\textcolor{blue}{\uline{\phantom{\IfValueTF{#1}{#1}{#2}}}\llap{\contour{white}{\href{#2}{\IfValueTF{#1}{#1}{#2}}}}}}
\NewDocumentCommand{\icon}{m}{\raisebox{-0.5em}{\includegraphics[height=1.5em]{#1}}}
\NewDocumentCommand{\activity}{mm}{\textbf{#1} \hfill #2\\\addvspace{\linespace}}
\NewDocumentCommand{\dates}{mm}{#1 -- #2}

\NewDocumentCommand{\education}{mmmmmomm}{%
    \textbf{#1}, #2 \hfill #4\\
    \textit{#3}%
    \IfBlankF{#5}{\hfill \textbf{GPA:} #5/\IfValueTF{#6}{#6}{4.0}}%
    \IfBlankF{#7}{\\\textit{#7}}\\
    \IfBlankF{#8}{\nopagebreak#8}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentEnvironment{experience}{mmmm}{
    \textbf{#1}, #2 \hfill #4\\
    \textit{#3}
    \begin{itemize}
}{
    \end{itemize}
    \addvspace{\itemspace}%
}

\NewDocumentEnvironment{project}{mmom}{
    \textbf{#1} (#2) \IfBlankF{#4}{
        \hfill \IfValueT{#3}{\textbf{#3:}} #4
    }
    \begin{itemize}
}{
    \end{itemize}
    \addvspace{\itemspace}%
}

% See enumitem documentation, section 4, inline lists
\newlist{commalist}{description*}{20}
\setlist[commalist]{
    itemjoin={{, }},
    afterlabel={},      % Remove space after non-existent label
    mode=unboxed
}

\NewDocumentEnvironment{skills}{m}{
    \textbf{#1:}
    \begin{commalist}
}{
    \end{commalist}

    \addvspace{\linespace}%
}

\raggedright
