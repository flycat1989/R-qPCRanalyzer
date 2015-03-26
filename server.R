# server.R
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
  output$contents <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    myData<<-read.csv(inFile$datapath, header = input$header, sep = input$sep,stringsAsFactors=FALSE)
  })
  output$meanCtrlTable<-renderTable({
      #inFile <- input$file1
      #myData=read.csv(inFile$datapath, header = input$header, sep = input$sep)
      inputctrlGene=input$endoCtrl
      ctrlGene=strsplit(inputctrlGene,",")[[1]]
      myCtrl=filter(myData,Target %in% ctrlGene)
      meanCtrl=group_by(myCtrl,Sample,Target)%>% summarize(mean(Ct))
      meanCtrl=as.data.frame(meanCtrl)
      meanCtrl<<-arrange(meanCtrl,Target)
  })
  
})