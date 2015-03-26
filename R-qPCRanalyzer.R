library("dplyr")
###################################
MvalueGen=function(ctrlData,splList,ctrlList,selCtrl){
  if(length(ctrlList)==1){
    print("Only one control is used in the data")
    return(0)
  }
  j=ctrlList[ctrlList==selCtrl]
  k=ctrlList[!ctrlList==selCtrl]
  MjVector=sapply(k,function(kName) FUN={
    Ajk=sapply(splList, function(m) FUN={
      subsetCtrl=ctrlData[which(ctrlData$Sample==m),]
      subsetCtrl$Ct[which(subsetCtrl$Sample==kName)]-subsetCtrl$Ct[which(subsetCtrl$Sample==j)]
    })
    Vjk=sd(Ajk)
  })
  Mj=mean(MjVector)
  return(Mj)
}

###################################


fileName="20120904-Th2TfHdifferentiationCheck.csv"
qPCR=read.csv(fileName,stringsAsFactors=FALSE)
qPCR$Target=tolower(qPCR$Target)

controls=c("sdha","actb","18srna")

sampleList=sort(unique(qPCR$Sample))
qPCRcontrol=filter(qPCR, Target %in% controlList)
controlList=sort(unique(qPCRcontrol$Target))


qPCR %>% group_by(Sample) %>% summarize(mean(Ct))
