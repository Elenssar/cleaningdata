#1 - Merges the training and the test sets to create one data set. I assume that the data is extracted already in the same directory of the script.

##1.1 - Extract the Colum Names of the features from the Feature.txt file and store it in colNameVector:
con <- file("./UCI HAR Dataset/features.txt", "r", blocking = FALSE)

colNameLines<-readLines(con)
colNameVector<-1:length(colNameLines)
i<-1
for (line in colNameLines) {
  colNameVector[i]<-strsplit(line, " ")[[1]][2]
  i<-i+1
}
colNameVector
close(con)

##1.2 - Read Training and testing data from files:

dataTrain<-read.table(file="./UCI HAR Dataset/train/X_train.txt", col.names=colNameVector)

dataTrainY<-read.table(file="./UCI HAR Dataset/train/y_train.txt")

dataTrainSubject<-read.table(file="./UCI HAR Dataset/train/subject_train.txt")

dataTest<-read.table(file="./UCI HAR Dataset/test/X_test.txt", col.names=colNameVector)

dataTestY<-read.table(file="./UCI HAR Dataset/test/y_test.txt")

dataTestSubject<-read.table(file="./UCI HAR Dataset/test/subject_test.txt")

##1.3 - Add Labels and Subjects:

dataTrain$Subject=dataTrainSubject[[1]]
dataTrain$Activity=dataTrainY[[1]]

dataTest$Subject=dataTestSubject[[1]]
dataTest$Activity=dataTestY[[1]]


##1.4 - Finally Merge the two data.frames:

dataMerge<-merge(dataTrain, dataTest, all=TRUE)

#2- Extracts only the measurements on the mean and standard deviation for each measurement. 

dataMeanStd<-select(dataMerge, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE), Subject, Activity)

#3- Uses descriptive activity names to name the activities in the data set.

labels = read.table(file="./UCI HAR Dataset/activity_labels.txt")

dataMeanStd$Activity<-factor(labels[dataMeanStd$Activity, 2])
dataMeanStd$Subject<-factor(dataMeanStd$Subject)

#4- Appropriately labels the data set with descriptive variable names. 

##I Consider that by taking the names from the features.txt file in colNameVector (step 1.1), my data already have descriptive variable names.


#5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)

dataStep5<-ddply(dataMeanStd, c("Subject", "Activity"), numcolwise(mean,na.rm = TRUE))

library(reshape2)

tidydata<-melt(dataStep5, id=c("Subject", "Activity"), measure.vars=colnames(dataStep5[,3:88]))


colnames(tidydata)<-c("Subject", "Activity", "Signal Type", "Average")

write.table(tidydata, row.name=FALSE)
