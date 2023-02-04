#Download European Corn Borer genome
curl -L -o ecb_genome.fa.gz 
https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/008/921/685/GCA_008921685.1_ASM892168v1/GCA_008921685.1_ASM892168v1_genomic.fna.gz
gunzip ecb_genome.fa.gz

#create Blast database
makeblastdb -in ecb_genome.fa -dbtype nucl -title ecb_ASM892168v1 -out ecb 

#Get O. furnacalis ABCC2 fasta
curl -L -o MN783372_abcc2_complete.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=MN783372.1&rettype=fasta"

#Blast the ecb genome for ABCC2
blastn -db ecb -query MN783372_abcc2_complete.fasta -out abcc2_to_ecb_genome.out -evalue 1 -outfmt "6 sseqid qstart qend sstart send evalue length pident" 

sort -gk 4,4 abcc2_to_ecb_genome.out | awk 'BEGIN {OFS="\t"} {print $1,$2,$3,$5,$4,$6,$7,$8,$9}' > aligned_regions_sorted.txt

#create bed file to extract regions of interest
awk 'BEGIN {OFS="\t"} {print $1,$4,$5}' aligned_regions_sorted.txt > regions_to_extract.bed

#extract regions of interest
bedtools getfasta -fi ecb_genome.fa -fo abcc2_regions.fa -bed regions_to_extract.bed -name

#create new bed file with extreme gene coordinates plus/minus 300 bp on each end for primer design.
bedtools getfasta -fi ecb_genome.fa -fo abcc2_whole_gene_plus20.fa -bed whole_gene_plus300.bed -name



