## Threshold value to filter by missing data
## Defined as the minimum number of alleles in which the region was evalluated (either as REF or ALT)
## AN filter is applied with a logic of: AN >= $AN_THRESHOLD
## A value of AN_THRESHOLD=186 means the allele must have a called genotype in at least 186/2 individuals
AN_THRESHOLD="186"
