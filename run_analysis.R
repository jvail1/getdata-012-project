# Load required libraries and set working directory
library(dplyr)
library(tidyr)
setwd("~/Dropbox/Programming/Coursera/getdata-012/getdata-012-project")

# Check data set existance
if(!file.exists("UCI HAR Dataset")) {
    if(!file.exists("dataset.zip")){
        fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file (fileURL, "dataset.zip", mode = "wb")
    }
    unzip("dataset.zip")
}

# Reading in data files
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
# test_body_acc_x <- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt")
# test_body_acc_y <- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt")
# test_body_acc_z <- read.table("UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt")
# test_body_gyro_x <- read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt")
# test_body_gyro_y <- read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt")
# test_body_gyro_z <- read.table("UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt")
# test_total_acc_x <- read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt")
# test_total_acc_y <- read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt")
# test_total_acc_z <- read.table("UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt")
# train_body_acc_x <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt")
# train_body_acc_y <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
# train_body_acc_z <- read.table("UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
# train_body_gyro_x <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
# train_body_gyro_y <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
# train_body_gyro_z <- read.table("UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
# train_total_acc_x <- read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
# train_total_acc_y <- read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
# train_total_acc_z <- read.table("UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")

# Merge the training and test data set into one data set
data <- rbind(test_x, train_x)
activity <- rbind(test_y, train_y)
subject <- rbind(test_subject, train_subject)

# Extract mean() and std() for each measurement
# Note that meanFreq() are ignored
meanIdx <- grep("mean\\(\\)", features$V2)
stdIdx <- grep("std\\(\\)", features$V2)
data <- data[, c(meanIdx, stdIdx)]

# Use descriptive names for activities in data set
activity <- merge(activity, activityLabels)

# Putting it all together to get a tidy data set
# Label data set with descriptive variable names
# Note that wide format is adopted instead of narrow
data <- cbind(subject, activity$V2, data)
meanLabel <- features$V2[meanIdx]
stdLabel <- features$V2[stdIdx]
names(data) <- c("Subject", "Activity", as.character(meanLabel), as.character(stdLabel))

# Add new column to differenciate Time and Frequency domain


# Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.