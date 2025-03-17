# AWE-SE
![GitHub License](https://img.shields.io/github/license/awegroup/AWE-SE)
![Static Badge](https://img.shields.io/badge/MATLAB-R2021b-blue)

A repository establishing the coupling between interoperable external repositories repositories [AWE-Power](https://github.com/awegroup/AWE-Power) and [AWE-Eco](https://github.com/awegroup/AWE-Eco) to setup workflows for system design of airborne wind energy (AWE). The framework is based on the field of multi-disciplinary design, analysis and optimisation (MDAO). It enables the design of AWE systems with an objective to minimise the levelised cost of energy (LCoE) and also other profit-based metrics. 

## How to cite

If you use the framework then please cite:

Joshi, R., von Terzi, D., and Schmehl, R.: System design and scaling trends for airborne wind energy, Wind Energ. Sci. Discuss. [preprint], https://doi.org/10.5194/wes-2024-161, in review, 2024.


## Dependencies

The framework is built and tested in MATLAB R2021b (without additional add-ons). Try installing this version if your version of MATLAB does not execute the code successfully.


## Installation

Please Clone the repository using the following command

git clone --recurse-submodules https://github.com/awegroup/AWE-SE

This will automatically download the interoperable external repositories AWE-Power and AWE-Eco as git submodules.

## Overview of the repository

The Repository consists following folders:

1. `AWE-Eco`: Interoperable external repository (https://github.com/awegroup/AWE-Eco) estimating cost of AWE systems included as a git submodule.
1. `AWE-Power`: Interoperable external repository (https://github.com/awegroup/AWE-Power) estimating power curve of AWE systems included as a git submodule.
1. `inputFiles`: Contains pre-defined input files.
1. `outputFiles`: Contains generated output files based on the pre-defined input files.
1. `src`: Contains the functions required to utilise the capabilities of the framework.
1. `WES2025_paper`: Contains scripts, input files and generated output files used to generate plots used in the associated journal publication mentioned above.

## Pre-defined example simulation

The script `example_workFlow_AWE_Power_AWE_Eco_coupling.m` can be directly executed to simulate with pre-defined input files.

It shows the workflow to couple [AWE-Power](https://github.com/awegroup/AWE-Power) and [AWE-Eco](https://github.com/awegroup/AWE-Eco).

### `inputFiles` folder

1. A pre-defined file named `inputFile_500kW_example.yml` describes a 500kW system and is the input file required to run [AWE-Power](https://github.com/awegroup/AWE-Power).
1. A pre-defined file named `eco_cost_inputs_GG_fixed.xlsx` describes the initialization of [AWE-Eco](https://github.com/awegroup/AWE-Eco).
1. A pre-defined file named `eco_system_inputs_awePower.m` describes the coupling between variables of [AWE-Power](https://github.com/awegroup/AWE-Power) and [AWE-Eco](https://github.com/awegroup/AWE-Eco).

### `outputFiles` folder

The generated output files have a prefix as the name of the used input file. Following .mat files are automatically saved in the `outputFiles` folder at the end of every simulation.

AWE-Power outputs

1. `optimDetails` has the details regarding the optimization.
1. `outputs` has all the raw outputs.
1. `processedOutputs` has post-processed relevant outputs for better visualization. 

AWE-Eco outputs

1. `inp` has the definition of the system taken from the outputs of AWE-Power.
1. `par` has the cost parameters as defined in `eco_cost_inputs_GG_fixed.xlsx`.
1. `eco` has the final outputs.

## To run with user-defined inputs

Create your own input files preserving the format and the structure as described by the pre-defined input files and use the `example_workFlow_AWE_Power_AWE_Eco_coupling.m` as a reference for the work flow.

## Licence
This project is licensed under the MIT License. Please see the below WAIVER in association with the license.

## Acknowledgement
The project was supported by the Digital Competence Centre, Delft University of Technology.

### WAIVER

Technische Universiteit Delft hereby disclaims all copyright interest in the program “AWE-SE” (a systems engineering toolchain) written by the Author(s).

Prof.dr. H.G.C. (Henri) Werij, Dean of Aerospace Engineering

Copyright (c) 2024 Rishikesh Joshi







