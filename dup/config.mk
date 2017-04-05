#Same castillo PATH
PATH=/castle/cfresno/.bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/plan9/bin:/usr/bin/

#GATK directory
GATK="/usr/share/java/GenomeAnalysisTK3.7.jar"

#Directorio del genoma de referencia
REF="/100g/references/human-reference/v37_decoy/human_g1k_v37_decoy.fasta"

#Directorio con variantes de confianza
VARIANTS="/100g/references/reference_variants-gatk/1000G_phase1.indels.b37.vcf"

#Number of threads for GATK
NT="1"

#Delly2 parametrization
#Number of threads to run parallel Delly2
OMP_NUM_THREADS="8"

#Longitud mínima/máxima de eventos registrados
MIN_LONG="500"
MAX_LONG="1000000"

#Longitud recíproca para eventos similares
OVERLAP=0.8

