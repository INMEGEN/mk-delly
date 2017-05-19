# Delly2 pipeline for Structural Variant detection

### Abreviations:
**SV**: Structural Variants

## Pipeline detects 5 types of structural variation:

- DUPlications
- DELetions
- INSertions
- TRAnslocations
- INVertions

### Each type of detections is performed in a separate module (a separate dir named after the first three letters of the event; e.g. **DUP**lications are detected with the code in the **DUP** diectory).
Every module works in 4 stages:

- 001 -> SV calling by groups of samples. Works in batches of X number of .bam files, increasing sensibility o variant calling. Results are one BCF file per batch of .bams analized.

- 002 -> Collapses BCF files from stage 001, to merge Structural Variants detected by delly call. Result is a single .bcf file for all of the detected events.

- 003 -> SV recalling of all the same original .bam samples from 001, but using the .bcf file resulting from 002. Results are a recalled .bcf file for every .bam sample in 001/data, containing a sample level refined variant call for SV.

- 004 -> bcftools merging of every sample.bcf from 003/results. Then, delly aplies a germline filter to refine SV calling.

# Execution
STAGE 001
0. Go into the directory of the SV you want to call.
1. Go into stage 001 directory.
1a. Create data/ results/ and tmp/ directories if not already present.
2. Create symlink from your bams directory to 001/data/bams
3. execute mk all

STAGE 002
4. Go into stage 002.
4a. Create results/ and tmp/ directories if not already present.
5. Create symlink from ../001/results to 002/data
6. Execute bash bin/mkfile_generator.sh
7. Execute mk all

STAGE 003
8. Go into stage 003.
9. Create results/ and tmp/ directories if not already present.
10. Create symlinks with full paths from ../001/data/bams to data/bams (symlink MUST BE DECLARED WITH FULL PATH).
11. Create symlinks with full paths from ../002/results to data/merge (symlink MUST BE DECLARED WITH FULL PATH).
12. Execute mk all.

SATGE 004
13. Go into stage 004.
14. Create results/ and tmp/ directories if not already present.
15. Create symlink from ../003/results to 004/data.
16. Execute mk all.

# **TO DO**
- [ ] Describe how to setup the pipeline for automated function. At this moments, it requires to manually create symlinks, and run bin/mkfile_generator.sh at every 002 stage. Could this be automatized?
- [ ] Test INS and TRA detection. First test failed because sample .bams did not present such structural variation. Needs to be tested with more samples, or control samples.
- [ ] Include a 005 module in every SV type directory. 005 module will annotate SV in the .bcf file from 004, using VEP-ensembl console version.
- [ ] Include a 006 module in every SV type directory. 006 module will generate graphics for results interpretation.
