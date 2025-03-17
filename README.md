# Diploid-phylogenetics-Silene-sect.-Physolychnis-AmJBot
This repository includes scripts and associated input files used in the study "Phylogenetic relationships and the identification of allopolyploidy in circumpolar Silene sect. Physolychnis", accepted in AmJBot in march 2025. DOI upon publication.

For questions, contact asquatela@gmail.com with email subject "QUESTIONS Diploid-phylogenetics-Silene-sect.-Physolychnis-AmJBot" or used dedicated sections on Github.

It includes two folders:
- Folder "input files", with the following files:
    - FIGURE1_samples.csv is the input file of the script FIGURE1_distributionmap_final.R in folder "scripts". The csv file and script are meant to represent the samples distribution of circumpolar Silene sect. Physolychnis sequenced in the present study, in Figure 1.
    - FIGURE2_readdepth.csv is the input file of the script FIGURE2_readdepth_final.R in folder "scripts". The csv file and script are meant to represent a heatmap of the sequencing depth for each locus and each sample, in Figure 2.
    - FIGURE3_normalised_pairwise_dist.csv is one of the input files of the script FIGURE3_haplotype_genetic_distances_final.R used to represent the genetic pairwise distance between alleles for each sample, and also the percentage recovery of the on target length per sample, in Figure 3. FIGURE3_normalised_pairwise_dist.csv includes the normalised genetic distance between alleles, and is a modified version of the file "uralensis_stats.xlsx" made with the script "variants_count.sh" in folder "scripts".
    - FIGURE3_average_normalised_pairwise_dist.csv is one of the input files of FIGURE3_haplotype_genetic_distances_final.R in folder "scripts". This file is made by calculating the average normalised pairwise genetic distance per sample from the file FIGURE3_normalised_pairwise_dist.csv.
    - FIGURE3_recovery_avg.csv is one of the input files of FIGURE3_haplotype_genetic_distances_final.R in folder "scripts". It shows the percent target recovery calculated for each locus and sample by dividing the sequence length (i.e., number of called and non-masked nucleotides) by the alignment length. 
    - uralensis_stats.xlsx is the output of the python script "variants_count.sh" in folder "scripts". This file is used to create the file FIGURE3_normalised_pairwise_dist.csv.
    
- Folder "scripts", with the following files:
    - FIGURE1_distributionmap_final.R shows the distribution of the samples sequenced in the study.
    - FIGURE2_readdepth_final.R shows the read depth per locus and per sample.
    - FIGURE3_haplotype_genetic_distance_final.R shows the genetic distance between haplotype per sample. When pairwise genetic distance > 0.5, the sample is considered allopolyploid and removed from further analyses.
    - variants_count.sh is a python script used to calculate the pairwise genetic distance. Multiple alignments are input files.



