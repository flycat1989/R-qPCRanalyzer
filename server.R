# server.R
options(shiny.maxRequestSize = 9*1024^2)

shinyServer(function(input, output) {
  myData<-reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
   myData=read.csv(inFile$datapath, header = input$header, sep = input$sep,stringsAsFactors=FALSE)
  })
  
  
  sampleList<-reactive({
    sort(unique(myData()$Sample))
  })
  
  targetList<-reactive({
    sort(unique(myData()$Target))
  })
  
  ctrlGene<-reactive({
    inputctrlGene=input$endoCtrl
    ctrlGene=strsplit(inputctrlGene,",")[[1]]
  })
    
  meanCtrl<-reactive({
    ctrlGene=as.character(ctrlGene())
    myData=myData()
    myData$Ct=as.numeric(myData$Ct)
    myCtrl=filter(myData,Target %in% ctrlGene)
    meanCtrl=group_by(myCtrl,Sample,Target)%>% summarize(mean(Ct))
    meanCtrl=as.data.frame(meanCtrl)
    colnames(meanCtrl)[3]="meanCt"
    arrange(meanCtrl,Target)
  })
  
  Mvalues<-reactive({
    sampleNames=as.character(sampleList())
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
        
    if(length(ctrlGene())<3){
      Mvalues="Less than 3 endo controls selected"
    }else{
      Mvalues=sapply(controlNames,MvalueGen)
    }
  })
  
  normData<-reactive({
    useInput=input$endoUse
    ctrlUse=strsplit(useInput,",")[[1]]
    myData=myData()
    myData$Ct=as.numeric(myData$Ct)
    ctrlUseData=filter(myData,Target %in% ctrlUse)
    controlUseData=ctrlUseData %>% group_by(Sample) %>% summarize(exp(mean(log(Ct))))
    colnames(controlUseData)[2]="geoMeanCt"
    normData=merge(myData,controlUseData,all.x=TRUE)
    normData$dCt=normData$Ct-normData$geoMeanCt
    normData$relativeExp=1000*2^(-normData$dCt)
    normData=arrange(normData,Target,Sample)
    as.data.frame(normData)
  })
    
  output$contents <- renderTable(myData())
  output$mvalues<-renderTable(as.data.frame(Mvalues()),digits=4)
  output$normdata<-renderTable(normData(),digits = 4)
  
  output$plotimages<-renderImage({
    input$plotbutton  
    targetNames=as.character(targetList())
    fileName="tempImg.png"
    png(file=fileName,width=5,height=15,units="in",res=1200,pointsize = 6)
    par(mfrow=c(8,3))
    for (i in 1:length(targetNames)){
      currentData=filter(normData(),Target==targetNames[i])
      currentData$Sample=as.character(currentData$Sample)
      currentData$Sample=gsub('.{1}$', '', currentData$Sample)
      boxplot(relativeExp~Sample,data=currentData,ylim=c(0, 1.1*max(currentData$relativeExp,na.rm=TRUE)),main=targetNames[i],ylab = "Relative Expression")
    }
    dev.off()
    
    isolate(input$file1)
    isolate(input$endoCtrl)
    isolate(input$endoUse)
    
    list(src = fileName,
         contentType = 'image/png',
         width=600,
         height=1800,
        alt = "This is alternate text")
  })
  
  
  output$downloadnumerical <- downloadHandler(
    filename = function() { 'Untitled.csv' },
    content = function(file) {
    write.csv(normData(), file)
    }
  )
  
})