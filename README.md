#Delly2 pipeline for Structural Variant detection

###Abreviations:
**SV**: Structural Variants

##Pipeline detects 5 types of structural variation:

-DUPlications
-DELetions
-INSertions
-TRAnslocations
-INVertions

###Each type of detections is performed in a separate module (a separate dir named after the first three letters of the event; e.g. **DUP**lications are detected with the code in the **dup** diectory).
Every module works in 3 stages:

001 -> SV calling by groups of samples. Works in batches of X number of .bam files, increasing sensibility o variant calling. Results are one BCF file per batch of .bams analized.
002 -> Collapses BCF files from 001, to merge Structural Events detected by delly call. Result is a single .bcf file for all detected events.
003 -> SV recalling of all the same original .bam samples from 001, but using the .bcf file resulting from 002. Result is a single .bcf file, containing a refined variant call for SV.


#**TO DO**
- [ ] Include a 004 module in every SV type directory. 004 module will annotate SV in the .bcf file from 003, using VEP-ensembl console version.
- [ ] Include a 005 module in every SV type directory. 005 module will generate graphics for results interpretation.

