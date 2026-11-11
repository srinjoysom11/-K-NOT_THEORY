# download_papers.ps1  --  fetches every freely available paper on the MA498 reading list.
# Run from the MA498-Knots folder in PowerShell:
#     powershell -ExecutionPolicy Bypass -File .\download_papers.ps1
# Files go into .\papers\<topic>\.  Already-downloaded files are skipped, so re-running is safe.
# arXiv asks for <= 1 request / 3 s, so the full run takes ~4 minutes.

$ErrorActionPreference = "Continue"
$root = Join-Path $PSScriptRoot "papers"
$ua   = "Mozilla/5.0 (MA498 reading list; polite batch download)"

# topic | filename | url
$papers = @(
# ---------- 1. core: minimal lattice length / numerical tables ----------
"1_core_lattice_length|JvR-Rechnitzer_2011_Minimal_knotted_polygons_cubic_lattices_1107.2162.pdf|https://arxiv.org/pdf/1107.2162"
"1_core_lattice_length|Hong-No-Oh_2014_Upper_bounds_minimal_length_cubic_lattice_knots_1411.1849.pdf|https://arxiv.org/pdf/1411.1849"
"1_core_lattice_length|Hong-Kim-No-Oh_2014_Min_lattice_length_and_ropelength_1411.1845.pdf|https://arxiv.org/pdf/1411.1845"
"1_core_lattice_length|Huh-Hong-Kim-No-Oh_2014_2-bridge_knots_and_links_lattice_length_1411.1840.pdf|https://arxiv.org/pdf/1411.1840"
"1_core_lattice_length|Ishihara-et-al_2012_Min_step_number_knots_in_slabs_TECHREPORT.pdf|https://math.charlotte.edu/wp-content/uploads/sites/909/2024/06/2011_21c.pdf"
"1_core_lattice_length|Gasumova-JvR-Rechnitzer_2012_Lattice_knots_in_a_slab_1204.6674.pdf|https://arxiv.org/pdf/1204.6674"
"1_core_lattice_length|JvR-Rechnitzer_2012_Compressibility_of_minimal_lattice_knots_1203.3212.pdf|https://arxiv.org/pdf/1203.3212"
"1_core_lattice_length|Croll_2018_BiEntropy_knots_simple_cubic_lattice_1802.03772.pdf|https://arxiv.org/pdf/1802.03772"
"1_core_lattice_length|Mann-McLoudMann_Cube_knots.pdf|https://faculty.washington.edu/cemann/Cube-Knots.pdf"
# ---------- 2. algorithms (BFACF, GAS, annealing) and lattice-knot spaces ----------
"2_algorithms|JvR-Rechnitzer_2010_BFACF_style_algorithms_BCC_FCC_1011.3847.pdf|https://arxiv.org/pdf/1011.3847"
"2_algorithms|JvR-Rechnitzer_2011_Universality_of_knot_probability_ratios_1101.4047.pdf|https://arxiv.org/pdf/1101.4047"
"2_algorithms|JvR-Rechnitzer_GAS_knotted_polygons_GASknot.pdf|https://personal.math.ubc.ca/~andrewr/pubs/GASknot_f.pdf"
"2_algorithms|Cantarella-Rechnitzer-Schumacher-Shonkwiler_2025_New_upper_bounds_stick_numbers_2508.18263.pdf|https://arxiv.org/pdf/2508.18263"
"2_algorithms|Ozawa_2026_Merge_trees_lattice_knot_spaces_BFACF_2605.25322.pdf|https://arxiv.org/pdf/2605.25322"
"2_algorithms|Ozawa_2026_Density_compression_lattice_knot_merge_trees_2605.29160.pdf|https://arxiv.org/pdf/2605.29160"
"2_algorithms|Ozawa_2026_Ropelength_filtered_knot_spaces_2604.17905.pdf|https://arxiv.org/pdf/2604.17905"
"2_algorithms|Ozawa_2026_Geometric_densities_compression_radii_2604.27912.pdf|https://arxiv.org/pdf/2604.27912"
"2_algorithms|JvR-Orlandini-Tesi_2025_Relative_knot_probabilities_confined_2501.08835.pdf|https://arxiv.org/pdf/2501.08835"
"2_algorithms|JvR-Orlandini-Tesi_2026_Thermodynamics_confined_knotted_polygons_2603.07730.pdf|https://arxiv.org/pdf/2603.07730"
"2_algorithms|Ashton-Cantarella-Piatek-Rawdon_2010_Knot_tightening_gradient_descent_1002.1723.pdf|https://arxiv.org/pdf/1002.1723"
# ---------- 3. analytic bounds: ropelength / thickness / stick numbers ----------
"3_analytic_bounds|Klotz_2026_LLM-assisted_advances_ropelength_2611.14234.pdf|https://arxiv.org/pdf/2611.14234"
"3_analytic_bounds|Diao-Ernst-Por-Ziegler_2009_Ropelengths_almost_linear_0912.3282.pdf|https://arxiv.org/pdf/0912.3282"
"3_analytic_bounds|Cantarella-Kusner-Sullivan_2001_Minimum_ropelength_knots_links_math0103224.pdf|https://arxiv.org/pdf/math/0103224"
"3_analytic_bounds|Denne-Diao-Sullivan_2004_Quadrisecants_ropelength_lower_bounds_math0408026.pdf|https://arxiv.org/pdf/math/0408026"
"3_analytic_bounds|Diao_2019_Braid_index_bounds_ropelength_below_1901.10663.pdf|https://arxiv.org/pdf/1901.10663"
"3_analytic_bounds|Diao_2022_Ropelength_conjecture_alternating_knots_2208.00123.pdf|https://arxiv.org/pdf/2208.00123"
"3_analytic_bounds|Klotz-Maldonado_2021_Ropelength_of_complex_knots_2108.01857.pdf|https://arxiv.org/pdf/2108.01857"
"3_analytic_bounds|Klotz-Thompson_2025_Concentric_helices_torus_knots_2504.00861.pdf|https://arxiv.org/pdf/2504.00861"
"3_analytic_bounds|Klotz-Anderson_2023_Ropelength_writhe_12-crossing_2305.17204.pdf|https://arxiv.org/pdf/2305.17204"
"3_analytic_bounds|Klotz_2026_Pearl_necklace_vs_FCC_lattice_knots_2608.19441.pdf|https://arxiv.org/pdf/2608.19441"
"3_analytic_bounds|Hong-No-Oh_2012_Upper_bound_lattice_stick_number_1209.0048.pdf|https://arxiv.org/pdf/1209.0048"
"3_analytic_bounds|Huh-Oh_2015_Knots_small_lattice_stick_numbers_1512.03582.pdf|https://arxiv.org/pdf/1512.03582"
"3_analytic_bounds|Jin-Lee_2011_Arc_index_smaller_than_crossing_number_1106.2723.pdf|https://arxiv.org/pdf/1106.2723"
# ---------- 4. links ----------
"4_links|Hong-No-Oh_2014_Links_small_lattice_stick_numbers_1402.1642.pdf|https://arxiv.org/pdf/1402.1642"
"4_links|Adams-et-al_2012_Stick_index_knots_links_cubic_lattice_1205.5256.pdf|https://arxiv.org/pdf/1205.5256"
"4_links|Kim-No_2018_Circuit_presentation_4_z-sticks_1805.00213.pdf|https://arxiv.org/pdf/1805.00213"
"4_links|Yoo-Lee-Oh_2018_Lattice_stick_number_spatial_graphs_1806.09720.pdf|https://arxiv.org/pdf/1806.09720"
"4_links|Allardice-Bloch_2018_Lattice_diagrams_of_knots_1803.03685.pdf|https://arxiv.org/pdf/1803.03685"
"4_links|Naimi-Pavelescu-Pavelescu_2018_Escher_squares_lattice_links_1804.04724.pdf|https://arxiv.org/pdf/1804.04724"
"4_links|Blair-Pongtanapaisan-Soteros_2026_Spanning_pairs_lattice_polygons_2601.11481.pdf|https://arxiv.org/pdf/2601.11481"
"4_links|Klotz_2026_Ropelength_TQQ_torus_links_2603.02416.pdf|https://arxiv.org/pdf/2603.02416"
"4_links|Komendarczyk-Michaelides_2016_Ropelength_finite_type_invariants_links_1604.03870.pdf|https://arxiv.org/pdf/1604.03870"
"4_links|Orlandini-Tesi-Whittington_2021_Linking_constrained_pairs_of_rings.pdf|https://cris.unibo.it/retrieve/handle/11585/845827/2d915eda-0a0b-4ad6-997c-24d2ed44e069/JPHYSA_2021OrlandiniTesiWhittington.pdf"
# ---------- 5. ML / RL / search methods ----------
"5_ml_rl|Gukov-Halverson-Ruehle-Sulkowski_2020_Learning_to_unknot_2010.16263.pdf|https://arxiv.org/pdf/2010.16263"
"5_ml_rl|Applebaum-et-al_2024_Unknotting_number_RL_2409.09032.pdf|https://arxiv.org/pdf/2409.09032"
"5_ml_rl|Davies-Juhasz-Lackenby-Tomasev_2021_Signature_cusp_geometry_2111.15323.pdf|https://arxiv.org/pdf/2111.15323"
"5_ml_rl|Halverson-Ruehle_2025_Learning_topological_invariance_2504.12390.pdf|https://arxiv.org/pdf/2504.12390"
"5_ml_rl|Cantarella-Schumacher-Shonkwiler_2026_Hard_unknots_often_easy_2607.28772.pdf|https://arxiv.org/pdf/2607.28772"
"5_ml_rl|Georgiev-GomezSerrano-Tao-Wagner_2025_Math_exploration_at_scale_AlphaEvolve_2511.02864.pdf|https://arxiv.org/pdf/2511.02864"
"5_ml_rl|Novikov-et-al_2025_AlphaEvolve_2506.13131.pdf|https://arxiv.org/pdf/2506.13131"
"5_ml_rl|Charton-Ellenberg-Wagner-Williamson_2024_PatternBoost_2411.00566.pdf|https://arxiv.org/pdf/2411.00566"
"5_ml_rl|Wagner_2021_Constructions_via_neural_networks_2104.14516.pdf|https://arxiv.org/pdf/2104.14516"
"5_ml_rl|Espitia-Pang-Gumbart_2024_3D_HP_model_deep_RL_2412.20329.pdf|https://arxiv.org/pdf/2412.20329"
"5_ml_rl|Yang-et-al_2022_Deep_RL_HP_model_2211.14939.pdf|https://arxiv.org/pdf/2211.14939"
"5_ml_rl|Roucairol-Cazenave_2023_HP_model_nested_Monte_Carlo_2301.09533.pdf|https://arxiv.org/pdf/2301.09533"
"5_ml_rl|Wust-Landau_2012_Wang-Landau_lattice_polymers_HP_1207.3974.pdf|https://arxiv.org/pdf/1207.3974"
"5_ml_rl|Braghetto-Kundu-Baiesi-Orlandini_2022_ML_understands_knotted_polymers_2212.11822.pdf|https://arxiv.org/pdf/2212.11822"
"5_ml_rl|Zhang-Zhu-Dai_2025_Recognizing_generating_knotted_structures_ML_2501.12780.pdf|https://arxiv.org/pdf/2501.12780"
"5_ml_rl|Vandans-et-al_2020_Identifying_knot_types_polymers_ML_PRE.pdf|https://www.math.cuhk.edu.hk/~ztwu/PRE.pdf"
)

$ok=0; $skip=0; $fail=@()
foreach ($line in $papers) {
    $topic, $name, $url = $line.Split("|")
    $dir = Join-Path $root $topic
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $out = Join-Path $dir $name
    if ((Test-Path $out) -and ((Get-Item $out).Length -gt 10000)) { $skip++; continue }
    try {
        Write-Host "GET $name"
        Invoke-WebRequest -Uri $url -OutFile $out -UserAgent $ua -UseBasicParsing -TimeoutSec 120
        $ok++
    } catch {
        Write-Warning "FAILED: $name  ($url)  $_"
        $fail += "$name  $url"
        if (Test-Path $out) { Remove-Item $out }
    }
    if ($url -like "*arxiv.org*") { Start-Sleep -Seconds 3 }
}
Write-Host ""
Write-Host "Downloaded $ok, skipped $skip (already present), failed $($fail.Count)."
if ($fail.Count) { $fail | Set-Content (Join-Path $root "FAILED_downloads.txt"); Write-Host "See papers\FAILED_downloads.txt" }
