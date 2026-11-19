#!/usr/bin/env python3
"""Build index.html from the paper's LaTeX source, so that the interactive edition carries exactly
the paper's text, statements, proofs and numbering.

  1. preprocess len52.tex: expand the paper's macros, resolve \\cref from len52.aux (cleveref data)
     and \\cite from len52.bbl, replace each figure by a marker;
  2. convert with pandoc to HTML with MathML;
  3. number theorem-like blocks as LaTeX does (shared counter per section) and check the result
     against the labels in len52.aux;
  4. replace each figure marker by its interactive figure (the caption is the paper's caption);
  5. write index.html from template.html.

Requires pandoc and a compiled paper (len52.aux, len52.bbl).  Run: python3 build_page.py
"""
import os, re, sys, subprocess, html
HERE = os.path.dirname(os.path.abspath(__file__))
EX = os.path.dirname(HERE)
PAPER = os.path.join(EX, "paper")
GH = "https://github.com/srinjoysom11/-K-NOT_THEORY/blob/main/research/exact/"

src = open(os.path.join(PAPER, "len52.tex")).read()
aux = open(os.path.join(PAPER, "len52.aux")).read()
bbl = open(os.path.join(PAPER, "len52.bbl")).read()
nums = open(os.path.join(PAPER, "figs", "numbers.tex")).read() + open(os.path.join(PAPER, "figs", "certex.tex")).read()

# ---------------------------------------------------------------------------------- labels (cleveref)
LAB = {}
for m in re.finditer(r"\\newlabel\{([^}]*)@cref\}\{\{\[([a-z]+)\]\[[^\]]*\]\[[^\]]*\]([^}]*)\}", aux):
    LAB[m.group(1)] = (m.group(2), m.group(3))
NAMES = {"section": ("Section", "Sections"), "subsection": ("Section", "Sections"),
         "subsubsection": ("Section", "Sections"), "figure": ("Figure", "Figures"), "table": ("Table", "Tables"),
         "theorem": ("Theorem", "Theorems"), "lemma": ("Lemma", "Lemmas"), "corollary": ("Corollary", "Corollaries"),
         "proposition": ("Proposition", "Propositions"), "definition": ("Definition", "Definitions"),
         "example": ("Example", "Examples"), "remark": ("Remark", "Remarks"), "equation": ("Equation", "Equations")}


def cref(keys, cap=True):
    keys = [k.strip() for k in keys.split(",")]
    groups = []
    for k in keys:
        typ, num = LAB[k]
        if groups and groups[-1][0] == typ: groups[-1][1].append((k, num))
        else: groups.append((typ, [(k, num)]))
    parts = []
    for typ, items in groups:
        sg, pl = NAMES[typ]
        links = [f"@@A{k};{num}@@" for k, num in items]
        if len(links) == 1: parts.append(f"{sg} {links[0]}")
        elif len(links) == 2: parts.append(f"{pl} {links[0]} and {links[1]}")
        else: parts.append(f"{pl} " + ", ".join(links[:-1]) + f" and {links[-1]}")
    return " and ".join(parts) if len(parts) <= 2 else ", ".join(parts[:-1]) + " and " + parts[-1]

# --------------------------------------------------------------------------------- citations
CIT = {}; REFS = []
for k, m in enumerate(re.finditer(r"\\bibitem\{([^}]*)\}(.*?)(?=\\bibitem|\\end\{thebibliography\})", bbl, re.S)):
    CIT[m.group(1)] = k + 1
    REFS.append((m.group(1), m.group(2)))


def cite(opt, keys):
    ks = [k.strip() for k in keys.split(",")]
    inner = ", ".join(f"@@C{k};{CIT[k]}@@" for k in ks)
    if opt: inner += ", " + opt
    return f"[{inner}]"

# ---------------------------------------------------------------------------------- preprocessing
body = src[src.index("\\begin{document}") + len("\\begin{document}"):src.index("\\bibliographystyle")]
body = body.replace("\\maketitle", "").replace("\\tableofcontents", "")
abstract = re.search(r"\\begin\{abstract\}(.*?)\\end\{abstract\}", body, re.S).group(1)
body = re.sub(r"\\begin\{abstract\}.*?\\end\{abstract\}", "", body, flags=re.S)

def fmt_num(s):
    s = s.strip()
    m = re.fullmatch(r"([\d.]+)e(\d+)", s)
    if m: return f"{m.group(1)}\\,×\\,10<sup>{m.group(2)}</sup>" if False else f"$ {m.group(1)}\\times 10^{{{m.group(2)}}} $"
    if s.isdigit() and len(s) > 4:
        g = f"{int(s):,}".replace(",", "\u2009")
        return g
    return s

