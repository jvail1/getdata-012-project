# Load required libraries and set working directory
library(dplyr)
setwd("~/Dropbox/Programming/Coursera/getdata-012/getdata-012-project")

# Check if data set exists in working directory.
if(!file.exists("UCI HAR Dataset")) {
    if(!file.exists("dataset.zip")){
        fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file (fileURL, "dataset.zip", mode = "wb")
    }
    unzip("dataset.zip")
}

# Read in all necessary data files.
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Merge the training and test data set into one data set.
data <- rbind(test_x, train_x)
activity <- rbind(test_y, train_y)
subject <- rbind(test_subject, train_subject)

# Extract mean() and std() for each measurement, then
# cbind() with subject and activity columns.
# Note that measurement like meanFreq() etc. are ignored.
meanIdx <- grep("mean\\(\\)", features$V2)
stdIdx <- grep("std\\(\\)", features$V2)
data <- data[, c(meanIdx, stdIdx)]

# Use descriptive names for activities in data set by converting
# numeric to factor with activity names from activityLabels.
activity$V1 <- factor(activity$V1, labels = activityLabels$V2)

# Putting it all together to get a tidy data set
# Label data set with descriptive variable names
# Note that wide format is adopted instead of narrow
# "-" and "()" are replaced with either "_" or ""
data <- cbind(subject, activity, data)
meanLabel <- gsub("__", "", gsub('[^A-Za-z]', '_', features$V2[meanIdx]))
stdLabel <- gsub("__", "", gsub('[^A-Za-z]', '_', features$V2[stdIdx]))
names(data) <- c("Subject", "Activity", as.character(meanLabel), as.character(stdLabel))

# Remove all other unecessary data frames and variables
rm(list=setdiff(ls(), "data"))

# Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.
tidyData <- group_by(data, Subject, Activity) %>% summarise_each(funs(mean))

# Write to txt file
write.table(tidyData, file="output.txt", row.names = FALSE)
