ui <- fluidPage(
  titlePanel("Expression in Nudt7 Knockout Mice"),
  
  sidebarLayout(
    sidebarPanel(

      fileInput("datafile", "Upload Datafile"),
      
      selectInput("XInput", "X",
                  choices = c('Feed','Genotype','Sex','Group'),
                  selected = "Sex"),
      selectInput("YInput", "Y",
                  choices = c('Feed','Genotype','Sex','Group'),
                  selected = "Genotype"),
      selectInput("SplitInput", "Split",
                  choices = c('Feed','Genotype','Sex','Group'),
                  selected = "Feed"),

      selectInput("unitInput", "Expression",
                  choices = c('TPM','Normalized Counts'),
                  selected = "TPM"),

      uiOutput("geneOutput")
#            selectInput("geneInput", "Gene",
#                  choices = sort(data$GeneName),
#                  selected = "Nudt7")
      
    ),
    
    # Main Panel    
    mainPanel(
      plotOutput("mainplot"),

    )
  )
)

