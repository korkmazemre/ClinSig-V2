library(shiny)
library(trackViewer)

ui <- fluidPage(
  titlePanel("Track Viewer"),
  
  sidebarLayout(
    sliderInput("range", "Select a range:",
                min = 1, max = 1300,
                value = c(1, 1299),
                step = 1),
    
    radioButtons("scs", "Select Clinical Significance",
                 choices = list(if (is.numeric(mutationn_n[,"Variant_Classification"])) {paste("All (",sum(mutationn_n[,"Variant_Classification"]),")")}, 
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Uncertain_significance")) {paste("Uncertain_significance (",sum(mutationn_n[,"Variant_Classification"] == "Uncertain_significance"),")")} else {return("0")}, 
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Benign")) {paste("Benign (",sum(mutationn_n[,"Variant_Classification"] == "Benign"),")")} else {return("0")}, 
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Conflicting_interpretations_of_pathogenicity")) {paste("Conflicting_interpretations_of_pathogenicity (",sum(mutationn_n[,"Variant_Classification"] == "Conflicting_interpretations_of_pathogenicity"),")")} else {return("0")},
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Likely_pathogenic")) {paste("Likely_pathogenic (",sum(mutationn_n[,"Variant_Classification"] == "Likely_pathogenic"),")")} else {return("0")},
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Likely_benign")) {paste("Likely_benign (",sum(mutationn_n[,"Variant_Classification"] == "Likely_benign"),")")} else {return("0")},
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Benign/Likely_benign")) {paste("Benign/Likely_benign (",sum(mutationn_n[,"Variant_Classification"] == "Benign/Likely_benign"),")")} else {return("0")},
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Pathogenic")) {paste("Pathogenic (",sum(mutationn_n[,"Variant_Classification"] == "Pathogenic"),")")} else {return("0")},
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "risk_factor")) {paste("risk_factor (",sum(mutationn_n[,"Variant_Classification"] == "risk_factor"),")")} else {return("0")},
                                if (is.numeric(mutationn_n[,"Variant_Classification"] == "Pathogenic/Likely_pathogenic")) {paste("Pathogenic/Likely_pathogenic (",sum(mutationn_n[,"Variant_Classification"] == "Pathogenic/Likely_pathogenic"),")")} )),
    
    sidebarPanel(
      fileInput("file1", "Choose CSV file for GENE"),
      actionButton("submit", "Submit")
    )
    
  ),
    mainPanel(
      plotOutput("lollipopPlot")
    )
  )


server <- function(input, output) {
  
  data <- reactive({
    req(input$file1)
    read.csv(input$file1$datapath, header = TRUE, sep = ",")
  })
  
  observeEvent(input$submit, {
    data_table <- data()
    aaa <- data_table$aaa
    amino <- data_table$amino_acid_change
    clinical <- unique(data_table$Variant_Classification)
    sample.gr <- GRanges("chr1", IRanges(aaa, width=1, names=paste0("p.",amino)))
    features <- GRanges("chr1", IRanges(c(55,91,314), 
                                        width=c(34,49,38),
                                        names=paste0("WD40 repeat", 1:3)))
    features$fill <- c("#FF8833","#FF8833","#FF8833")
    sample.gr$color <- ifelse(data_table$Variant_Classification == "Uncertain_significance", "black", ifelse(data_table$Variant_Classification == "Pathogenic/Likely_pathogenic", "gray", ifelse(data_table$Variant_Classification == "Benign", "red", ifelse(data_table$Variant_Classification == "Conflicting_interpretations_of_pathogenicity","green", ifelse(data_table$Variant_Classification=="Likely_pathogenic","#40E0D0", ifelse(data_table$Variant_Classification=="Likely_benign","yellow", ifelse(data_table$Variant_Classification=="Benign/Likely_benign","blue", ifelse(data_table$Variant_Classification=="Pathogenic","purple", ifelse(data_table$Variant_Classification=="risk_factor","orange","white")))))))))
    legend <- list(labels=c("Uncertain_significance", "Benign", "Conflicting_interpretations_of_pathogenicity","Likely_pathogenic","Likely_benign","Benign/Likely_benign","Pathogenic","risk_factor","Pathogenic/Likely_pathogenic"), fill=c("black","red","green","#40E0D0","yellow","blue","purple","orange","gray"))
    output$lollipopPlot <- renderPlot({
      lolliplot(sample.gr, features, legend=legend, ranges = GRanges("chr1", IRanges(input$range[1], input$range[2])))
      grid.text("ClinVar Color Scale of Clinical Significance Values", x=.5, y=.60, just="top", 
                gp=gpar(cex=1.2))
      })
  })
}

shinyApp(ui, server)
