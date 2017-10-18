#PATH to executable files; must include path to java, and plan 9 from user space executables.
PATH="/castle/cfresno/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/plan9/bin:/usr/bin/"

###
#Delly2, call configuration.
##

#path to human genome reference file, in fasta format.
##[ -z "$REF" ] \
##&& REF="reference/Homo_sapiens_assembly38.fasta"
REF="reference/Homo_sapiens_assembly38.fasta"

#Number of threads to run Delly2 in parallel mode ("Delly2 primarily parallelizes on the sample level. Hence, OMP_NUM_THREADS should be always smaller or equal to the number of input samples"[1]).
##[ -z "$OMP_NUM_THREADS" ] \
##&& OMP_NUM_THREADS="4"
OMP_NUM_THREADS="4"

###
#Delly2, merge configuration.
##

#Size thresholds for Sturctural Variant merging. MINimal and MAXimal size of detectable SV.
##[ -z "$MIN_SIZE" ] \
##&& MIN_SIZE="500"
MIN_SIZE="500"
##[ -z "$MAX_SIZE" ] \
##&& MAX_SIZE="1000000"
MAX_SIZE="1000000"
#Minimal reciprocal overlap required between detected SV's to be merged into the same SV event.
##[ -z "$OVERLAP" ] \
##&& OVERLAP="0.8"
OVERLAP="0.8"
#Maximal breakpoint offset for overlapping SV.
##[ -z "$BP_OFFSET" ] \
##&& BP_OFFSET="500"
BP_OFFSET="500"
###
#REFERENCES
##
# [1] [Tobias Rausch, Thomas Zichner, Andreas Schlattl, Adrian M. Stuetz, Vladimir Benes, Jan O. Korbel. Delly: structural variant discovery by integrated paired-end and split-read analysis. Bioinformatics 2012 28: i333-i339.](https://academic.oup.com/bioinformatics/article/28/18/i333/245403/DELLY-structural-variant-discovery-by-integrated)
