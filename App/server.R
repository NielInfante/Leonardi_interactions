server <- function(input, output){
  
  # File upload
  full_data <- reactive({
    if(is.null(input$datafile)){
      return(NULL)
    }
    read_tsv(input$datafile$datapath)
  })
  
  # Gene list
  output$geneOutput <- renderUI({
    selectInput("geneInput", "Gene",
                sort(unique(full_data()$GeneName)),
                selected = "Nudt7")
  })
  
  
  # Filter and format data  
  data_to_plot <- reactive({
    if (is.null(full_data())) {
      return(NULL)
    }    
    dtp <- full_data() %>%
      filter(GeneName == input$geneInput[1]
      )
    
    if(input$unitInput == 'TPM'){
      dtp <- select(dtp, 34:65)
      names(dtp) <- substr(names(dtp), 1, 5)
    } else {
      dtp <- select(dtp, 1:32)
    }
    
    dtp <- dtp %>% pivot_longer(everything(), names_to = 'Sample', values_to = 'Count')
    
    dtp <- left_join(dtp, meta)
    
    return(dtp)
  })
  
  #Draw plot
  output$mainplot <- renderPlot({
    if (is.null(data_to_plot())) {
      return()
    }
    ggplot(data_to_plot(), aes_string(x=input$XInput[1], y="Count")) + 
      geom_point(size=3) + 
      facet_grid(formula(paste(input$YInput[1], "~", input$SplitInput[1]))) +
      stat_summary(fun=mean, aes(group=1), geom='line', color='red', size=2) +
      ylab(input$unitInput) + ggtitle(input$geneInput[1]) + 
      theme_bw() +
      theme(plot.title = element_text(family="Helvetica", size=20, face="bold"),
            axis.title.x = element_text(size=14, face="bold"),
            axis.title.y = element_text(size=14, face="bold"),
            strip.text = element_text(size=12))
    
  })
  
  

}
