# ClinSig-V2
This repository contains version 2 of the "ClinSig" program, a Shiny application developed in RStudio that visualizes clinical variants from the NCBI ClinVar database in a lollipop plot format according to their clinical significance.

Version 2 Enhancements:
*Some errors that occurred during data manipulation were fixed.
*Processing times for generating the lollipop plots were optimized.
The key changes in Version 2 include:
*Errors in the data manipulation step during conversion of text files to CSV format were resolved.
*Performance improvements were made to reduce processing times for generating the interactive lollipop plots from the input variant data.

How to Use?
1. Search ClinVar database for the gene of clinical interest and download all variants as a text file.
2. Load required R libraries.
3. Run the data_manipulation.R script to select the text file and generate a my_data.csv file.
4. Load libraries again and run the Lollipop_plot_shiny.R script.
5. In the Shiny app screen, upload the my_data.csv file and click submit to generate an interactive lollipop plot of the variants.
