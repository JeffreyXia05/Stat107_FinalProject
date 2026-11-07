# Stat107_FinalProject

**Question:** Of all confirmed exoplanets, how many orbit within their star's habitable zone, and how do they compare to Earth?

We use the NASA Exoplanet Archive's *Planetary Systems Composite Parameters* (PSCompPars) table. A planet is counted as in the habitable zone if its insolation (energy received from its star, Earth = 1) is between **0.35 and 1.75**. It is counted as Earth-sized if its radius is between **0.5 and 1.5** Earth radii. All code uses base R only.

---

## Project structure

```
Stat107_FinalProject/
├── Stat107_FinalProject.Rproj   RStudio project file (open this first)
├── README.md
├── Data/
│   ├── Original/                raw download from NASA (never edited)
│   └── Cleaned/                 cleaned data sets and summary tables (generated)
├── R/                           functions (.R) and analysis notebooks (.Rmd)
├── figures/                     plots used in the report
└── Reports/
    └── FinalReport.Rmd          the final write-up
```

### Data

| File | Role |
|---|---|
| `Data/Original/PSCompPars_2026.11.03_10.19.30.csv` | Raw PSCompPars table downloaded from the [NASA Exoplanet Archive](https://exoplanetarchive.ipac.caltech.edu) on 2026-11-03. One row per confirmed planet (6,451 planets). The first 88 lines are header comments describing the columns. |
| `Data/Cleaned/habitable_zone_clean.csv` | Planet name, host star, insolation and radius. Written by `08_DataCleaning.Rmd`. |
| `Data/Cleaned/density_clean.csv` | Name, host, insolation, mass, radius, plus computed density and surface gravity. Written by `08_DataCleaning.Rmd`. |
| `Data/Cleaned/PSCompPars_clean.csv` | Earlier cleaned copy of the full table. It is not produced by the current scripts. |
| `Data/Cleaned/hz_summary.csv` | Count and percentage of planets that are too cold, in the habitable zone, too hot, or unknown. Written by `16_DataAnalysis.Rmd`. |
| `Data/Cleaned/hz_candidates.csv` | Planets that are both in the habitable zone and Earth-sized. Written by `16_DataAnalysis.Rmd`. |
| `Data/Cleaned/numeric_summary.csv` | Min, quartiles, mean and max of the main variables. Written by `16_DataAnalysis.Rmd`. |

Variables kept from the raw data: `pl_name` (planet name), `hostname` (star name), `pl_insol` (insolation, Earth = 1), `pl_orbsmax` (orbital distance, AU), `pl_rade` (radius, Earth = 1), `pl_bmasse` (mass, Earth = 1), `pl_eqt` (equilibrium temperature, K), `st_teff` (host star temperature, K).

### Code: functions (`R/*.R`)

Each file defines one or more functions. None of them run anything by themselves.

| File | Role |
|---|---|
| `000_requirements.R` | Sources all the core function files below, so each notebook only needs one `source()` line. |
| `00_funct_CheckHabitableZone.R` | `check_habitable(df)` returns TRUE/FALSE for each planet with insolation between 0.35 and 1.75. |
| `01_funct_FindDensity.R` | `find_density(df)` adds a `pl_density` column (g/cm³) computed from mass and radius. |
| `02_funct_FindGravity.R` | `find_gravity(df)` adds a `pl_gravity` column computed from mass and radius. |
| `03_funct_PlottingDensity_Insolation.R` | `plot_density_energy(df)` draws a scatter plot of density vs. insolation with the habitable zone and Earth's density marked. |
| `04_funct_PlottingSize_Insolation.R` | `plot_size_energy(df)` draws a scatter plot of radius vs. insolation and highlights Earth-sized, habitable-zone planets. |
| `05_funct_CheckingSizeRelativeToEarth.R` | `relative_size_to_earth(df)` returns TRUE/FALSE for each planet with radius between 0.5 and 1.5 Earth radii. |
| `06_funct_RemoveNARows.R` | `remove_na(df)` drops rows with any missing value. |
| `07_funct_Size_Insolation_Comparisons.R` | `size_energy_comparisons(df)` returns TRUE for planets that are both in the habitable zone and Earth-sized. |
| `09_funct_LoadDataSet.R` | `load_dataset()` reads the raw CSV and keeps the 8 columns listed above. |
| `10_funct_HabitableZoneAnalysis.R` | Analysis helpers: classify planets as too cold, habitable zone or too hot, build summary tables, draw the insolation histogram, radius density plot and radius box plot, and save plots as PNG files. |
| `15_save_load_envi.R` | `save_Rdata()` saves the workspace to `12_SavingData.RData`. |

### Code: notebooks (`R/*.Rmd`)

| File | Role |
|---|---|
| `08_DataCleaning.Rmd` | **Run first.** Loads the raw data, writes the two cleaned CSVs, adds density and gravity, and saves everything to `12_SavingData.RData`. |
| `13_DataProcessing.Rmd` | Loads the saved data. This is a placeholder for further processing. |
| `14_DataVisualization.Rmd` | Draws the radius-vs-insolation and density-vs-insolation scatter plots. |
| `16_DataAnalysis.Rmd` | Main analysis: habitable-zone counts (Table 1), Earth-sized HZ candidates (Table 2), numerical summary, histogram and density plot. Saves tables to `Data/Cleaned/`, plots to `figures/`, and results to `17_AnalysisResults.RData`. |

### Saved R workspaces (generated)

| File | Role |
|---|---|
| `R/12_SavingData.RData` | Planet data frame (`usablePlanets`) plus all functions, saved by `08_DataCleaning.Rmd` and loaded by later notebooks. |
| `R/17_AnalysisResults.RData` | Summary tables from `16_DataAnalysis.Rmd`. |

### Figures (`figures/`)

Each figure is drawn by a function in an `.R` file and generated by running a notebook (`.Rmd`).

| Figure | What it shows | Generated by | Plotting function |
|---|---|---|---|
| `densityvinsolation.png` | Scatter plot of planet density vs. insolation, with the habitable zone (blue lines) and Earth's density (green line) marked. | `R/14_DataVisualization.Rmd`. The plot appears in the notebook and was saved to `figures/` with RStudio's **Export → Save as Image**. | `plot_density_energy()` in `R/03_funct_PlottingDensity_Insolation.R` |
| `radiusVinsulation.png` | Scatter plot of planet radius vs. insolation. Planets that are both Earth-sized and in the habitable zone are highlighted in red. | `R/14_DataVisualization.Rmd`, exported manually the same way. | `plot_size_energy()` in `R/04_funct_PlottingSize_Insolation.R` |
| `hist_insolation.png` | Histogram of insolation (log scale) with the habitable zone shaded and Earth marked. | `R/16_DataAnalysis.Rmd` (`save-figures` chunk), saved automatically. | `plot_insolation_histogram()` in `R/10_funct_HabitableZoneAnalysis.R` |
| `density_radius.png` | Density plot of planet radius for planets that are too cold, in the habitable zone, and too hot. | `R/16_DataAnalysis.Rmd` (`save-figures` chunk), saved automatically. | `plot_radius_density()` in `R/10_funct_HabitableZoneAnalysis.R` |
| `boxplot_radius.png` | Box plot of planet radius for each habitable-zone class, with the Earth-size range shaded. | `R/16_DataAnalysis.Rmd` (`save-figures` chunk), saved automatically. | `plot_radius_boxplot()` in `R/10_funct_HabitableZoneAnalysis.R` |

`16_DataAnalysis.Rmd` also draws a bar chart of planet counts by habitable-zone class (`chart1` chunk). It appears only in that notebook's PDF and is not saved to `figures/`.

All five images are used in `Reports/FinalReport.Rmd`.

### Report

| File | Role |
|---|---|
| `Reports/FinalReport.Rmd` | Final report: abstract, introduction, data, visualizations, analysis and individual contributions. Knits to PDF and uses the images in `figures/`. |

---

## How to reproduce our results

### 1. Install the software (one time)

1. Install **R** (version 4.x) from <https://cran.r-project.org>.
2. Install **RStudio Desktop** from <https://posit.co/download/rstudio-desktop>. It includes pandoc, which knitting needs.
3. In the RStudio Console, install the packages for knitting and PDF output:
   ```r
   install.packages(c("rmarkdown", "knitr", "tinytex"))
   tinytex::install_tinytex()
   ```
4. Restart RStudio.

### 2. Get the project

1. Clone the repository, or download it as a ZIP and unzip it:
   ```
   git clone https://github.com/JeffreyXia05/Stat107_FinalProject.git
   ```
2. Double-click **`Stat107_FinalProject.Rproj`** to open the project in RStudio.

### 3. Start from a clean session

1. Go to **Tools → Global Options → General**.
2. Uncheck **"Restore .RData into workspace at startup"**.
3. Set **"Save workspace to .RData on exit"** to **Never**.
4. Restart R with **Session → Restart R** (Ctrl+Shift+F10).

### 4. Run the notebooks in order

Open each file and click **Knit**. Always use Knit or Run All (Ctrl+Alt+R), not individual lines: `08` saves the global environment, and later notebooks need it.

| Step | File | What it produces |
|---|---|---|
| 1 | `R/08_DataCleaning.Rmd` | `Data/Cleaned/habitable_zone_clean.csv`, `Data/Cleaned/density_clean.csv`, `R/12_SavingData.RData` |
| 2 | `R/13_DataProcessing.Rmd` | (placeholder, nothing yet) |
| 3 | `R/14_DataVisualization.Rmd` | radius and density scatter plots |
| 4 | `R/16_DataAnalysis.Rmd` | summary tables in `Data/Cleaned/`, plots in `figures/`, `R/17_AnalysisResults.RData` |
| 5 | `Reports/FinalReport.Rmd` | 

Each notebook's PDF is saved next to its `.Rmd` file.

### Troubleshooting

- **`cannot open file ...`**: the working directory is wrong. Knit sets it to the notebook's folder automatically. If you run chunks by hand, first choose **Session → Set Working Directory → To Source File Location**.
- **`object 'usablePlanets' not found`**: `R/12_SavingData.RData` is missing or empty. Re-knit `08_DataCleaning.Rmd`.
- **`LaTeX failed to compile`**: run `tinytex::install_tinytex()` and restart RStudio.

---

## Authors

- **Joseph Biehn**: data loading, data cleaning, and functions
- **Joshua Arevalo**: data analysis, plots, and summary tables
- **Jeffrey Xia**: report and README
