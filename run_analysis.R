library(dplyr)

# Download and unzip the data
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./UCI HAR Dataset.zip")) {
  download.file(fileurl, "./UCI HAR Dataset.zip", method = "curl")
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

# Read and convert the datasets (assign all dataframes)
featuredataset <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
traindataX <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featuredataset$functions)
traindataY <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
traindatasubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
testdataX <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featuredataset$functions)
testdataY <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
testdatasubject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
activitylabelsdata <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

# Merging the training and the test sets to create one data set
Xdataset <- rbind(traindataX, testdataX)
Ydataset <- rbind(traindataY, testdataY)
Subjectdataset <- rbind(traindatasubject, testdatasubject)
Alldataset <- cbind(Subjectdataset, Ydataset, Xdataset)

# Extract only the measurements on the mean and standard deviation for each measurement
Meanstddataset <- Alldataset %>% select(subject, code, contains("mean"), contains("std"))

# Use descriptive activity names to name the activities in the data set
Meanstddataset$code <- activitylabelsdata[Meanstddataset$code, 2]

# Appropriately label the data set with descriptive variable names
names(Meanstddataset)[2] = "activity"
names(Meanstddataset)<-gsub("Acc", "Accelerometer", names(Meanstddataset))
names(Meanstddataset)<-gsub("Gyro", "Gyroscope", names(Meanstddataset))
names(Meanstddataset)<-gsub("BodyBody", "Body", names(Meanstddataset))
names(Meanstddataset)<-gsub("Mag", "Magnitude", names(Meanstddataset))
names(Meanstddataset)<-gsub("^t", "Time", names(Meanstddataset))
names(Meanstddataset)<-gsub("^f", "Frequency", names(Meanstddataset))
names(Meanstddataset)<-gsub("tBody", "TimeBody", names(Meanstddataset))
names(Meanstddataset)<-gsub("-mean()", "Mean", names(Meanstddataset), ignore.case = TRUE)
names(Meanstddataset)<-gsub("-std()", "STD", names(Meanstddataset), ignore.case = TRUE)
names(Meanstddataset)<-gsub("-freq()", "Frequency", names(Meanstddataset), ignore.case = TRUE)
names(Meanstddataset)<-gsub("angle", "Angle", names(Meanstddataset))
names(Meanstddataset)<-gsub("gravity", "Gravity", names(Meanstddataset))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Tidydata <- Meanstddataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

# Write the final tidy data table
write.table(Tidydata, "tidydata.txt", row.name = FALSE)
