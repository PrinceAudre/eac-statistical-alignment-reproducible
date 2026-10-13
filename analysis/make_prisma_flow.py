#!/usr/bin/env python3
"""Generate Supplementary Figure S2: study identification and screening flow.

Black-and-white only. Counts are fixed to the frozen Paper 2 search and
screening audit. The figure distinguishes the eligible finite frame (n=466)
from the stratified probability sample used for detailed coding (n=127).
"""
import matplotlib.pyplot as plt\nplt.rcParams["svg.fonttype"] = "none"
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

fig, ax = plt.subplots(figsize=(8.2, 10.6))
ax.set_xlim(0, 10)
ax.set_ylim(0, 14)
ax.axis("off")

BOX = dict(boxstyle="round,pad=0.02,rounding_size=0.04",
           facecolor="white", edgecolor="black", linewidth=1.0)

def box(x, y, w, h, label, fs=9.2, weight="normal"):
    patch = FancyBboxPatch((x, y), w, h, **BOX)
    ax.add_patch(patch)
    ax.text(x+w/2, y+h/2, label, ha="center", va="center",
            fontsize=fs, weight=weight, wrap=True)

def arrow(x1, y1, x2, y2):
    ax.add_patch(FancyArrowPatch((x1,y1), (x2,y2), arrowstyle="-|>",
                                 mutation_scale=11, linewidth=0.9,
                                 color="black", shrinkA=2, shrinkB=2))

ax.text(5, 13.65, "Study identification and screening flow",
        ha="center", va="center", fontsize=12, weight="bold")
ax.text(5, 13.25,
        "Systematic meta-research of DHS/MICS and DHIS2 analyses in the East African Community",
        ha="center", va="center", fontsize=9.5)

box(0.45,11.75,2.75,1.0,"PubMed\npublication-level records\nn = 602")
box(3.62,11.75,2.75,1.0,"Scopus\nunique publications\nn = 793")
box(6.80,11.75,2.75,1.0,"DHS Program\nsupplementary records\nn = 159")
box(2.0,10.05,6.0,1.15,
    "Deduplication and supplementary-source reconciliation\n"
    "PubMed-Scopus overlap n = 556; DHS Program already represented n = 68",
    fs=9.0)
for x in (1.825,5.0,8.175):
    arrow(x,11.75,x,11.22)
arrow(5.0,10.05,5.0,9.60)

box(2.8,8.60,4.4,0.95,"Unique candidate publications\nn = 930",
    fs=9.6,weight="bold")
arrow(5.0,8.60,5.0,8.10)
box(2.8,7.15,4.4,0.90,"Title-abstract screening\nn = 930")
box(7.65,7.15,2.0,0.90,"Excluded\nn = 69")
arrow(7.20,7.60,7.62,7.60)
arrow(5.0,7.15,5.0,6.65)
box(2.8,5.70,4.4,0.90,"Full-text review\nn = 861")
box(7.65,5.70,2.0,0.90,"Excluded\nn = 395")
arrow(7.20,6.15,7.62,6.15)
arrow(5.0,5.70,5.0,5.20)
box(2.6,4.15,4.8,0.95,
    "Eligible finite publication frame\nn = 466\nDHS/MICS n = 377; DHIS2 n = 89",
    fs=9.4,weight="bold")
arrow(5.0,4.15,5.0,3.60)
box(2.45,2.45,5.1,1.05,
    "Detailed methodological coding\nstratified probability sample n = 127\n"
    "DHS/MICS n = 80; DHIS2 n = 47",fs=9.3)
arrow(5.0,2.45,5.0,1.90)
box(2.75,0.85,4.5,0.95,
    "Independent reliability subsample\nn = 26\nDHS/MICS n = 16; DHIS2 n = 10",
    fs=9.2)

ax.text(0.45,0.22,
        "Note: The eligible finite frame (n = 466) defines the primary review population. "
        "The n = 127 set is a probability sample for detailed methodological coding, "
        "not a further eligibility exclusion.",
        ha="left",va="bottom",fontsize=8.1,wrap=True)

plt.tight_layout(pad=0.6)
for ext in ("pdf","eps","png","svg"):
    kwargs={"dpi":600} if ext=="png" else {}
    plt.savefig(f"Supplementary_Figure_S2_PRISMA_flow.{ext}",
                bbox_inches="tight", **kwargs)
