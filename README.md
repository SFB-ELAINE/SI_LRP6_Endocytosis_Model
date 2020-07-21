# SI_LRP6_Endocytosis_Model
Supporting information for the paper by F. Haack, K. Budde, and A. M. Uhrmacher: "Exploring mechanistic and temporal regulation of LRP6 endocytosis in canonical WNT signaling", Journal of Cell Science (2020), doi: 10.1242/jcs.243675.

## General information
This README briefly explains the content of the subdirectories and how to replicate all experiments and obtain the figures shown in the paper mentioned above.

## Requirements for Replicating all Experiments

1. Install [Maven](https://maven.apache.org/).
1. Install [R](https://www.r-project.org/) (and, optionally, [RStudio](https://rstudio.com/)).
2. Run "ExecuteSesslandPlotResults.R".
(Source the content of the active "ExecuteSesslandPlotResults.R" document in RStudio. If an error message shows up, try to resource the script. All requirements, such as Sessl and ML-Rules, should be automatically downloaded. (This is currently working under Linux (Centos 7) and Windows 10.))
3. All plots are created within the new directory "/experiments/Plots/".

### Subdirectory *data*
This directory contains reference data. See *data/README.md* for more information.

### Subdirectory *experiments*
This directory contains subdirectories with all in silico experiments. See *experiments/README.md* for more information.

### Subdirectory *models*
This directory contains all simulation models. See *models/README.md* for more information.