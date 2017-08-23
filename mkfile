< config.mk

##Apply Germline filter
results/%.bcf:Q: results/%.merged.bcf
##	set -x
	echo "[DEBUGGING] aplying final germline filter [NOT WORKING YET]"
##	delly-parallel filter \
##		-t $stem \
##		-f germline \
##		$prereq 	
##find out what is the problem, why does it throw core dump error; suspects: bad index, bad input bams(probably not, sinsce they would crash it previous steps)
##	&& mv $target.build $target \
##        && mv $target.build.csi $target.csi

##Merge SV sites into a unified site list
results/%.merged.bcf:	results/%.call.bcf
	set -x
	echo "[DEBUGGING] merging SV sites"
	delly-parallel merge \
		-t $stem \
		-m $MIN_LONG \
		-n $MAX_LONG \
        	-o $target.build \
		-b 500 \
		-r $OVERLAP \
		$prereq \
        && mv $target.build $target \
	&& mv $target.build.csi $target.csi

##SV calling using all samples in data/ 
results/%.call.bcf:
	set -x
	echo "[DEBUGGING] Calling $stem SV events"
	echo "Threads: "$OMP_NUM_THREADS
	mkdir -p `dirname $target`
	delly-parallel call \
		-t $stem \
		-g $REF \
		-o $target.build \
		data/*.bam \
	&& mv $target.build $target \
	&& mv $target.build.csi $target.csi
