/-
  Len52.Figure — facts about the diagram drawn in the paper (Figure 1 and the upper-bound section).
  The paper draws the projection of `w52` along (1, -1, 4) because its crossings are well separated.
  This file checks, by kernel evaluation, that this projection is regular, has exactly the same five
  crossings (same edges, same parameters up to the projection) and the same PD code as the projection
  along `D52 = (1, -19, 40)` used by the certificate, and that (0, 1, 3, 4, 2) is a Fox 7-colouring of it.
  It also checks the explicit relabelling quoted in the paper: switching all crossings of the PD code
  and adding 6 to every edge label (mod 10) gives the KnotInfo code of 5_2 crossing by crossing.
  It also checks the 24-step trefoil polygon of the worked certificate example.
  Not used by `no_short`.
-/
import Len52.PD

namespace Len52
namespace Figure
open PD

def DFig : V3 := ⟨1, -1, 4⟩

theorem fig_crossings : (diagram DFig w52).map List.length = some 5 := by decide +kernel

theorem fig_pd_eq : pdOf DFig w52 = some pyPD := by decide +kernel

theorem fig_witness : hasColoringWitness DFig w52 x52 = true := by
  rw [hasColoringWitness_eq]; decide +kernel

theorem fig_coloring : HasNontrivialColoring DFig w52 :=
  hasColoringWitness_sound DFig w52 x52 fig_witness

/-- the relabelling of the paper: x ↦ x + 6 (mod 10, labels 1..10) -/
def shift6 (x : Nat) : Nat := (x - 1 + 6) % 10 + 1

/-- mirror the code of w52, then add 6 to every label: crossing k becomes the k-th entry below,
    which is the KnotInfo code `std52` listed in another order -/
theorem fig_relabel :
    (mirror pyPD).map (List.map shift6) =
      [[9, 7, 10, 6], [7, 3, 8, 2], [3, 9, 4, 8], [5, 1, 6, 10], [1, 5, 2, 4]] ∧
    sortT ((mirror pyPD).map (List.map shift6)) = sortT std52 := by
  decide +kernel

/-- the 24-step polygon of the worked certificate example in the paper:
    "eeeuuswwdnneeesswwnuwwdd" -/
def wTre : List Nat := [0, 0, 0, 4, 4, 3, 1, 1, 5, 2, 2, 0, 0, 0, 3, 3, 1, 1, 2, 4, 1, 1, 5, 5]

theorem wTre_eq : "eeeuuswwdnneeesswwnuwwdd".toList.map letterCode = wTre := by decide +kernel

local instance decIsPolygonF : DecidablePred IsPolygon := fun w => by
  unfold IsPolygon; infer_instance

theorem wTre_length : wTre.length = 24 := by decide

theorem wTre_polygon : IsPolygon wTre := by decide +kernel

def DTre : V3 := ⟨7, 13, 31⟩

/-- its diagram along (7, 13, 31) has three crossings and is the KnotInfo diagram of the trefoil, up to
    relabelling and mirror image -/
theorem wTre_pd : (pdOf DTre wTre).map (fun P => (P.length, pdEquiv P std31)) = some (3, true) := by
  decide +kernel

end Figure
end Len52
