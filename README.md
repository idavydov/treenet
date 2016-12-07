## M0 model
Model M0 has single omega and kappa value for the whole tree.
To generate M0 data use the following steps:

1. Generate parameters for the simulations (`src/m0_par.R`).
2. Simulate trees (`src/m0_trees.sh`).
3. Simulate sequences (`src/m0_seqs.sh`).
4. Export data to numpy format (`src/m0_export.py`).
