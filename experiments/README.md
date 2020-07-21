# Endocytosis Experiments

All experiments were written in [SESSL](http://sessl.org) (Simulation Experiment Specification on a Scala Layer) ([1] [Ewald et al. (2014)](https://doi.org/10.1145/2567895), [2] [Warnke et al. (2018)](https://doi.org/10.1093/bioinformatics/btx741))--the domain-specific language embedded in the functional and object-oriented programming language Scala.


## Replicating all experiments
Please see the main README file for more information.

## Experiment directories

Every subdirectory contains one particular experiment that corresponds to a figure in the publication. Some experiments have not been added to the publication as they do not provide new findings.

* M1_General_S01_A -> **Fig. 3 (a)**
* M1_General_S01_B -> **Fig. 3 (b)**
* M2_Microdomains_S02_A -> **Fig. 4 (a)**
* M2_Microdomains_S02_B -> not shown in paper
* M2_Microdomains_S02_C -> **Fig. 4 (b)**
* M2_Microdomains_S03_A -> **Fig. 4 (c)**
* M2_Microdomains_S03_B -> **Fig. 4 (d)**
* M3_Wnt_S04_A -> **Fig. 5 (a)**
* M3_Wnt_S04_B -> not shown in paper
* M3_Wnt_S04_C -> not shown in paper
* M3_Wnt_S05_A -> **Fig. 5 (b)**
* M3_Wnt_S05_B -> **Fig. 5 (c)**
* M4_Dkk_S06_A -> **Fig. 5 (d)**
* M4_Dkk_S06_B -> not shown in paper

## Contents of every directory

Every experiment directory contains the following files:

* **run.sh/run.bat**: This file starts the exectution of the experiment. It basically calls Apache Maven which takes care of all dependencies.
* **mvnw/mvnw.cmd**: This is the Maven wrapper file.
* **.mvn**: This (hidden) Maven directory is the base directory of the Maven project.
* **pom.xml**: This file contains information about dependencies to other software.
* ***.scala**: This scala-script contains the actual experiment description.


