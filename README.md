## Cleaning Data Course - Project Procedures:

#### The Script should be located in the parent directory where the data was unziped, and it asumes that the data was unziped with its original directory name and structure.
#### The solution will be saved in the same directory where the script is under the name "tidydata.txt".

##1 - Merges the training and the test sets to create one data set. I assume that the data is extracted already in the same directory of the script.

###1.1 - Extract the Colum Names of the features from the Feature.txt file and store it in colNameVector:

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

###1.2 - Read Training and testing data from files:

dataTrain<-read.table(file="./UCI HAR Dataset/train/X_train.txt", col.names=colNameVector)

dataTrainY<-read.table(file="./UCI HAR Dataset/train/y_train.txt")

dataTrainSubject<-read.table(file="./UCI HAR Dataset/train/subject_train.txt")

dataTest<-read.table(file="./UCI HAR Dataset/test/X_test.txt", col.names=colNameVector)

dataTestY<-read.table(file="./UCI HAR Dataset/test/y_test.txt")

dataTestSubject<-read.table(file="./UCI HAR Dataset/test/subject_test.txt")

###1.3 - Add Labels and Subjects:

dataTrain$Subject=dataTrainSubject[[1]]

dataTrain$Activity=dataTrainY[[1]]

dataTest$Subject=dataTestSubject[[1]]

dataTest$Activity=dataTestY[[1]]


###1.4 - Finally Merge the two data.frames:

dataMerge<-merge(dataTrain, dataTest, all=TRUE)

##2- Extracts only the measurements on the mean and standard deviation for each measurement. 

dataMeanStd<-select(dataMerge, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE), Subject, Activity)

##3- Uses descriptive activity names to name the activities in the data set.

labels = read.table(file="./UCI HAR Dataset/activity_labels.txt")

dataMeanStd$Activity<-factor(labels[dataMeanStd$Activity, 2])

dataMeanStd$Subject<-factor(dataMeanStd$Subject)

##4- Appropriately labels the data set with descriptive variable names. 

####Consider that by taking the names from the features.txt file in colNameVector (step 1.1) the data already have descriptive variable names.
####CODE BOOK
####The variables values come from the accelerometer and gyroscope 3-axial raw signals. The names are composed by:  
#### [a] - The prefix 't' to denote time, Time domain signals, as for example: tBodyAcc.Mean...X.           Or the prefix 'f' to denote a Fast Fourier Transform (FFT) was applied to the signal, for example: fBodyAcc.mean...X
#### [b] - The following word could be "Body" or "Gravity", which means the two types of measures that can be taken from the accelerometer or gyroscopy.
#### [c] - "Acc"" or "Gyro" indicate from which dispositive the signal was took.
#### [d] - The names containing Jerk, Jerk mag, indicates that for that particular variable the body linear acceleration and angular velocity were derived in time to obtain Jerk signals.
#### [e] - Next word in the name, Function applied to the individual values taken for that particular signal, in this case only we have "mean" and "std" (standard deviation).
#### [f] - Last letter mean the direction of the 3-axial signals, X, Y or Z direction.

##5- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####Using the library plyr, we have the function ddply, which can split data by the colnames "Subject" and "Activity", and sumarize with mean function, for all the variables with the "numcolwise" option, removing NA values (na.rm=TRUE)

library(plyr)

dataStep5<-ddply(dataMeanStd, c("Subject", "Activity"), numcolwise(mean,na.rm = TRUE))

####Using reshape2 library to create the tidy data, with the average of each feature per subject and activity.

library(reshape2)

tidydata<-melt(dataStep5, id=c("Subject", "Activity"), measure.vars=colnames(dataStep5[,3:88]))

colnames(tidydata)<-c("Subject", "Activity", "Signal Type", "Average")

write.table(tidydata, file="tidydata.txt", row.name=FALSE)

