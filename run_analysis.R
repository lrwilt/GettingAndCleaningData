library(dplyr)

#download and unzip data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "projectfiles.zip")
unzip(zipfile="projectfiles.zip",exdir= getwd())

#read in features as vector for column names
columnNames <- read.delim("features.txt", header = FALSE)
columnNames <- gsub("^[0-9]+", "", columnNames$V1)
columnNames <- trimws(columnNames, "both")

#read in activity labels
activity_labels <- read.delim("activity_labels.txt", header = FALSE, sep = "", col.names = c("activity", "activitylabel"))

#read in test data
x_test <- read.delim("X_test.txt", header = FALSE, sep = "", col.names = columnNames)

#read in test activity data
y_test <- read.delim("Y_test.txt", header = FALSE, sep = "", col.names = c("activity"))

#read in subject data for test
subject_test <- read.delim("subject_test.txt", header = FALSE, sep = "", col.names = c("subject"))

#combine test data
test_data <- cbind(x_test, y_test, subject_test)
test_data$dataorigin <- "Test"

#pull in activity labels
test_data <- merge(x = test_data, y = activity_labels)

#read in training data
x_train <- read.delim("X_train.txt", header = FALSE, sep = "", col.names = columnNames)

#read in training activity data 
y_train <- read.delim("Y_train.txt", header = FALSE, sep = "", col.names = c("activity"))

#read in subject data for training
subject_train <- read.delim("subject_train.txt", header = FALSE, sep = "", col.names = c("subject"))

#combine training data
train_data <- cbind(x_train, y_train, subject_train)
train_data$dataorigin <- "Train"

#pull in activity labels
train_data <- merge(x = train_data, y = activity_labels)

#make one data set
data <- rbind(test_data, train_data)

#subset on just mean and stardard deviation
mean_std_data <- data[,grepl("mean|std|activitylabel|subject", names(data))]

#rename variables
colnames(mean_std_data) <- tolower(names(mean_std_data))
colnames(mean_std_data) <- gsub("\\.", "", colnames(mean_std_data))
colnames(mean_std_data) <- sub("^t", "time", colnames(mean_std_data))
colnames(mean_std_data) <- sub("^f", "freq", colnames(mean_std_data))
colnames(mean_std_data) <- sub("acc", "accelerometer", colnames(mean_std_data))
colnames(mean_std_data) <- sub("gyro", "gyroscope", colnames(mean_std_data))
colnames(mean_std_data) <- sub("mag", "magnitude", colnames(mean_std_data))
colnames(mean_std_data) <- sub("bodybody", "body", colnames(mean_std_data))

#summarize data
data_summary <- mean_std_data %>% group_by(activitylabel, subject) %>% summarise_each(funs(mean))

#write out the summary data
write.csv(data_summary, "data_summary.csv")
names(mean_std_data)
