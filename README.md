# mk-delly - pipeline for Germline Structural Variant detection.

### Abreviations:
**SVs**: Structural Variants

## About mk-delly

The mk-delly pipeline uses Delly2 to detect 5 types of Germline SVs:

- DUPlications
- DELetions
- INSertions
- TRAnslocations
- INVertions

Delly 2 is an integrated structural variant prediction method that can discover and genotype deletions, tandem duplications, inversions, small insertions, and translocations at single-nucleotide resolution in short-read massively parallel sequencing data.

The mk-delly pipeline takes multiple BAM files (SAM - Sequence Allignment Map- data in compressed format) as input; then, implementing Delly2, it uses paired-ends and split-reads to sensitively and accurately delineate genomic rearrangements by comparison against the same reference genome used to generate the BAM files.

Since each type of SV is detected diferently by Delly2, the mk-delly pipeline performs separate detection for all 5 types of SV, producing a final bcf (compressed vcf format) for each type.

IMPORTANT NOTE: mk-delly pipeline detects only Germline SVs (there is no module for Somatic SVs detection; for Somatic SV detection see [Delly2](https://github.com/dellytools/delly)).

## Pipeline configuration.

### Dependencies:
**[Delly2](https://github.com/dellytools/delly)**

IMPORTANT NOTE: Delly2 must be installed in multi-threading mode, and should me called by `delly-parallel` command.

Delly2 development and installation instructions can be found at: [https://github.com/dellytools/delly](https://github.com/dellytools/delly).

Delly2 publication can be found at: [ Rausch, T., Zichner, T., Schlattl, A., Stütz, A. M., Benes, V., & Korbel, J. O. (2012). DELLY: structural variant discovery by integrated paired-end and split-read analysis. Bioinformatics, 28(18), $

**[BCFtools](https://samtools.github.io/bcftools/)**

IMPORTANT NOTE: BCFtools should be called by `bcftools` command.

BCFtools development and installation instructions can be found at: [https://samtools.github.io/bcftools/](https://samtools.github.io/bcftools/).

### Input files

mk-delly requires:
1) Multiple BAM files with .bai index. Sample files must located at mk-delly/data/
1) A common .fasta file for the reference genome, the same version used to generate the sample .bam files. Reference genome files must be located at mk-delly/reference/

### Configuration file

This pipeline includes a config.mk file (located at mk-delly/config.mk), where you can adjust the following paramters:

PATH: path to search for executable files.

REF: path to reference genome.

MIN_LONG: SVs must span at least this number of base pairs to be reported by Delly2. (Delly2 recomendation is 500).

MAX_LONG: SVs greater than this number of base pair won't be reported by Delly2. (Delly2 recomendation is 1000000).

OVERLAP: fraction of reciprocal overlap required by same type SVs to consider them the same event.  (dbVAR recomendation is 0.8, meaning 80% reciprocal overlap).

## Module description.

### 001 -> Multisample SV calling, and SV merging by reciprocal overlaping of SV events.

Multi-sample SV calling is required to detect every posible SV event in a set of given samples. Since structural variation is not always detected spanning precisely the same nucleotides in every sample, it is necessary to perform a merge of overlaping SV events to collapse multiple closely detected events into a single SV genomic region.

Module 001 takes multiple .bam files and performs multi-sample SV calling using `delly-parallel call` to increase sensitivity. For each input BAM file, Delly2 computes the default read-pair orientation and the paired-end insert size distribution characterized by the median and standard deviation of the library. Based on these parameters, Delly2 then identifies all discordantly mapped read-pairs that either have an abnormal orientation or an insert size greater than the expected range. Delly2 hereby focuses on uniquely mapping paired-ends and the default insert size cutoff for pairs of interest is three standard deviations from the median insert size. The paired-end clusters identified in the previous mapping analysis are interpreted as breakpoint-containing genomic intervals, which are subsequently screened for split-read support to fine map the genomic rearrangements at single-nucleotide resolution and to investigate the breakpoints for potential microhomologies and microinsertions. [1]

After SV calling, module 001 uses `delly-parallel merge` to detect closely located SV events, and merge them by reciprocal overlap.

### 002 -> Single sample Re-Genotyping using merged SVs file from 001 as guidance.

Sample Re-Genotyping is required to detect SVs focusing on the merged SV site list produced by the previous module. "The main reason to merge and re-genotype is to get accurate genotypes across the same loci in all samples" [[Tobias Rauch](https://github.com/dellytools/delly/issues/60)].

Module 002 takes .bam files and performs single sample SV calling using `delly-parallel call` for Re-Genotyping using a list of known SV sites. Technically speaking, SV calling is performed the same way as in module 001 (read-pair clustering followed by split-read mapping of breakpoints).

### 003 -> Bcf merging of Re-Genotyped samples from 002/, and Germline filtering.

Single sample Re-Genotyped .bcf files must be merged into a final .bcf file, finally the merged .bcf SV file is passed through a Germline variant filter that uses read-depth to filter SVs in a cohort of WGS samples.

Module 003 takes multiple single sample .bcf files and merges them into a multi-sample .bcf file using `bcftools merge`.

After sample merging, 003 applies `delly-parallel filter` in germline mode to compare read depth ratios between SV carriers and SV non-carriers. A SV is marked as PASS when its read depth ratio meet certain theoretical thresholds. [For more info click here](https://groups.google.com/forum/#!topic/delly-users/44_6F5pa9bI).

Final results are a BCF file for every SV type detected.

## mk-delly directory structure

```
mk-delly/
├── analysis
│   ├── 001
│   │   ├── bin
│   │   │   └── targets
│   │   ├── config.mk
│   │   ├── data -> ../../data
│   │   │   ├── SM-3MG3L_chr22.markdup.bam
│   │   │   ├── SM-3MG3L_chr22.markdup.bam.bai
│   │   │   ├── SM-3MG4P_chr22.markdup.bam
│   │   │   ├── SM-3MG4P_chr22.markdup.bam.bai
│   │   │   ├── SM-3MG5C_chr22.markdup.bam
│   │   │   ├── SM-3MG5C_chr22.markdup.bam.bai
│   │   │   ├── SM-3MG5E_chr22.markdup.bam
│   │   │   ├── SM-3MG5E_chr22.markdup.bam.bai
│   │   │   ├── SM-3MG6A_chr22.markdup.bam
│   │   │   └── SM-3MG6A_chr22.markdup.bam.bai
│   │   ├── mkfile
│   │   ├── README.md
│   │   ├── reference -> ../../reference
│   │   │   ├── 1000G_omni2.5.hg38.vcf.gz
│   │   │   ├── 1000G_omni2.5.hg38.vcf.gz.tbi
│   │   │   ├── 1000G_phase1.snps.high_confidence.hg38.vcf.gz
│   │   │   ├── 1000G_phase1.snps.high_confidence.hg38.vcf.gz.tbi
│   │   │   ├── Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz
│   │   │   ├── Axiom_Exome_Plus.genotypes.all_populations.poly.hg38.vcf.gz.tbi
│   │   │   ├── dbsnp_138.hg38.vcf.gz
│   │   │   ├── dbsnp_138.hg38.vcf.gz.tbi
│   │   │   ├── dbsnp_144.hg38.vcf.gz
│   │   │   ├── dbsnp_144.hg38.vcf.gz.tbi
│   │   │   ├── dbsnp_146.hg38.vcf.gz
│   │   │   ├── dbsnp_146.hg38.vcf.gz.tbi
│   │   │   ├── hapmap_3.3_grch38_pop_stratified_af.vcf.gz
│   │   │   ├── hapmap_3.3_grch38_pop_stratified_af.vcf.gz.tbi
│   │   │   ├── hapmap_3.3.hg38.vcf.gz
│   │   │   ├── hapmap_3.3.hg38.vcf.gz.tbi
│   │   │   ├── Homo_sapiens_assembly38.dict
│   │   │   ├── Homo_sapiens_assembly38.fasta
│   │   │   ├── Homo_sapiens_assembly38.fasta.64.alt
│   │   │   ├── Homo_sapiens_assembly38.fasta.amb
│   │   │   ├── Homo_sapiens_assembly38.fasta.ann
│   │   │   ├── Homo_sapiens_assembly38.fasta.bwt
│   │   │   ├── Homo_sapiens_assembly38.fasta.fai
│   │   │   ├── Homo_sapiens_assembly38.fasta.gz
│   │   │   ├── Homo_sapiens_assembly38.fasta.pac
│   │   │   ├── Homo_sapiens_assembly38.fasta.sa
│   │   │   ├── Homo_sapiens_assembly38.snap
│   │   │   │   ├── Genome
│   │   │   │   ├── GenomeIndex
│   │   │   │   ├── GenomeIndexHash
│   │   │   │   └── OverflowTable
│   │   │   ├── Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
│   │   │   ├── Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi
│   │   │   └── wgs_calling_regions.hg38.interval_list
│   │   └── results
│   ├── 002
│   │   ├── bin
│   │   │   └── targets
│   │   ├── config.mk -> ../001/config.mk
│   │   ├── data
│   │   │   ├── bams -> ../../001/data/
│   │   │   └── merged_bcf -> ../../001/results/
│   │   ├── Logs
│   │   │   ├── 24Sep2017_17_42_10.log
│   │   │   └── 24Sep2017_17_42_10.log.bkp
│   │   ├── mkfile
│   │   ├── README.md
│   │   ├── reference -> ../001/reference  [recursive, not followed]
│   │   └── results
│   │       ├── DEL
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DEL.bcf
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DEL.bcf.condor_err
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DEL.bcf.condor_log
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DEL.bcf.condor_out
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DEL.bcf.csi
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DEL.bcf
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DEL.bcf.condor_err
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DEL.bcf.condor_log
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DEL.bcf.condor_out
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DEL.bcf.csi
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DEL.bcf
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DEL.bcf.condor_err
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DEL.bcf.condor_log
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DEL.bcf.condor_out
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DEL.bcf.csi
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DEL.bcf
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DEL.bcf.condor_err
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DEL.bcf.condor_log
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DEL.bcf.condor_out
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DEL.bcf.csi
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DEL.bcf
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DEL.bcf.condor_err
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DEL.bcf.condor_log
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DEL.bcf.condor_out
│   │       │   └── SM-3MG6A_chr22.markdup.delly_regenotyped.DEL.bcf.csi
│   │       ├── DUP
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DUP.bcf
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DUP.bcf.condor_err
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DUP.bcf.condor_log
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DUP.bcf.condor_out
│   │       │   ├── SM-3MG3L_chr22.markdup.delly_regenotyped.DUP.bcf.csi
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DUP.bcf
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DUP.bcf.condor_err
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DUP.bcf.condor_log
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DUP.bcf.condor_out
│   │       │   ├── SM-3MG4P_chr22.markdup.delly_regenotyped.DUP.bcf.csi
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DUP.bcf
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DUP.bcf.condor_err
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DUP.bcf.condor_log
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DUP.bcf.condor_out
│   │       │   ├── SM-3MG5C_chr22.markdup.delly_regenotyped.DUP.bcf.csi
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DUP.bcf
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DUP.bcf.condor_err
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DUP.bcf.condor_log
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DUP.bcf.condor_out
│   │       │   ├── SM-3MG5E_chr22.markdup.delly_regenotyped.DUP.bcf.csi
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DUP.bcf
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DUP.bcf.condor_err
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DUP.bcf.condor_log
│   │       │   ├── SM-3MG6A_chr22.markdup.delly_regenotyped.DUP.bcf.condor_out
│   │       │   └── SM-3MG6A_chr22.markdup.delly_regenotyped.DUP.bcf.csi
│   │       └── INV
│   │           ├── SM-3MG3L_chr22.markdup.delly_regenotyped.INV.bcf
│   │           ├── SM-3MG3L_chr22.markdup.delly_regenotyped.INV.bcf.condor_err
│   │           ├── SM-3MG3L_chr22.markdup.delly_regenotyped.INV.bcf.condor_log
│   │           ├── SM-3MG3L_chr22.markdup.delly_regenotyped.INV.bcf.condor_out
│   │           ├── SM-3MG3L_chr22.markdup.delly_regenotyped.INV.bcf.csi
│   │           ├── SM-3MG4P_chr22.markdup.delly_regenotyped.INV.bcf
│   │           ├── SM-3MG4P_chr22.markdup.delly_regenotyped.INV.bcf.condor_err
│   │           ├── SM-3MG4P_chr22.markdup.delly_regenotyped.INV.bcf.condor_log
│   │           ├── SM-3MG4P_chr22.markdup.delly_regenotyped.INV.bcf.condor_out
│   │           ├── SM-3MG4P_chr22.markdup.delly_regenotyped.INV.bcf.csi
│   │           ├── SM-3MG5C_chr22.markdup.delly_regenotyped.INV.bcf
│   │           ├── SM-3MG5C_chr22.markdup.delly_regenotyped.INV.bcf.condor_err
│   │           ├── SM-3MG5C_chr22.markdup.delly_regenotyped.INV.bcf.condor_log
│   │           ├── SM-3MG5C_chr22.markdup.delly_regenotyped.INV.bcf.condor_out
│   │           ├── SM-3MG5C_chr22.markdup.delly_regenotyped.INV.bcf.csi
│   │           ├── SM-3MG5E_chr22.markdup.delly_regenotyped.INV.bcf
│   │           ├── SM-3MG5E_chr22.markdup.delly_regenotyped.INV.bcf.condor_err
│   │           ├── SM-3MG5E_chr22.markdup.delly_regenotyped.INV.bcf.condor_log
│   │           ├── SM-3MG5E_chr22.markdup.delly_regenotyped.INV.bcf.condor_out
│   │           ├── SM-3MG5E_chr22.markdup.delly_regenotyped.INV.bcf.csi
│   │           ├── SM-3MG6A_chr22.markdup.delly_regenotyped.INV.bcf
│   │           ├── SM-3MG6A_chr22.markdup.delly_regenotyped.INV.bcf.condor_err
│   │           ├── SM-3MG6A_chr22.markdup.delly_regenotyped.INV.bcf.condor_log
│   │           ├── SM-3MG6A_chr22.markdup.delly_regenotyped.INV.bcf.condor_out
│   │           └── SM-3MG6A_chr22.markdup.delly_regenotyped.INV.bcf.csi
│   └── 003
│       ├── bin
│       │   └── targets
│       ├── condor.header
│       ├── condor.sub
│       ├── config.mk -> ../001/config.mk
│       ├── data -> ../002/results/  [recursive, not followed]
│       ├── Logs
│       │   ├── 24Sep2017_17_59_55.log
│       │   └── 24Sep2017_17_59_55.log.bkp
│       ├── mkfile
│       ├── README.md
│       └── results
│           ├── DEL.delly_germline.bcf
│           ├── DEL.delly_germline.bcf.condor_err
│           ├── DEL.delly_germline.bcf.condor_log
│           ├── DEL.delly_germline.bcf.condor_out
│           ├── DEL.delly_germline.bcf.csi
│           ├── DEL.merged.bcf
│           ├── DEL.merged.bcf.csi
│           ├── DUP.delly_germline.bcf
│           ├── DUP.delly_germline.bcf.condor_err
│           ├── DUP.delly_germline.bcf.condor_log
│           ├── DUP.delly_germline.bcf.condor_out
│           ├── DUP.delly_germline.bcf.csi
│           ├── DUP.merged.bcf
│           ├── DUP.merged.bcf.csi
│           ├── INV.delly_germline.bcf
│           ├── INV.delly_germline.bcf.condor_err
│           ├── INV.delly_germline.bcf.condor_log
│           ├── INV.delly_germline.bcf.condor_out
│           ├── INV.delly_germline.bcf.csi
│           ├── INV.merged.bcf
│           └── INV.merged.bcf.csi
├── data -> /home/iaguilar/BKP/Bams_for_testing  [recursive, not followed]
├── notes
├── README.md
└── reference -> /reference/ftp.broadinstitute.org/bundle/hg38/  [recursive, not followed]
```

### References
[1] [Tobias Rausch, Thomas Zichner, Andreas Schlattl, Adrian M. Stuetz, Vladimir Benes, Jan O. Korbel. Delly: structural variant discovery by integrated paired-end and split-read analysis. Bioinformatics 2012 28: i333-i339.](https://academic.oup.com/bioinformatics/article/28/18/i333/245403/DELLY-structural-variant-discovery-by-integrated)