MACROS = {}
for m in re.finditer(r"\\newcommand\{\\(\w+)\}\{(.*)\}\s*$", nums, re.M):
    MACROS[m.group(1)] = m.group(2)


def expand(t):
    for name, val in MACROS.items():
        t = re.sub(r"\\" + name + r"(?![A-Za-z])", lambda _: val, t)
    t = re.sub(r"\\num\{([^}]*)\}", lambda m: fmt_num(m.group(1)), t)
    t = re.sub(r"\\Cref\{([^}]*)\}", lambda m: cref(m.group(1)), t)
    t = re.sub(r"\\cref\{([^}]*)\}", lambda m: cref(m.group(1)), t)
    t = re.sub(r"\\cite(?:\[([^\]]*)\])?\{([^}]*)\}", lambda m: cite(m.group(1), m.group(2)), t)
    t = re.sub(r"\\dmon(\d)", r"DMON\1", t)
    t = re.sub(r"\\dmon\{(\d)\}", r"DMON\1", t)
    t = t.replace("\\psiZ", "\\psi_Z").replace("\\psiY", "\\psi_Y")
    t = re.sub(r"\\rev(?![a-z])", r"\\operatorname{rev}", t)
    t = re.sub(r"\\Len(?![a-z])", r"\\operatorname{Len}", t)
    t = t.replace("\\Kft", "K_{5_2}").replace("\\Z", "\\mathbb{Z}").replace("\\R{", "\\mathbb{R}{")
    t = re.sub(r"\\R(?![a-zA-Z])", r"\\mathbb{R}", t)
    t = re.sub(r"\\(lean|word)\{", r"\\texttt{", t)
    t = t.replace("C\\texttt{++}", "C++")
    return t

FIGS = []


def fig_marker(m):
    env = m.group(0)
    lab = re.search(r"\\label\{([^}]*)\}", env).group(1)
    cap = re.search(r"\\caption\{(.*)\}\s*\\label", env, re.S)
    cap = cap.group(1) if cap else ""
    FIGS.append(lab)
    extra = ""
    if lab == "tab:deps":
        tab = re.search(r"\\begin\{tabularx\}\{\\linewidth\}\{[^\n]*\n(.*?)\\end\{tabularx\}", env, re.S).group(1)
        extra = "\n\\begin{tabular}{lll}\n" + tab + "\\end{tabular}\n"
    return f"\n\nFIGSTART@{lab}@\n\n{cap}\n\nFIGCAPEND\n{extra}\nFIGEND\n\n"

body = re.sub(r"\\begin\{(figure|table)\}.*?\\end\{\1\}", fig_marker, body, flags=re.S)
body = re.sub(r"\\begin\{enumerate\}\[[^\]]*\]", r"\\begin{enumerate}", body)
body = re.sub(r"\\begin\{description\}\[[^\]]*\]", r"\\begin{description}", body)
body = body.replace("\\centering", "").replace("\\small", "")
# web layout: long one-line displays become wrapping text (the PDF keeps the displays)
WEB = [
    (r"\[ X_1[1,5,2,4],\ X_2[3,9,4,8],\ X_3[5,1,6,10],\ X_4[7,3,8,2],\ X_5[9,7,10,6]. \]",
     r"\par $X_1[1,5,2,4]$, $X_2[3,9,4,8]$, $X_3[5,1,6,10]$, $X_4[7,3,8,2]$, $X_5[9,7,10,6]$.\par "),
    (r"\[ [10,3,1,4],\ [6,1,7,2],\ [2,7,3,8],\ [4,9,5,10],\ [8,5,9,6]. \]",
     r"\par $[10,3,1,4]$, $[6,1,7,2]$, $[2,7,3,8]$, $[4,9,5,10]$, $[8,5,9,6]$.\par "),
    (r"\[ w_{36}=\word{eeennuwwwwssseennwuueedddnnuuswsswdd} \]",
     r"\par $w_{36}={}$\word{eeennuwwwwssseennwuueedddnnuuswsswdd}\par "),
    (r"\[ 2B=E+A,\quad 2D=A+B,\quad 2E=B+C,\quad 2A=C+D,\quad 2C=D+E \pmod 7. \]",
     r"\par $2B=E+A$, $2D=A+B$, $2E=B+C$, $2A=C+D$, $2C=D+E$ (mod 7).\par "),
    (r"$r_b(r_a(r_b(t)))=2b-(2a-(2b-t))=2(2b-a)-t$",
     r"$r_b(r_a(r_b(t)))=2b-(2a-(2b-t))$ ${}=2(2b-a)-t$"),
    (r"\[ (A,B,C,D,E)=a\,(1,1,1,1,1)+b\,(0,1,3,4,2),\qquad a,b\in\Z/7, \]",
     r"\[ (A,B,C,D,E) \] \[ =a\,(1,1,1,1,1)+b\,(0,1,3,4,2), \] with $a,b\in\Z/7$, "),
    (r"\[ \operatorname{Hom}^*(G,D_7)=\{\varphi:G\to D_7 \text{ a homomorphism with } \sigma\circ\varphi=\alpha\}. \]",
     r"\[ \operatorname{Hom}^*(G,D_7)=\{\varphi:G\to D_7 \text{ a homomorphism} \] \[ \text{with } \sigma\circ\varphi=\alpha\}. \]"),
    (r"\[ LF\equiv E\pmod 7,\qquad\text{where row $k$ of $E$ is } e_k-e_0\quad(k=1,\dots,c-1), \]",
     r"\[ LF\equiv E\pmod 7, \] where row $k$ of $E$ is $e_k-e_0$ ($k=1,\dots,c-1$), "),
    (r"\[ F=\CertF\equiv\CertFmod\pmod7. \]", r"\[ F=\CertF \] \[ \equiv\CertFmod\pmod7. \]"),
    (r"\[ L=\CertL, \qquad LF\equiv\CertLF=\begin{pmatrix}e_1-e_0\\ e_2-e_0\end{pmatrix}\pmod 7. \]",
     r"\[ L=\CertL, \] \[ LF\equiv\CertLF \] \[ =\begin{pmatrix}e_1-e_0\\ e_2-e_0\end{pmatrix}\pmod 7. \]"),
]
for a, b in WEB:
    assert a in body, a[:40]
    body = body.replace(a, b)
