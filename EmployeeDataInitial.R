


library(caret)
library(tidyr)
library(plyr)
library(dplyr)
library(caTools)
library(reshape2)
library(gbm)
library(caTools)
library(randomForest)
library(ggplot2)
library(data.table)
library(xgboost)
library(Matrix)
library(lightgbm)

##Notations off and clear all objects
options(scipen = 999)
rm(list = ls())
gc()

startime=Sys.time()

emptrain=fread("E:\\AbhinavB\\Kaggle\\Amazon Employee Access\\amazon-employee-access-challenge\\train.csv",
              data.table = FALSE,
              colClasses =c("factor","factor","factor","factor","factor","factor","character","character","factor","factor"))

emptest=fread("E:\\AbhinavB\\Kaggle\\Amazon Employee Access\\amazon-employee-access-challenge\\test.csv",
              data.table = FALSE,
              colClasses =c("integer","factor","factor","factor","factor","factor","character","character","factor","factor"))

emptrain=cbind(ind="train",emptrain)


test_id=emptest$id

emptest=emptest[,-which(names(emptest) %in% c("id"))]
emptest =cbind(ACTION=NA,emptest)
emptest=cbind(ind="test",emptest)

fullset=rbind(emptrain,emptest)
## total rows should be 32,769 + 9,12,363=9,45,132
dim(fullset)


endtime=Sys.time()-startime
print(endtime)




