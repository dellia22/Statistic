#ONE-WAY ANOVA TEST (one-factor ANOVA)
  #Here, the data are organized into several groups base on one single grouping variable (factor)
  #Hypothesis:
      #Null: the means of the different groups are the same
      #Alternative hypothesis: al least one sample mean is not equal to the others 
      #F-test and post Hoc test (if it is necesary)
#NOTE: with only two groups we can also use t-test

#import data from excel
install.packages("readxl") #install package
install.packages("xlsx") #install package
library("readxl") #install library
library("xlsx")    #install library

setwd("/home/gonzalez/Documentos/laura/Docencia/R")   #path with all data
ANOVALUZ <- read.xlsx("ANOVALUZ.xlsx", sheetName = "Hoja1") #read factor with its levels
head(ANOVALUZ) 
str(ANOVALUZ) #checking structure (data.frame)

#Visualize your data
install.packages("ggpubr")
library(ggpubr)
ggboxplot(ANOVALUZ, x="factor", y="Colonias", color="factor", palette=c("#00AFBB", "#E7B800"), 
    order=c("luzverde", "luzamarilla"), ylab="values", xlab="treatment") #plot colonias by group and color by group

ggline(ANOVALUZ, x="factor", y ="Colonias", add=c("mean_se", "jitter"), order=c("luzverde", "luzamarilla"), ylab="values", xlab="treatment")
#plot with values by group and add error bars to mean



#ANOVA
install.packages('dplyr')
library(dplyr)
install.packages("car") #the levenetest function is part of the car package 
library(car)


#Statistics
ANOVALUZ.aov<- aov(Colonias ~ factor, data= ANOVALUZ) #aov() calculates one-way anova
summary(ANOVALUZ.aov) #say "we accept alternative hypothesis"

#Validation of assumptions
#1)Variance homogeneity (homocedasticidad)
plot(ANOVALUZ.aov, 1)
leveneTest(Colonias ~ factor, data= ANOVALUZ) #comprueba la homogeneidad de varianza mediante contraste, si
  #pvalue > 0.05 entonces no hay evidencias de que la varianza sea significativamente diferente (cumple el supuesto)
    #Null hypotheis: variances between group are the same
    #Alternative hypothesis: the variance across groups is statistically significantly different

#when the homogeneity of variance assumption is violated then:
oneway.test(Colonias ~ factor, data= ANOVALUZ)
pairwise.t.test(ANOVALUZ$Colonias, ANOVALUZ$factor, p.adjust.method = "BH", pool.sd = FALSE)


#2)Normal distribution
plot(ANOVALUZ.aov, 2) #all points should fall approximately along the reference line, then we can assume normality

aov_residual<- residuals(object=ANOVALUZ.aov)
shapiro.test(x=aov_residual) #if pvalue >0.05 then accept Null hypothesis (normal distribution)


#Multiple pairwise-comparison between the means of groups
  #To determine if the mean difference between specific pairs of group are statistically significant (> 2 groups)
TukeyHSD(ANOVALUZ.aov)
