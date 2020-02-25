# circRNA-finder
***
This repository is my attempt at converting [circSeq](http://bioinformaticstools.mayo.edu/research/circ-seq/) from SGE to a SLURM compatible nextflow pipeline. 

The ultimate goal is to:
  * Take TCGA bam files and perform circSeq analysis on them
  * Convert the bam files to fastq R1, fastq R2 files
  * Run the reads through CIRIquant
  * Store bams as cram, remove fastq files after use
  
Calculate computational cost if being sent to ICHEC
