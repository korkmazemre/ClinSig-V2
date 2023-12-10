library(dplyr)
library(data.table)
library(tidyverse)
library(haven)
library(stringr)

file <- file.choose()
mutationn1 <- read.delim(file, sep = "\t",header=TRUE)
mutationn1 <- as.data.frame(mutationn1)
mutationn_n <- mutationn1 %>% 
  separate_rows(Protein.change, sep = ",") %>%
  rename(amino_acid_change = Protein.change)
dim1 <- nrow(mutationn_n)
mutationn_n <- mutationn_n[mutationn_n$amino_acid_change != "", ]
if (dim1 != nrow(mutationn_n)) {
  warning("Some rows containing empty values in the 'amino_acid_change' column have been removed.")
}
mutationn_n <- mutationn_n[, c("amino_acid_change","Clinical.significance..Last.reviewed.","Gene.s.")]
mutationn_n$Clinical.significance..Last.reviewed. <- gsub("(?=La).*", "", mutationn_n$Clinical.significance..Last.reviewed., perl = TRUE)
mutationn_n$Variant_Classification <- gsub("[(]", "", mutationn_n$Clinical.significance..Last.reviewed.)
mutationn_n$Variant_Classification <- gsub(" ", "_", mutationn_n$Variant_Classification)
mutationn_n$Gene.s.<- str_replace_all(mutationn_n$Gene.s., "[^[:alnum:]]", "")
mutationn_n$Hugo_Symbol <- gsub("LOC105371046", "", mutationn_n$Gene.s.)
mutationn_n <- mutationn_n[, c("amino_acid_change","Variant_Classification","Hugo_Symbol")]
mutationn_n$aaa <- as.numeric(gsub("[^[:digit:]]", "", mutationn_n$amino_acid_change))
unique_classification <- unique(mutationn_n$Variant_Classification)
colorss <- rainbow(length(unique_classification))
names(colorss) <- unique_classification
mutationn_n$colorss <- colorss[mutationn_n$Variant_Classification]
write.csv(mutationn_n, file = "my_data2.csv",sep = ",",row.names = FALSE, quote = FALSE)