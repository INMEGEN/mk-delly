# mk-delly - pipeline for Structural Variant detection.

### Abreviations:
**SVs**: Structural Variants

### Dependencies:
**[Delly2](https://github.com/dellytools/delly)**
**[bcftools](https://samtools.github.io/bcftools/)**

## About Delly2.

Delly2 development and installation instructions can be found at: [https://github.com/dellytools/delly](https://github.com/dellytools/delly)
Delly2 publication can be found at: [Rausch, T., Zichner, T., Schlattl, A., Stütz, A. M., Benes, V., & Korbel, J. O. (2012). DELLY: structural variant discovery by integrated paired-end and split-read analysis. Bioinformatics, 28(18), i333-i339.](https://academic.oup.com/bioinformatics/article/28/18/i333/245403/DELLY-structural-variant-discovery-by-integrated)
This pipeline uses Delly2 to detect 5 types of SVs:

- DUPlications
- DELetions
- INSertions
- TRAnslocations
- INVertions

Delly 2 is an integrated structural variant prediction method that can discover and genotype deletions, tandem duplications, inversions, small insertions, and translocations at single-nucleotide resolution in short-read massively parallel sequencing data.

The mk-delly pipeline takes BAM files (SAM - Sequence Allignment Map- data in compressed format) as input; then it uses paired-ends and split-reads to sensitively and accurately delineate genomic rearrangements by
comparison against the same reference genome used to generate the BAM files.

Each type of SV is detected diferently by Delly2; the mk-delly pipeline performs detection for all 5 types of SV, producing a bcf (compressed vcf format) for each type.

## Pipeline configuration.

### Input files

mk-delly requires:
1) .bam files with .bai, that must be located at 001/data.
1) .fasta file for the reference genome, the same version used to generate the .bam files.

### Configuration file

This pipeline includes a config.mk file, where you can adjust the following paramters:

PATH: path to search for executable files.
REF: path to reference genome.
MIN_LONG: SVs must span at least this number of base pairs to be reported by Delly2. (Delly2 recomendation is 500).
MAX_LONG: SVs greater than this number of base pair won't be reported by Delly2. (Delly2 recomendation is 1000000).
OVERLAP: fraction of reciprocal overlap required by same type SVs to consider them the same event.  (dbVAR recomendation is 0.8, meaning 80% reciprocal overlap).

## Module description.

- 001 -> Takes multiple .bam files and performs multisample Stuctural Variant Calling, then merges SVs by reciprocal overlaping, and finally applies a germline filter to evaluate SVs of confidence. Results are a BCF file per every SVs type detected.

# **TO DO**
- [ ] Solve 001/mkfile error when trying to apply germline filter. (this does not affect SV calling, nor SV merging)
- [ ] Include a module that generates graphics for results interpretation.
