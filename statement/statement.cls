\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{statement}

\ProvidesClass{\thispackage}[2025/12/09 Tianyi and Alejandro's statement of purpose document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{fancyhdr}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{lastpage}
\RequirePackage{microtype}
\RequirePackage{titling}

\NewDocumentCommand{\program}{m}{%
    \gdef\@program{#1}%
}

\newbool{emaildefined}
\NewDocumentCommand{\email}{m}{%
    \gdef\@email{#1}%
    \booltrue{emaildefined}%
}

\setlength{\headheight}{15pt}
\pagestyle{fancy}
\fancyhead[L]{\theauthor\ifbool{emaildefined}{, \@email}{}}
\fancyhead[R]{\@program}
\fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}

\renewcommand{\maketitle}{%
    \thispagestyle{fancy}     % Show header and footer on title page
    \begin{center}%
        \large\textbf{\@title}%
    \end{center}%
}
