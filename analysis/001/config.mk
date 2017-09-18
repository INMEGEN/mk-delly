#Same castillo PATH
PATH=/castle/cfresno/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/plan9/bin:/usr/bin/

#Directorio del genoma de referencia
REF="reference/Homo_sapiens_assembly38.fasta"

#Delly2 parametrization
#Number of threads to run parallel Delly2
OMP_NUM_THREADS="4"

#Longitud mínima/máxima de eventos registrados
MIN_LONG="500"
MAX_LONG="1000000"

#Longitud recíproca para eventos similares
OVERLAP="0.8"