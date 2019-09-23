library(HarmonicRegression)
data(rna.polya)
polya.t<-seq(0,44,4)
plot(polya.t)

library(MetaCycle) #for detecting rhythmic signals from time-seires datasets
head(cycMouseLiverProtein) #expression profiles of 5 circadian proteins with 3h-resolution covering two days, column1= protein name, column 2 to 49= time points from CT0 to CT45 with three replicates at each time points
head(cycSimu4h2d) #20 simulated profiles (periodic and non-periodic) with 4h-resolution covering two periodws, column1= curve ID, column 2 to 13 =time points from 0 to 44
head(cycYeastCycle) #expression profiles of 10 cycling transcripts with 16-minutes resolution covering about two yeast cell cycles, column1 =transcript name, 
 #column2 to 12 = time points from 2 minutes to 162 minutes after recovery phase

write.csv(cycSimu4h2d, file="cycSimu4h2d.csv", row.names=FALSE)

meta2d(infile = "cycSimu4h2d.csv", filestyle = "csv", outdir = "example", timepoints = "Line1") #detect rhythmic signals from time-series datasets 


write.csv(cycYeastCycle, file="cycYeastCycle.csv", row.names=FALSE)

resultados2<- meta2d(infile= "cycYeastCycle.csv", filestyle = "csv", minper=80, maxper=96, timepoints = seq(2,162, by=16), outputFile = FALSE,
       ARSdefaultPer = 85, outRawData = TRUE)
head(resultados2$ARS)
head(resultados2$JTK)
head(resultados2$LS)
head(resultados2$meta)

#meta3d detect rhythmic signals from time-series with individual information
head(cycHumanBloodData) #column1= transcript name, collumn 2 to 439=samples from individuals at different time points and sleep conditions
head(cycHumanBloodDesign) #
write.csv(cycHumanBloodData, file="cycHumanBloodData.csv", row.names=FALSE)
write.csv(cycHumanBloodDesign, file="cycHumanBloodDesign.csv", row.names=FALSE)
meta3d(datafile="cycHumanBloodData.csv", cycMethodOne="JTK", designfile="cycHumanBloodDesign.csv", outdir="example",
       filestyle="csv", design_libColm = 1, design_subjectColm = 2, design_hrColm = 4, design_groupColm = 3)

