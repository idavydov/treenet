#!/bin/bash
mkdir -p data/m0

DNDSTOOLSPATH=$HOME/work/dndstools

tail -n +2 data/m0.txt | \
       	while IFS=, read ac  k w ncodons nseq tlen
do
	fn=$ac
	echo $fn
	ot=data/m0/$fn.onwk
	t=${ot%.*}.nwk
	$DNDSTOOLSPATH/gen_tree.py --no-deroot --ntax $nseq --birth-rate 0.3 --death-rate 0.1 > $ot
	$DNDSTOOLSPATH/scale_tree.py $ot $tlen $t
	$DNDSTOOLSPATH/label_internal_nodes.py --in-place $t
done