body = expand(body)
abstract = expand(abstract)

PRE = r"""\documentclass{article}
\usepackage{amsmath,amsthm}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{proposition}[theorem]{Proposition}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem{example}[theorem]{Example}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}
\begin{document}
"""


def pandoc(tex, extra=()):
    r = subprocess.run(["pandoc", "-f", "latex", "-t", "html", "--mathml", "--wrap=none", *extra],
                       input=PRE + tex + "\n\\end{document}\n", capture_output=True, text=True)
    if r.returncode != 0: sys.exit(r.stderr)
    if r.stderr.strip(): print("pandoc:", r.stderr.strip()[:2000], file=sys.stderr)
    return r.stdout

H = pandoc(body, ["--section-divs"])
ABS = pandoc(abstract)

# ------------------------------------------------------------------------- numbering of theorems
THM = ["theorem", "lemma", "corollary", "proposition", "definition", "example", "remark"]
sec = 0; cnt = 0; out = []; pos = 0
tok = re.compile(r'<section id="([^"]*)" class="level1">|<div(?: id="([^"]*)")? class="(' + "|".join(THM) + r')">\s*<p><(?:strong|em)>([A-Za-z]+) \d+</(?:strong|em)>')
for m in tok.finditer(H):
    out.append(H[pos:m.start()]); pos = m.end()
    if m.group(1) is not None:
        if not m.group(1).startswith("acknowledgements"):
            sec += 1; cnt = 0
        out.append(m.group(0))
    else:
        cnt += 1; num = f"{sec}.{cnt}"
        lab = m.group(2)
        if lab and lab in LAB and LAB[lab][1] != num:
            sys.exit(f"numbering mismatch for {lab}: {num} vs {LAB[lab][1]}")
        ida = f' id="{lab}"' if lab else ""
        out.append(f'<div{ida} class="{m.group(3)} thm"><p><strong>{m.group(4)} {num}</strong>')
out.append(H[pos:]); H = "".join(out)

# section numbers in headings
c1 = 0; c2 = 0
def head(m):
    global c1, c2
    sid, lvl, tag, inner = m.group(1), m.group(2), m.group(3), m.group(4)
    if inner.startswith("Acknowledgements"):
        return m.group(0)
    if lvl == "1": c1 += 1; c2 = 0; n = f"{c1}"
    elif lvl == "2": c2 += 1; n = f"{c1}.{c2}"
    else: return m.group(0)
    return f'<section id="{sid}" class="level{lvl}" data-n="{c1}">\n<{tag}><span class="sec-n">{n}</span> {inner}</{tag}>'
H = re.sub(r'<section id="([^"]*)" class="level(\d)">\s*<(h\d)[^>]*>(.*?)</h\d>', head, H, flags=re.S)

