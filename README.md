# AWE-SE
![GitHub License](https://img.shields.io/github/license/awegroup/AWE-SE)
![Static Badge](https://img.shields.io/badge/MATLAB-R2021b-blue)

A repository establishing the coupling between AWE-Power and AWE-Eco to setup workflows for system design of airborne wind energy (AWE). The framework is based on the field of multi-disciplinary design, analysis and optimisation (MDAO). It enables the design of AWE systems with an objective to minimise the levelised cost of energy (LCoE) and also other profit-based metrics. 

## How to cite

If you use the framework then please cite:

Joshi, R., von Terzi, D., and Schmehl, R.: System design and scaling trends for airborne wind energy, Wind Energ. Sci. Discuss. [preprint], https://doi.org/10.5194/wes-2024-161, in review, 2024.


## Dependencies

The framework is built and tested in MATLAB R2021b (without additional add-ons). Try installing this version if your version of MATLAB does not execute the code successfully.


## Installation and execution 

Please Clone the repository using the following command

git clone --recurse-submodules https://github.com/awegroup/AWE-SE

## Overview of the Repository

The Repository consists following folders:

1. `AWE-Eco`: External repository (https://github.com/awegroup/AWE-Eco) estimating cost of AWE systems included as a submodule.
1. `AWE-Power`: External repository (https://github.com/awegroup/AWE-Power) estimating power curve of AWE systems included as a submodule.
1. `inputFiles`: Contains pre-defined input files.
1. `outputFiles`: Contains generated output files based on the pre-defined input files.
1. `src`: Contains the functions required to utilise the capabilities of the framework.
1. `WES2025_paper`: Contains scripts, input files and generated output files used to generate plots used in the associated journal publication mentioned above.

## 

## Licence
This project is licensed under the MIT License. Please see the below WAIVER in association with the license.

## Acknowledgement
The project was supported by the Digital Competence Centre, Delft University of Technology.

### WAIVER

Technische Universiteit Delft hereby disclaims all copyright interest in the program “AWE-SE” (a systems engineering toolchain) written by the Author(s).

Prof.dr. H.G.C. (Henri) Werij, Dean of Aerospace Engineering

Copyright (c) 2024 Rishikesh Joshi







