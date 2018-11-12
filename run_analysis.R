## Getting and Cleaning Data Project Assignment

## Reads and combines subject data. Renames the column to subject
datasubjecttest<-read.table("subject_test.txt")
datasubjecttrain<-read.table("subject_train.txt")
datasubject<-rbind(datasubjecttest,datasubjecttrain)
names(datasubject)<-c("subject")

## Reads and combines activity data, Renames the column to activity
dataActivityTest<-read.table("y_test.txt")
dataActivityTrain<-read.table("y_train.txt")
dataActivity<-rbind(dataActivityTest,dataActivityTrain)
names(dataActivity)<-c("activity")

## Reads and combines observations
dataTestSet<-read.table("X_test.txt")
dataTrainingSet<-read.table("X_train.txt")
dataX<-rbind(dataTestSet,dataTrainingSet)

## Reads column names from features file and renames the columns of dataset
columnNames<-read.table("features.txt")
names(dataX)<-columnNames$V2

##combines the above datasets to get complete dataset
dataJoin<-cbind(datasubject,dataActivity)
dataComplete<-cbind(dataX,dataJoin)

## Extracts the columns with mean() and std() in their names
subset<-columnNames$V2[grep("mean()|std()", columnNames$V2)]
selectNames<-c(as.character(subset),"subject","activity")
dataSubset<-subset(dataComplete,select=selectNames)

## Read activity labels
activityLabels<-read.table("activity_labels.txt")

## Labels activity levels in the extracted data
dataSubset$activity <- factor(dataComplete$activity, 
                                levels = activityLabels[,1], 
                                labels = activityLabels[,2])

## Labels activity levels in the complete data
dataComplete$activity <- factor(dataComplete$activity, 
                              levels = activityLabels[,1], 
                              labels = activityLabels[,2])

##Labels the extracted data set with descriptive variable names
names(dataSubset)=gsub("^t","time",names(dataSubset))
names(dataSubset)=gsub("^f","frequency",names(dataSubset))
names(dataSubset)=gsub("Acc","Accelerometer",names(dataSubset))
names(dataSubset)=gsub("Gyro","Gyroscope",names(dataSubset))


##Labels the complete data set with descriptive variable names
names(dataComplete)=gsub("^t","time",names(dataComplete))
names(dataComplete)=gsub("^f","frequency",names(dataComplete))
names(dataComplete)=gsub("Acc","Accelerometer",names(dataComplete))
names(dataComplete)=gsub("Gyro","Gyroscope",names(dataComplete))

## creates tidy data set with avg of each variable for each activity & each subject
library(plyr);
DataTidyD<-aggregate(. ~subject + activity, dataSubset, mean)

## writes the data into a txt file
write.table(DataTidyD, file = "tidydata.txt",row.name=FALSE)
