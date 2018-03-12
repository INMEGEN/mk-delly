### This module constructs a cricos plot for Structural Variants detected by Delly2.

### Input files are population .bcf files, one forevery SV type detected by Delly2.

### Intermediate format to plot the Circos is:
Chromosome	Start	End	Region_id	Strand	AC	Region_length
chr1	1000	1200	DEL00001	+	28	201

### missing data filter will be set to >= 186 in config.mk file
