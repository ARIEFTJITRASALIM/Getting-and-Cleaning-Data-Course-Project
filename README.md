# Getting-and-Cleaning-Data-Course-Project

The below codes download and unzip the data file:

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./UCI HAR Dataset.zip")) {
  download.file(fileurl, "./UCI HAR Dataset.zip", method = "curl")
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

Then, I read and converted all the datasets using the following codes:

featuredataset <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
traindataX <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = featuredataset$functions)
traindataY <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
traindatasubject <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
testdataX <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = featuredataset$functions)
testdataY <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
testdatasubject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
activitylabelsdata <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

Following that, I merged the training and test sets to created an overall merged dataset using the following codes:

Xdataset <- rbind(traindataX, testdataX)
Ydataset <- rbind(traindataY, testdataY)
Subjectdataset <- rbind(traindatasubject, testdatasubject)
Alldataset <- cbind(Subjectdataset, Ydataset, Xdataset)

Where I then extracted only the mean and standard deviation measurements and used descriptive activity names to name the dataset:

Meanstddataset <- Alldataset %>% select(subject, code, contains("mean"), contains("std"))
Meanstddataset$code <- activitylabelsdata[Meanstddataset$code, 2]

Following which, I labelled the dataset with descriptive variable names:

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

And created another independent tidy dataset with the average of each variable for activity and subject:

Tidydata <- Meanstddataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

Finally, I wrote the final tidy dataset:
write.table(Tidydata, "tidydata.txt", row.name = FALSE)
