#!/bin/bash
mkdir -p data/m0

COSIMPATH=$HOME/work/cosim

tail -n +2 data/m0.txt | \
       	while IFS=, read ac k w ncodons nseq tlen
do
	fn=$ac
	echo $fn
	t=data/m0/$fn.nwk
	f=${t%.*}.fst
	log=${t%.*}.log
	$COSIMPATH/cosim --model M0 --omega $w --kappa $k --internal --log $log $t $ncodons $f
done
