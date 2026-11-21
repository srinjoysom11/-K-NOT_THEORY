"""Bodies of the interactive figures, keyed by the paper's figure labels.  app.js builds each widget
inside the element with data-w; the <noscript> image is the paper's own figure (figs/*.svg, made by
build_static.sh), shown when scripts do not run."""


def fig(widget, static, extra=""):
    return (f'<div class="widget" data-w="{widget}">{extra}</div>'
            f'<noscript><img class="fallback" src="figs/{static}.svg" alt="The figure as printed in the paper."></noscript>')


FIG_HTML = {
    "fig:polygon": fig("polygon", "polygon36"),
    "fig:delta": fig("delta", "delta"),
    "fig:trefoil": fig("trefoil", "trefoil3"),
    "fig:flipdelta": fig("flipdelta", "flipdelta"),
    "fig:psi": fig("psi", "psi"),
    "fig:curtain": fig("curtain", "curtain"),
    "fig:corners": fig("corners", "corners"),
    "fig:origin": fig("origin", "origin"),
    "fig:obligation": fig("replay", "obligation"),
    "fig:reach": fig("reach", "reach"),
    "fig:span": fig("span", "span"),
    "tab:runs": '<div class="widget" data-w="runs"></div>',
    "fig:growth": fig("growth", "growth"),
    "fig:std52": fig("std52", "std52"),
    "fig:certex": fig("certex", "certex"),
    "fig:pdcompare": fig("pdcompare", "pdcompare"),
    "tab:deps": '<div class="widget" data-w="deps"></div>',
}