# ---------------------------------------------------------------- links, cites, references
H = re.sub(r"@@A([^;@]*);([^@]*)@@", lambda m: f'<a class="xref" href="#{m.group(1)}">{m.group(2)}</a>', H)
ABS = re.sub(r"@@A([^;@]*);([^@]*)@@", lambda m: f'<a class="xref" href="#{m.group(1)}">{m.group(2)}</a>', ABS)
for T in ("H", "ABS"):
    globals()[T] = re.sub(r"@@C([^;@]*);([^@]*)@@", lambda m: f'<a class="cite" href="#ref-{m.group(1)}">{m.group(2)}</a>', globals()[T])

refs_html = []
for key, txt in REFS:
    t = re.sub(r"\\href\s*\{([^}]*)\}\s*\{\\path\{([^}]*)\}\}", r"\\href{\1}{\2}", txt)
    t = t.replace("\\newblock", "").replace("\\path", "\\texttt")
    h = pandoc(t).strip()
    h = re.sub(r"^<p>|</p>$", "", h)
    refs_html.append(f'<li id="ref-{key}">{h}</li>')

# ------------------------------------------------------------------------------------- figures
from figures import FIG_HTML

def figure(m):
    lab, cap, extra = m.group(1), m.group(2), m.group(3)
    kind = "Table" if lab.startswith("tab:") else "Figure"
    num = LAB[lab][1]
    body = FIG_HTML.get(lab, "")
    return (f'<figure class="fig" id="{lab}" data-fig="{lab}">{extra}{body}'
            f'<figcaption><span class="fig-n">{kind} {num}</span> {cap.strip()}</figcaption></figure>')

H = re.sub(r"<p>FIGSTART@([^@]*)@</p>(.*?)<p>FIGCAPEND</p>(.*?)<p>FIGEND</p>", figure, H, flags=re.S)
H = re.sub(r"<figcaption>(.*?)</figcaption>", lambda m: "<figcaption>" + re.sub(r"</?p>", " ", m.group(1)) + "</figcaption>", H, flags=re.S)
missing = [f for f in FIGS if f not in FIG_HTML]
if missing: print("figures without an interactive body:", missing, file=sys.stderr)

# ------------------------------------------------------------------------------ table of contents
toc = []
for m in re.finditer(r'<section id="([^"]*)" class="level(\d)"[^>]*>\s*<h\d[^>]*>(.*?)</h\d>', H, re.S):
    if m.group(2) == "1":
        toc.append((m.group(1), re.sub(r"<span class=\"sec-n\">[^<]*</span>\s*", "", re.sub(r"<(?!span|/span)[^>]+>", "", m.group(3)))))
H = H.replace("<p><strong>Acknowledgements</strong></p>", "")

# named operators (\\operatorname) as upright identifiers, without operator spacing
H = re.sub(r'<mo>([A-Za-z]{2,})</mo>', r'<mi>\1</mi>', H)
ABS = re.sub(r'<mo>([A-Za-z]{2,})</mo>', r'<mi>\1</mi>', ABS)

# break opportunities in code: after underscores, and every 6 letters in long lattice words
def wbr(m):
    t = m.group(1)
    t = re.sub(r'_', '_<wbr>', t)
    t = re.sub(r'\b([a-z]{20,})\b', lambda w: '<wbr>'.join(w.group(1)[k:k + 6] for k in range(0, len(w.group(1)), 6)), t)
    return f'<code>{t}</code>'
H = re.sub(r'<code>([^<]*)</code>', wbr, H)

# heading levels: the page title is the only h1; sections h2, subsections h3; LaTeX \\paragraph is a run-in heading
H = re.sub(r'<h4[^>]*>(.*?)</h4>\s*<p>', lambda m: f'<p><strong class="runin">{m.group(1)}</strong> ', H, flags=re.S)
H = re.sub(r'<h4[^>]*>(.*?)</h4>', lambda m: f'<p><strong class="runin">{m.group(1)}</strong></p>', H, flags=re.S)
H = re.sub(r'<(/?)h2([ >])', r'<\1h3\2', H)
H = re.sub(r'<(/?)h1([ >])', r'<\1h2\2', H)

tpl = open(os.path.join(HERE, "template.html")).read()
title_meta = "The knot 5₂ needs 36 steps on the cubic lattice"
toc_html = "\n".join(f'<li><a href="#{i}" data-sec="{k + 1}"><span class="toc-n">{k + 1 if not t.startswith("Acknowledgements") else ""}</span><span class="toc-t">{html.escape(t)}</span></a></li>'
                     for k, (i, t) in enumerate(toc))
page = (tpl.replace("{{ABSTRACT}}", ABS).replace("{{BODY}}", H).replace("{{TOC}}", toc_html)
        .replace("{{REFS}}", "\n".join(refs_html)).replace("{{TITLE}}", title_meta))
open(os.path.join(HERE, "index.html"), "w").write(page)
print("index.html:", len(page), "bytes;", len(FIGS), "figures;", len(toc), "sections")
