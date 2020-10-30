## Pool Deconvolution of HIF1A mixing experiments

source("https://bioconductor.org/biocLite.R")
biocLite("edgeR")
library(edgeR)

## setwd("*/HIF1A_sequencing")

#sample1
sample1 = processAmplicons("HIF3-input_S2_L001_R1_001.fastq", barcodefile = "Samples_barcodes.txt", hairpinfile = "inputhairpins.txt", 
                                   hairpinStart = 26, hairpinEnd = 82, 
                                   barcodeStart = 216, barcodeEnd = 217,
                                   allowShifting = TRUE, shiftingBase = 5,
                                   allowMismatch = TRUE, barcodeMismatchBase = 2, hairpinMismatchBase = 4, 
                                   allowShiftedMismatch = TRUE, verbose = TRUE)

x = ((sample1$counts) >= 1)

sample1_filter = sample1[x, ]

sample1_counts_filtered = sample1_filter$counts

write.csv(sample1_counts_filtered, file = "sample1.csv")

## repeat sample 1 for as many samples as needed

## setwd('*/csv') #set this to wherever you're keeping the files. Make sure you only keep
#the .csvs you want analyzed in that folder, since this will analyze any .csv's present
temp = list.files(pattern="*.csv") #ID the files you want
myfiles = lapply(temp, read.csv) #import them into a list

for (i in 1:length(temp)) { 
  file <-as.data.frame(myfiles[i]) #pick the file we want to work on
  total <-sum(file[,2]) #get the sum of the P1 column
  file$Percent<-round(file$P1/total*100,digits=1) #percent, rounded to nearest decimal place
  filename <-paste('OUTPUT',temp[i],sep=" ")
  write.csv(file,filename )#write out the file to your current directory
  }
