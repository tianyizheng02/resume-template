\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{resume}

\ProvidesClass{\thispackage}[2026/10/01 Tianyi and Alejandro's resume document class]

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




% Contact Info =================================================================

\NewDocumentCommand{\name}{m}{\gdef\@name{#1}}
\NewDocumentCommand{\@name}{}{\ClassWarning{\thispackage}{No \noexpand\name provided}}

\newbool{pronounsdefined}
\NewDocumentCommand{\pronouns}{m}{%
    \gdef\@pronouns{#1}%
    \booltrue{pronounsdefined}%
}

\newcommand{\prefixemail}{mailto:}
\newcommand{\prefixlinkedin}{https://www.linkedin.com/in/}
\newcommand{\prefixgithub}{https://github.com/}

\ExplSyntaxOn

% Define dedicated local variables instead of relying on generic scratch variables
\int_new:N \l__resume_columns_int
\tl_new:N \l__resume_table_spec_tl

% Holds pairs {icon_name}{formatted_val}
\seq_new:N \g_resume_contacts_seq

% Contact info tuples added to sequence in call order
\NewDocumentCommand{\email}{m}{
  \seq_put_right:Nn \g_resume_contacts_seq { {mail}{\link{#1}[\prefixemail#1]} }
}
\NewDocumentCommand{\phone}{m}{
  \seq_put_right:Nn \g_resume_contacts_seq { {phone}{#1} }
}
\NewDocumentCommand{\linkedin}{m}{
  \seq_put_right:Nn \g_resume_contacts_seq { {brand-linkedin}{\link{#1}[\prefixlinkedin#1]} }
}
\NewDocumentCommand{\website}{m}{
  \seq_put_right:Nn \g_resume_contacts_seq { {browser}{\link{#1}} }
}
\NewDocumentCommand{\github}{m}{
  \seq_put_right:Nn \g_resume_contacts_seq { {brand-github}{\link{#1}[\prefixgithub#1]} }
}

\cs_new:Nn \__resume_format_contact:nn {
    \tablericon[height={\the\iconheight/\the\icondepth}]{#1}~#2
}

% \printcontacts[N], where N is number of columns
\NewDocumentCommand{\printcontacts}{O{2}} {
    \int_compare:nNnT { \seq_count:N \g_resume_contacts_seq } > { 0 } {
        % Construct table spec based on number of columns
        \int_set:Nn \l__resume_columns_int {#1}
        \tl_clear:N \l__resume_table_spec_tl
        \int_step_inline:nn \l__resume_columns_int {
            \tl_put_right:Nn \l__resume_table_spec_tl { l }
            \int_compare:nNnT { ##1 } < { \l__resume_columns_int } {
                \tl_put_right:Nn \l__resume_table_spec_tl { @{\qquad} }
            }
        }

        \begin{tabular}{ \l__resume_table_spec_tl }
            \seq_map_indexed_inline:Nn \g_resume_contacts_seq {
                \__resume_format_contact:nn ##2

                % Handle column separators and row breaks
                \int_compare:nTF { \int_mod:nn { ##1 } { \l__resume_columns_int } == 0 } {
                    \int_compare:nNnT { ##1 } < { \seq_count:N \g_resume_contacts_seq } { \\ }
                } {
                    \int_compare:nNnT { ##1 } < { \seq_count:N \g_resume_contacts_seq } { & }
                }
            }
        \end{tabular}
    }
}

\ExplSyntaxOff




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
    \end{adjustbox}%
    \hfill
    \begin{adjustbox}{valign=t}
        \setlength{\tabcolsep}{0em}
        \printcontacts[3]
    \end{adjustbox}%
    \medskip
    % Unset commands, modeled of the definition of \maketitle from the article document class
    % https://tex.stackexchange.com/a/452985/270231
    \let\makeheader\relax
    \let\name\relax
    \let\@name\@empty
    \let\pronouns\relax
    \let\@pronouns\@empty
    \let\email\relax
    \let\website\relax
    \let\phone\relax
    \let\linkedin\relax
    \let\github\relax
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
