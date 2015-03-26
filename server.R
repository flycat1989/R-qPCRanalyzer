# server.R
options(shiny.maxRequestSize = 9*1024^2)



shinyServer(function(input, output) {
  myData<-reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
   read.csv(inFile$datapath, header = input$header, sep = input$sep,stringsAsFactors=FALSE)
  })
    
  ctrlGene<-reactive({
    inputctrlGene=input$endoCtrl
    ctrlGene=strsplit(inputctrlGene,",")[[1]]
  })
    
  meanCtrl<-reactive({
    ctrlGene=as.character(ctrlGene())
    myCtrl=filter(myData(),Target %in% ctrlGene)
    meanCtrl=group_by(myCtrl,Sample,Target)%>% summarize(mean(Ct))
    meanCtrl=as.data.frame(meanCtrl)
    colnames(meanCtrl)[3]="meanCt"
    arrange(meanCtrl,Target)
  })
  
  Mvalues<-reactive({
    sampleNames=sort(unique(myData()$Sample))
    controlNames=ctrlGene()
    controlData=meanCtrl()
    
    MvalueGen=function(selCtrl){
      j=controlNames[controlNames==selCtrl]
      k=controlNames[!controlNames==selCtrl]
      
      MjVector=sapply(k,function(kName) FUN={
        Ajk=sapply(sampleNames, function(m) FUN={
          subsetCtrl=controlData[which(controlData$Sample==m),]
          subsetCtrl$meanCt[which(subsetCtrl$Target==kName)]-subsetCtrl$meanCt[which(subsetCtrl$Target==j)]
        })
        Vjk=sd(unlist(Ajk))
      })
      Mj=mean(MjVector)
      return(Mj)
    }
        
    if(length(ctrlGene())<2){
      Mvalues=NA
    }else{
      Mvalues=sapply(controlNames,MvalueGen)
    }
  })
  
  normData<-reactive({
    
  })
  
  
  output$contents <- renderTable(myData())
  output$meanCtrlTable<-renderTable(meanCtrl())
  output$mvalues<-renderTable(as.data.frame(Mvalues()))

  
})