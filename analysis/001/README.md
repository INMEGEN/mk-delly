# mk-delly module 001 - pipeline for Germline Structural Variant detection.

## Software dependencies
**[Delly2](https://github.com/dellytools/delly)**

IMPORTANT NOTE: Delly2 must be installed in multi-threading mode, and should me called by `delly-parallel` command.

## Module objective
This module performs a first aproach to Structural Variant (SV) calling using Delly2.
SV Calling is done using multiple samples at the same time to increase sensitivity and SV breakpoint precision.

After the first calling, detected SVs of the same type (DEL, DUP, INV, INS, TRA) can span slightly different lengths between individuals;
following recomendations of the Database of Genomic Variants, a reciprocal overlap of at least 70% in length between same-type SVs can be used to collapse multiple closely located SVs into a single region for a SV event [1].

This module performs SVs collapsing by reciprocal overlap using Delly2 merge tool. The resulting list of same-type SV events can be used as a reference for posterior modules of this pipeline, to focus SV calling at regions of interest.

## Input data format
This module needs a sorted and indexed BAM file for every sample. Prior duplicate marking of input BAM files is recommended. Module has been sucessfuly tested with BAM files produced by SNAP alligner.

Naming of input files should follow the convention "sampleID.bam", and the corresponding "sampleID.bai".

Input BAM and indexes must be located inside mk-delly/data/

A reference genome fasta file is also needed. It must be the same reference used to generate the analyzed BAM files.

Reference genome files must be located inside mk-delly/reference/

## Output data format
For every SV-type (DEL, DUP, INV, INS, TRA) the output is a BCF file with a .csi index. Each BCF file lists SVs events in regions of interest. No sample-level data is included in this file.

## Default parameters and references
Describe design considerations: the motives and references from which default parameters were selected.
TO-DO

## References
[1] [Tobias Rausch, Thomas Zichner, Andreas Schlattl, Adrian M. Stuetz, Vladimir Benes, Jan O. Korbel. Delly: structural variant discovery by integrated paired-end and split-read analysis. Bioinformatics 2012 28: i333-i339.](https://academic.oup.com/bioinformatics/article/28/18/i333/245403/DELLY-structural-variant-discovery-by-integrated)

### Author Info
Developed by [Israel Aguilar](https://www.linkedin.com/in/israel-aguilar-ba625949/) (iaguilaror@gmail.com) for [Winter Genomics](http://www.wintergenomics.com/), by request of [INMEGEN](http://www.inmegen.gob.mx/). 2017.
