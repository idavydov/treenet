## M0 model
Model M0 has single omega and kappa value for the whole tree.
To generate M0 data use the following steps:

1. Generate parameters for the simulations (`src/m0_par.R`).
2. Simulate trees (`src/m0_trees.sh`).
3. Simulate sequences (`src/m0_seqs.sh`).
4. Export data to numpy format (`src/m0_export.py`).

The resulting file is `data/m0.npy.xz`. This is lzma compressed numpy
file. It can be decompressed using `xz -d`. It contains a dictionary,
every item is a single dataset (tree + alignment).

```python
import numpy as np

data = np.load('data/m0.npy')[()]
```

This is dictionary where keys are dataset IDs, and values are
dictionaries. Dictionary describing a single dataset looks as follows:

```python
{
    'tlen': '1.84', # tree length in codon substitutions
    'nseq': '8', # number of leaf sequences
    'w': '0.5', # omega (dN/dS), simulation parameter
    'k': '2.5', # kappa, ts/tv ratio, simulation parameter
    'ncodons': '110', # alignment length in codons
    'bifurcations': [ # list of bifurcations, post-ordered
        {
            'level': 2, # node depth, 0 is root
            'dist': 0.18, # distance between the two nodes (in codon substitions)
            'input': np.array, # child sequences, shape (2, ncodons*3)
            'output': np.array, # parent sequence, shape (ncodons*3,)
        },
        ...
    ],
}
```

Sequences represented as arrays of bytes, each bytes is a nucleotide
(ATGC -> 0123). Bifurcations are listed in post-order.
