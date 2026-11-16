"""Value network for knot-diagram simplification.

Input: a PD code (list of 4-tuples, edge labels 1..2n).  Nodes are crossings.
Slots of a crossing X[i,j,k,l]: 0 = incoming under, 1 = left over, 2 = outgoing
under, 3 = right over.  Every edge label joins two slots, giving a typed edge
(slot_a, slot_b).  The network predicts the number of Reidemeister moves
needed to reach a diagram with fewer crossings than the start (capped).
"""
from __future__ import annotations
import numpy as np
import torch, torch.nn as nn

NMAX = 16          # max crossings (n+2 for n <= 14)
NTYPE = 16         # (slot_a, slot_b) edge types
DMAX = 10          # distance cap


def pd_to_arrays(pd, nmax=NMAX):
    """-> (sign[nmax] in {0,1,2: pad,neg,pos}, A[NTYPE,nmax,nmax] uint8)"""
    n = len(pd)
    where = {}
    for c, t in enumerate(pd):
        for s, lab in enumerate(t):
            where.setdefault(lab, []).append((c, s))
    A = np.zeros((NTYPE, nmax, nmax), np.uint8)
    for lab, ends in where.items():
        if len(ends) != 2:
            continue
        (c1, s1), (c2, s2) = ends
        A[s1 * 4 + s2, c1, c2] += 1
        A[s2 * 4 + s1, c2, c1] += 1
    sign = np.zeros(nmax, np.int64)
    for c, (i, j, k, l) in enumerate(pd):
        sign[c] = 2 if (l - j) % (2 * n) == 1 else 1
    return sign, A


class ValueNet(nn.Module):
    def __init__(self, hidden=64, layers=5):
        super().__init__()
        self.emb = nn.Embedding(3, hidden)
        self.self_lin = nn.ModuleList([nn.Linear(hidden, hidden) for _ in range(layers)])
        self.edge_lin = nn.ModuleList([nn.Linear(hidden, hidden * NTYPE, bias=False) for _ in range(layers)])
        self.norm = nn.ModuleList([nn.LayerNorm(hidden) for _ in range(layers)])
        self.head = nn.Sequential(nn.Linear(2 * hidden + 2, hidden), nn.ReLU(), nn.Linear(hidden, 1))
        self.hidden = hidden

    def forward(self, sign, A, glob):
        # sign [B,N] long, A [B,T,N,N] float, glob [B,2] float (excess crossings, n/10)
        mask = (sign > 0).float().unsqueeze(-1)
        h = self.emb(sign) * mask
        B, N, H = h.shape
        for sl, el, nm in zip(self.self_lin, self.edge_lin, self.norm):
            m = el(h).view(B, N, NTYPE, H)                  # message from node j via type t
            msg = torch.einsum("btij,bjth->bih", A, m)
            h = nm(torch.relu(sl(h) + msg) + h) * mask
        mean = h.sum(1) / mask.sum(1).clamp(min=1)
        mx = (h - 1e4 * (1 - mask)).max(1).values
        return self.head(torch.cat([mean, mx, glob], dim=1)).squeeze(-1)


def batch_from_pds(pds, n0s, device="cpu"):
    """pds: list of PD codes; n0s: crossing count of the START diagram."""
    arrs = [pd_to_arrays(p) for p in pds]
    sign = torch.from_numpy(np.stack([a[0] for a in arrs])).to(device)
    A = torch.from_numpy(np.stack([a[1] for a in arrs]).astype(np.float32)).to(device)
    glob = torch.tensor([[(len(p) - n0) / 2.0, n0 / 10.0] for p, n0 in zip(pds, n0s)], dtype=torch.float32, device=device)
    return sign, A, glob
