# the data set consist inicially for 4 tables: 

#-activity labels, (is a list to merge with train and test data) 
#-features, (is a list to merge with train and test data)
#-train and 
#-test

#First i'm going to make the activity labels table, reading data from activity_labels.txt 
#and features table, reading data from features.txt.

setwd("~/UCI HAR Dataset")

activites_lables <- read.table("activity_labels.txt")
names(activites_lables)<-c("activitylabels","activitynames")

features <- read.table("features.txt")

#Next, i'm going to make the test and train data set, setting the working directory for
#each case

setwd("~/UCI HAR Dataset/test")

library(dplyr)
test<-data.frame()

#For the two sets, first this script takes the data from "subject_test.txt" (contains the subject ID, for each row of the set)
#then, take the measurements of each variable in the "x_test.txt" file (the name of each varible is taken from features data set)
#and take the activity id's from the "y_test.txt" file for each row.

test <- read.table("subject_test.txt",col.names = "subject")
test <- read.table("X_test.txt",col.names = features$V2) %>% cbind(test) 
test <- read.table("y_test.txt",col.names = "activitylabels") %>% cbind(test)

#next, with a loop, the scrip takes the data of every file (that represents one variable) in the inertial signals folder,
#and creates the mean and standar deviation for each mesurement, adding 1 column for the mean of variable, and one column for the std, for each file (variable)
#For the name of each variable (file), the script takes the name of the file and paste it "mean" and "std", for each case.

setwd("~/UCI HAR Dataset/test/Inertial Signals")
rm(temp)
for(i in 1:9){ 
        temp <- read.table(dir()[i])
        temp <-mutate(temp,mean = rowMeans(temp),sd = apply(temp,1,sd)) %>% 
                select(mean:sd) 
        
        columnas <- rep(dir()[i],2)
        columnas <- sub("_","",columnas)
        columnas <- c(sub("_",".mean.",columnas[1]),"_",".std.",columnas[2])
        names(temp) <- columnas
        rm(columnas)
        train<-cbind(train,temp)
} 


#all of this variables, are joint in one table, using cbind function.

#the script creates a columns for specify the type of set (train or test)

test$set<-"test"

#Now, the trainning set

library(dplyr)
setwd("~/UCI HAR Dataset/train")
train<-data.frame()

train <- read.table("subject_train.txt",col.names = "subject")
train <- read.table("X_train.txt",col.names = features$V2) %>% cbind(train)
train <- read.table("y_train.txt",col.names = "activitylabels") %>% cbind(train)

setwd("~/UCI HAR Dataset/train/Inertial Signals")

rm(temp)

for(i in 1:9){ 
        temp <- read.table(dir()[i])
        temp <-mutate(temp,mean = rowMeans(temp),sd = apply(temp,1,sd)) %>% 
                select(mean:sd) 
        
        columnas <- rep(dir()[i],2)
        columnas <- sub("_","",columnas)
        columnas <- c(sub("_",".mean.",columnas[1]),"_",".std.",columnas[2])
        names(temp) <- columnas
        rm(columnas)
        train<-cbind(train,temp)
} 

train$set<-"train"


#cleanning the names of the variables and removing uppercases (the _test.txt is from the file)
#this is to make the train and test set merge.


names(test) <- gsub("_test.txt","",names(test)) %>% tolower
names(train) <- gsub("_train.txt","",names(train)) %>% tolower

#merging the test and train set

set<-rbind(test,train)

#Select just the variables related with mean an std
set<-select(set,matches("\\.[Ss]td\\.|\\.[Mm]ean\\.|subject|activitylabels|set"))

library(tidyr)

#Assings activities names to de activities labels and making some order with the columns
set <- merge(set,activites_lables) %>% select(subject,activitynames,set,2:67)


library(reshape2)

#making the step 5 set, first select the id variables (the first 3 columns)
#and the measures variables (all except the first 3 columns)
#in the second step, generate the mean for each variable for each activity name and subject

second_set <- set %>% melt(id=names(set)[1:3],measure.vars = names(set)[-(1:3)]) %>% 
        dcast(activitynames+subject+set~variable,mean)

setwd("~/UCI HAR Dataset")

write.table(second_set,row.name=FALSE, file = "Clean dataset.txt")