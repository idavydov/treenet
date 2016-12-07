#!/usr/bin/env python3
import sys
import csv
import lzma
import os.path

import dendropy

from Bio import AlignIO

import numpy as np

nucs = 'ATGC'
nuc2int = {nuc: i for i, nuc in enumerate(nucs)}

def to_array(record):
    return np.fromiter((nuc2int[l] for l in str(record.seq)),
                    dtype=np.dtype('b'))

def get_bifurcations(tree, ali):
    seqd = {record.id: to_array(record) for record in ali}
    bf = []
    for node in tree.postorder_internal_node_iter():
        children = node.child_nodes()
        assert len(children) == 2
        seq1 = seqd[children[0].taxon.label]
        seq2 = seqd[children[1].taxon.label]
        seq_ancestral = seqd[node.taxon.label]
        bf.append({
            'level': node.level(),
            'dist': children[0].edge_length + children[1].edge_length,
            'input': np.array([seq1, seq2]),
            'output': seq_ancestral
        })
    return bf

def read_annotation(fn):
    ann = {}
    with open(fn) as f:
        header = f.readline().rstrip().split(',')
        for line in f:
            ac, line = line.split(',', 1)
            ann[ac] = dict(zip(header, line.rstrip().split(',')))
    return ann

if __name__ == '__main__':
    ann = read_annotation(os.path.join('data', 'm0.txt'))
    for ac in ann:
        base = os.path.join('data', 'm0', ac)
        ali_fn = base + '.fst'
        tree_fn = base + '.nwk'
        ali = AlignIO.read(ali_fn, 'fasta')
        tree = dendropy.Tree.get(path=tree_fn, schema='newick',
                                 suppress_internal_node_taxa=False)
        ann[ac]['bifurcations'] = get_bifurcations(tree, ali)
    with lzma.open('data/m0.npy.xz', 'w') as outf:
        np.save(outf, ann)
