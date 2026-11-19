#!/bin/sh
# Static versions of the paper's figures (shown when scripts do not run): figs/*.svg.
# The matplotlib figures are converted from paper/figs/*.pdf; the TikZ schematics are compiled one
# per page from paper/figs/schematics.tex and converted page by page.
set -e
cd "$(dirname "$0")"
mkdir -p figs
for f in polygon36 trefoil3 growth std52 certex pdcompare; do
  pdftocairo -svg ../paper/figs/$f.pdf figs/$f.svg
done
T=$(mktemp -d)
cat > $T/s.tex <<'TEX'
\documentclass[11pt,border=6pt,multi=page]{standalone}
\usepackage{amsmath,amssymb,tikz}
\usetikzlibrary{arrows.meta,calc,decorations.pathreplacing,positioning}
\newcommand{\dmon}[1]{\textup{DMON#1}}
\newenvironment{page}{}{}
\standaloneenv{page}
\begin{document}
\input{SCHEM}
\begin{page}\FigDelta\end{page}
\begin{page}\FigSegSquare\end{page}
\begin{page}\FigFlipDelta\end{page}
\begin{page}\FigPsi\end{page}
\begin{page}\FigCorners\end{page}
\begin{page}\begin{minipage}{15cm}\FigCurtain\end{minipage}\end{page}
\begin{page}\FigOrigin\end{page}
\begin{page}\FigObligation\end{page}
\begin{page}\FigReach\end{page}
\begin{page}\FigSpan\end{page}
\end{document}
TEX
sed -i "s#SCHEM#$(cd ../paper/figs && pwd)/schematics.tex#" $T/s.tex
(cd $T && pdflatex -interaction=nonstopmode s.tex >/dev/null)
i=1
for n in delta segsquare flipdelta psi corners curtain origin obligation reach span; do
  pdftocairo -svg -f $i -l $i $T/s.pdf figs/$n.svg; i=$((i+1))
done
rm -rf $T
ls figs
