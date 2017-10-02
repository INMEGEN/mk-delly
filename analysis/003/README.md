# mk-delly module 003 - pipeline for Germline Structural Variant detection.

## Software dependencies
**[Delly2](https://github.com/dellytools/delly)**

IMPORTANT NOTE: Delly2 must be installed in multi-threading mode, and should me called by `delly-parallel` command.

## Module objective
This module takes a group of BCF files from samples Re-Genotyped using Delly2, and merges them into a multi-sample BCF file. Said file is then filtered using Delly2 filtering tool, a Germline filter is applied to check read-depth to filter SVs in a cohort of WGS samples.

Module 003 uses `delly-parallel filter` in germline mode to compare read depth ratios between SV carriers and SV non-carriers. A SV is marked as PASS when its read depth ratio meet certain theoretical thresholds. [For more info click here](https://groups.google.com/forum/#!topic/delly-users/44_6F5pa9bI).

Final results are a BCF file for every SV type detected.

## Input data format
This module needs a Re-Genotyped Structural Variants BCF file for every sample. Module has been sucessfuly tested with Re-Genotyped BCF files produced mk-delly module 002.

Naming of input files should follow the convention "sampleID.delly_regenotyped.SV-TYPE.bcf" (where SV-TYPE can be DEL, DUP, INS, INV or TRA), and the corresponding .bai index.

Input BCF and indexes must be located at their corresponding directory inside mk-delly/analysis/002/results/SV-TYPE/ (where SV-TYPE can be DEL, DUP, INS, INV or TRA).

## Output data format

The final output for module 003 is a BCF file for every SV-type detected. 

Integrated information in the final BCF file includes:
##FILTER=<ID=LowQual,Description="PE/SR support below 3 or mapping quality below 20.">
##INFO=<ID=CIEND,Number=2,Type=Integer,Description="PE confidence interval around END">
##INFO=<ID=CIPOS,Number=2,Type=Integer,Description="PE confidence interval around POS">
##INFO=<ID=CHR2,Number=1,Type=String,Description="Chromosome for END coordinate in case of a translocation">
##INFO=<ID=END,Number=1,Type=Integer,Description="End position of the structural variant">
##INFO=<ID=PE,Number=1,Type=Integer,Description="Paired-end support of the structural variant">
##INFO=<ID=MAPQ,Number=1,Type=Integer,Description="Median mapping quality of paired-ends">
##INFO=<ID=SR,Number=1,Type=Integer,Description="Split-read support">
##INFO=<ID=SRQ,Number=1,Type=Float,Description="Split-read consensus alignment quality">
##INFO=<ID=CONSENSUS,Number=1,Type=String,Description="Split-read consensus sequence">
##INFO=<ID=CE,Number=1,Type=Float,Description="Consensus sequence entropy">
##INFO=<ID=CT,Number=1,Type=String,Description="Paired-end signature induced connection type">
##INFO=<ID=IMPRECISE,Number=0,Type=Flag,Description="Imprecise structural variation">
##INFO=<ID=PRECISE,Number=0,Type=Flag,Description="Precise structural variation">
##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">
##INFO=<ID=SVMETHOD,Number=1,Type=String,Description="Type of approach used to detect SV">
##INFO=<ID=INSLEN,Number=1,Type=Integer,Description="Predicted length of the insertion">
##INFO=<ID=HOMLEN,Number=1,Type=Integer,Description="Predicted microhomology length using a max. edit distance of 2">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=GL,Number=G,Type=Float,Description="Log10-scaled genotype likelihoods for RR,RA,AA genotypes">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
##FORMAT=<ID=FT,Number=1,Type=String,Description="Per-sample genotype filter">
##FORMAT=<ID=RC,Number=1,Type=Integer,Description="Raw high-quality read counts for the SV">
##FORMAT=<ID=RCL,Number=1,Type=Integer,Description="Raw high-quality read counts for the left control region">
##FORMAT=<ID=RCR,Number=1,Type=Integer,Description="Raw high-quality read counts for the right control region">
##FORMAT=<ID=CN,Number=1,Type=Integer,Description="Read-depth based copy-number estimate for autosomal sites">
##FORMAT=<ID=DR,Number=1,Type=Integer,Description="# high-quality reference pairs">
##FORMAT=<ID=DV,Number=1,Type=Integer,Description="# high-quality variant pairs">
##FORMAT=<ID=RR,Number=1,Type=Integer,Description="# high-quality reference junction reads">
##FORMAT=<ID=RV,Number=1,Type=Integer,Description="# high-quality variant junction reads">

## Default parameters and references
Describe design considerations: the motives and references from which default parameters were selected.
TO-DO

## References
[1] [Tobias Rausch, Thomas Zichner, Andreas Schlattl, Adrian M. Stuetz, Vladimir Benes, Jan O. Korbel. Delly: structural variant discovery by integrated paired-end and split-read analysis. Bioinformatics 2012 28: i333-i339.](https://academic.oup.com/bioinformatics/article/28/18/i333/245403/DELLY-structural-variant-discovery-by-integrated)

### Author Info
Developed by [Israel Aguilar](https://www.linkedin.com/in/israel-aguilar-ba625949/) (iaguilaror@gmail.com) for [Winter Genomics](http://www.wintergenomics.com/), by request of [INMEGEN](http://www.inmegen.gob.mx/). 2017.
