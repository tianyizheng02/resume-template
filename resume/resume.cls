\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{resume}

\ProvidesClass{\thispackage}[2026/09/28 Tianyi and Alejandro's resume document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{adjustbox}                  % Boxes with adjustable widths
\RequirePackage{anyfontsize}                % Font size for name
\RequirePackage[inline]{enumitem}           % List spacing
\RequirePackage[margin=0.5in]{geometry}     % Margins
\RequirePackage[
    hidelinks,
    colorlinks=true,
    urlcolor=blue,
]{hyperref}                                 % Links
\RequirePackage{microtype}                  % Better typography
\RequirePackage{tablericons}                % Icons
\RequirePackage{titlesec}                   % Section headers




% Page styling =================================================================

\pagestyle{empty}
\linespread{1.3}
\setlist{nosep}

\setlist[itemize]{leftmargin=1.5em}     % Indentation for itemize bullet points

% Custom section headings
\setcounter{secnumdepth}{0}  % Disable section numbering
\titleformat{\section}{\large}{}{}{}[\titlerule]
\titlespacing{\section}{0em}{0.75em}{0.75em}

\g@addto@macro\bfseries{\boldmath}  % Make math bold in bold text

\raggedright




% Contact Info =================================================================

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




% Header =======================================================================

\newlength{\iconheight}
\setlength{\iconheight}{1.25em}
\newlength{\icondepth}
\setlength{\icondepth}{-\iconheight/4}

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
            % The "\the" expands the length variables into their underlying values
            \tablericon[height={\the\iconheight/\the\icondepth}]{mail}
            \link{\@email}[mailto:\@email]
            &
            \tablericon[height={\the\iconheight/\the\icondepth}]{brand-linkedin}
            \link{\@linkedin}[https://www.linkedin.com/in/\@linkedin]\\

            \tablericon[height={\the\iconheight/\the\icondepth}]{browser}
            \link{\@website}
            &
            \tablericon[height={\the\iconheight/\the\icondepth}]{brand-github}
            \link{\@github}[https://github.com/\@github]
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




% Custom Commands ==============================================================

\newlength{\itemspace}
\setlength{\itemspace}{1.5ex}
\newlength{\linespace}
\setlength{\linespace}{\smallskipamount}
\NewDocumentCommand{\link}{mo}{%
    \href{\IfValueTF{#2}{#2}{https://#1}}{\nolinkurl{#1}}%
}

\NewDocumentCommand{\dates}{mm}{#1 -- #2}

% See enumitem documentation, section 4, inline lists
\newlist{commalist}{description*}{20}
\setlist[commalist]{
    itemjoin={{, }},
    afterlabel={},      % Remove space after non-existent label
    mode=unboxed
}




% Body =========================================================================

\NewDocumentCommand{\education}{mmmmmomm}{%
    \begin{minipage}{\textwidth}
        \textbf{#1}\IfBlankF{#2}{, #2} \hfill \textbf{#4}%
        \IfBlankF{#3}{\par}\IfBlankF{#5}{\par}%
        \IfBlankF{#3}{\textit{#3}}\IfBlankF{#5}{\hfill GPA: #5/\IfValueTF{#6}{#6}{4.0}}%
        \IfBlankF{#7}{\par\textit{#7}}%
        \IfBlankF{#8}{\par#8}%
    \end{minipage}
    \addvspace{\itemspace}%
}

\NewDocumentEnvironment{experience}{mmmm}{
    \begin{minipage}{\textwidth}
        \textbf{#1}\IfBlankF{#2}{, #2} \hfill \textbf{#4}%
        \IfBlankF{#3}{\par\textit{#3}}%
        \begin{itemize}
}{
        \end{itemize}
    \end{minipage}
    \addvspace{\itemspace}%
}

\NewDocumentEnvironment{project}{mmm}{
    \begin{minipage}{\textwidth}
        \textbf{#1}\IfBlankF{#2}{ (#2)} \IfBlankF{#3}{\hfill #3}%
        \begin{itemize}
}{
        \end{itemize}
    \end{minipage}
    \addvspace{\itemspace}%
}

\NewDocumentEnvironment{skills}{m}{
    \textbf{#1:}
    \begin{commalist}
}{
    \end{commalist}
    \addvspace{\linespace}%
}

\NewDocumentCommand{\activity}{mm}{%
    \textbf{#1}\IfBlankF{#2}{\hfill #2}\par\addvspace{\linespace}%
}
