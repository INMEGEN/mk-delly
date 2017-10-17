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
