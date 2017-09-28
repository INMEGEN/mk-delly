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
For every SV-type (DE, DUP, INV, INS, TRA) the output is a BCF file with a .csi index. Each BCF file list SVs events in regions of interest. No sample-level data is included in this file.

## Default parameters and references
Describir Consideraciones de diseño: Los motivos y referencias por los que seleccionan los parámetros por defecto
TO-DO

## References
[1] [Database of Genomic Variants, FAQs ](http://dgv.tcag.ca/v106/app/faq#q4)