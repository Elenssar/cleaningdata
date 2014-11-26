##CODE BOOK
####1.- The data originally loaded has Multiple Measures of 30 "Subject"s (numered from 1 to 30); doing 6 "Activities": 

1 WALKING

2 WALKING_UPSTAIRS

3 WALKING_DOWNSTAIRS

4 SITTING

5 STANDING

6 LAYING 

####2.- The Measures come from the accelerometer and gyroscope 3-axial raw signals. The names are composed by: 

[a] - The prefix 't' to denote time, Time domain signals, as for example: tBodyAcc.Mean...X.           Or the prefix 'f' to denote a Fast Fourier Transform (FFT) was applied to the signal, for example: fBodyAcc.mean...X

[b] - The following word could be "Body" or "Gravity", which means the two types of measures that can be taken from the accelerometer or gyroscopy.

[c] - "Acc"" or "Gyro" indicate from which dispositive the signal was took.

[d] - The names containing Jerk, Jerk mag, indicates that for that particular variable the body linear acceleration and angular velocity were derived in time to obtain Jerk signals.

[e] - Next word in the name, Function applied to the individual values taken for that particular signal, in this case only we have "mean" and "std" (standard deviation).

[f] - Last letter mean the direction of the 3-axial signals, X, Y or Z direction.

####3. - Transforms:

- First only the mean and the standard deviation measures has been selected from the total features:

dataMeanStd<-select(dataMerge, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE), Subject, Activity)

- Then, the data is sumarized using mean function, by Subject and by Activity. This means, that there would be just one Mean per previously Feature by Subject and by Activity:
I did this using the library plyr, we have the function ddply, which can split data by the colnames "Subject" and "Activity", and sumarize with mean function, for all the variables with the "numcolwise" option, removing NA values (na.rm=TRUE)

library(plyr)

dataStep5<-ddply(dataMeanStd, c("Subject", "Activity"), numcolwise(mean,na.rm = TRUE))


Finally, using reshape2 library, with the average of each feature per subject and activity create a short tidy data, where we have only 4 variables: Subject, Activity, Signal Type and Average.

library(reshape2)

tidydata<-melt(dataStep5, id=c("Subject", "Activity"), measure.vars=colnames(dataStep5[,3:88]))

colnames(tidydata)<-c("Subject", "Activity", "Signal Type", "Average")

write.table(tidydata, file="tidydata.txt", row.name=FALSE)

####4. - Final Features:

Subject and Activity described before in point 1, Signal Type is the name of the measures taken by accelerometer and gyroscope, described in 2. Average is the Mean, after summarize the data.