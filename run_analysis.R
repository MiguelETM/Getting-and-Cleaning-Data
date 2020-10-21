#Author: Miguel Toralla


#download and unzip the data

library(data.table)
data_source = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(data_source, "proyect.zip")
unzip("proyect.zip")


# Working with the training and test data sets
## loading the data sets
x_test<- read.table("UCI HAR Dataset/test/X_test.txt")
y_test<- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <-read.table("UCI HAR Dataset/test/subject_test.txt")
x_train<- read.table("UCI HAR Dataset/train/X_train.txt")
y_train<- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <-read.table("UCI HAR Dataset/train/subject_train.txt")


#merging the data sets
x <- rbind(x_test,x_train)
y <- rbind(y_test,y_train)
subject <-rbind(subject_test, subject_train)

#loading the activity labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <-read.table("UCI HAR Dataset/features.txt")

#mean and std 

i <- grep("mean\\(\\)|std\\(\\)", features[,2])
x <- x[,i]

#describing the activities in the data set.
y[,1]<-activity_labels[y[,1],2]

#labeling the data set
labels<-features[i,2]
names(x)<-labels 
names(y)<-"Activity"
names(subject)<-"SubjectID"

new_data <- cbind(subject, y,x)

#creating a tidy data set
tidy_data <- data.table(new_data)
tidy_data <- tidy_data[, lapply(.SD, mean), by = 'SubjectID,Activity'] 
write.table(tidy_data, file = "tidyDataSet.txt", row.names = FALSE)