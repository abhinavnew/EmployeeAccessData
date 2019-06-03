


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

emptrain_orig=fread("E:\\AbhinavB\\Kaggle\\Amazon Employee Access\\amazon-employee-access-challenge\\train.csv",
              data.table = FALSE,
              colClasses =c("factor","factor","factor","factor","factor","factor","character","character","factor","factor"))

emptest_orig=fread("E:\\AbhinavB\\Kaggle\\Amazon Employee Access\\amazon-employee-access-challenge\\test.csv",
              data.table = FALSE,
              colClasses =c("integer","factor","factor","factor","factor","factor","character","character","factor","factor"))


emptrain=emptrain_orig
emptest=emptest_orig

##Combining train and test

emptrain=cbind(ind="train",emptrain)

test_id=emptest$id
emptest=emptest[,-which(names(emptest) %in% c("id"))]
emptest =cbind(ACTION=NA,emptest)
emptest=cbind(ind="test",emptest)

fullset=rbind(emptrain,emptest)
## total rows should be 32,769 + 9,12,363=9,45,132
dim(fullset)

##converting categorical variables to corresponding factor level numeric value
fullset$RESOURCE_xx=as.numeric(factor(fullset$RESOURCE),levels=levels(fullset$RESOURCE))-1
fullset$MGR_ID_xx=as.numeric(factor(fullset$MGR_ID),levels=fullset$MGR_ID)-1
fullset$ROLE_ROLLUP_1_xx=as.numeric(factor(fullset$ROLE_ROLLUP_1),levels=fullset$ROLE_ROLLUP_1)-1
fullset$ROLE_ROLLUP_2_xx=as.numeric(factor(fullset$ROLE_ROLLUP_2),levels=fullset$ROLE_ROLLUP_2)-1
fullset$ROLE_DEPTNAME_xx=as.numeric(factor(fullset$ROLE_DEPTNAME),levels=fullset$ROLE_DEPTNAME)-1
fullset$ROLE_FAMILY_xx=as.numeric(factor(fullset$ROLE_FAMILY),levels=fullset$ROLE_FAMILY)-1
fullset$ROLE_CODE_xx=as.numeric(factor(fullset$ROLE_CODE),levels=fullset$ROLE_CODE)-1

fullset$ROLE_TITLE_xx=as.numeric(as.character(fullset$ROLE_TITLE))
fullset$ROLE_FAMILY_DESC_xx=as.numeric(as.character(fullset$ROLE_FAMILY))


##preparing train and validate set

fulltrain=subset(fullset,fullset$ind=="train")
fulltrain=fulltrain[,-which(names(fulltrain) %in% c("ind","RESOURCE","MGR_ID","ROLE_ROLLUP_1","ROLE_ROLLUP_2","ROLE_DEPTNAME","ROLE_TITLE","ROLE_FAMILY_DESC","ROLE_FAMILY","ROLE_CODE"))]
splitt=sample.split(fulltrain$ACTION,SplitRatio = 0.6)
trainset_split=subset(fulltrain,splitt==TRUE)
validateset_split=subset(fulltrain,splitt==FALSE)
#0.6*32,769=19661.4
dim(trainset_split)

##0.4*32,769=13,107.6
dim(validateset_split)


tr_labels=trainset_split[,"ACTION"]
train_m=trainset_split[,-which(names(trainset_split) %in% c("ACTION"))]
lgbtrain=lgb.Dataset(data=as.matrix(train_m),label=tr_labels)

vl_labels=validateset_split[,"ACTION"]
val_m=validateset_split[,-which(names(validateset_split) %in% c("ACTION"))]
sparse_val=as.matrix(val_m)

##preparing lightgbm model 
set.seed(91180)

param=list(boosting_type="gbdt",
           objective="binary",
           metric="auc",
           num_leaves=10,
           max_depth=10,num_class=1
           )


fitlgbcv=lgb.cv(params = param,data=lgbtrain,early_stopping_rounds = 50)
summary(fitlgbcv)
fitlgbcv



           
           
           
           
           )



endtime=Sys.time()-startime
print(endtime)




