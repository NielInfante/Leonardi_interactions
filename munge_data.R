library(tidyverse)
library(DESeq2)
library(tximport)
#library(cowplot)
#library(gridExtra)

setwd('c://Users/nieli/projects/Leonardi/')


tx2gene <- read_tsv('Data/IDs')

metadata <- read_tsv('Data/meta.txt')
metadata$Sex <- as.factor(metadata$Sex)
metadata$Genotype <- as.factor(metadata$Genotype)
metadata$Feed <- as.factor(metadata$Feed)
metadata$Group <- as.factor(metadata$Group)

outPrefix <- 'All'
PCA_Group <- 'Group'
design =~ Genotype + Sex + Feed + Genotype:Sex + Genotype:Feed + Sex:Feed + Genotype:Sex:Feed
design =~ Genotype + Sex + Feed + Genotype:Sex 
contrast <- c('Group', 'C', 'D')

samples <- metadata$Sample

files <- paste0('salmon/', samples, '/quant.sf')

print("Files are:")
print(files)

txi <- tximport(files, type='salmon', tx2gene = tx2gene)

dds <- DESeqDataSetFromTximport(txi, metadata, design)

dds <- dds[rowSums(counts(dds)) > 0,]
keep <- rowSums(counts(dds) >= 10) >= 3
dds <- dds[keep,] # filter them out

dds <- DESeq(dds)

tpm <- as.data.frame(txi$abundance)
names(tpm) <- paste0(samples, '_TPM')
tpm$meanTPM <- rowMeans(tpm)
tpm$GeneID <- row.names(tpm)


# Add count data
cnt <- as.data.frame(counts(dds, normalized=T))
names(cnt) <- colData(dds)[,'Sample']
cnt$GeneID <- row.names(cnt)


# Add Biotypes
biotype <- read_tsv('Data/Biotype')
biotype <- left_join(biotype, tx2gene)

# Only need one transcript per gene
biotype <- biotype[!duplicated(biotype$GeneID),]



out <- inner_join(cnt, tpm)
out <- left_join(out, biotype)

sum(rowSums(out[1:32]) < 5000)
dim(out)

o2 <- out[rowSums(out[1:32]) > 6000,]
dim(o2)

write_tsv(o2, 'Data/expression.tsv')




names(out)




