\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{statement}

\ProvidesClass{\thispackage}[2025/06/08 Tianyi and Alejandro's statement of purpose document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{fancyhdr}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{lastpage}
\let\CheckCommand\providecommand    % Suppress spurious microtype warning: https://tex.stackexchange.com/a/511714
\RequirePackage{microtype}
\RequirePackage{titling}

\newbool{emaildefined}
\NewDocumentCommand{\email}{m}{%
    \gdef\@email{#1}%
    \booltrue{emaildefined}%
}

\setlength{\headheight}{15pt}
\pagestyle{fancy}
\fancyhead[L]{\theauthor\ifbool{emaildefined}{, \@email}{}}
\fancyhead[R]{\thetitle}
\fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
