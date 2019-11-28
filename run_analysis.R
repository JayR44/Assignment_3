library(tidyverse)

#Import feature names and activity labels
setwd("C:/Users/jwatk/Documents/R/R Data Science Course/R-Data-Science-Course/Course 3 - Getting and Cleaning Data/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
activity_labels <- read.table("activity_labels.txt", col.names = c("activity_code", "activity"))
features <- read.table("features.txt", col.names = c("feature_code", "feature"))

#Import test data
setwd("C:/Users/jwatk/Documents/R/R Data Science Course/R-Data-Science-Course/Course 3 - Getting and Cleaning Data/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
subject_test <- read.table("subject_test.txt", col.names = "subject_code")
X_test <- read.table("X_test.txt", col.names = features$feature)
y_test <- read.table("y_test.txt", col.names = "activity_code")

#Import train data
setwd("C:/Users/jwatk/Documents/R/R Data Science Course/R-Data-Science-Course/Course 3 - Getting and Cleaning Data/data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
subject_train <- read.table("subject_train.txt", col.names = "subject_code")
X_train <- read.table("X_train.txt", col.names = features$feature)
y_train <- read.table("y_train.txt", col.names = "activity_code")

#Create merged dataset for test and train data
test_data <- cbind(subject_test, X_test, y_test)
train_data <- cbind(subject_train, X_train, y_train)

#Add test/train indicator column
test_data <- test_data %>% mutate(data_type = "test")
train_data <- train_data %>% mutate(data_type = "train")

#Merge the train and test data
merged_data <- rbind(train_data, test_data)

#Add activity labels to the data
merged_data <- merged_data %>% left_join(activity_labels, by = "activity_code")

#Select the relevant columns that represent means and standard deviations
selected_cols <- merged_data %>% select(subject_code, activity, contains("mean") , contains("std"))

#Give columns appropriate names that are clearer
names(selected_cols) <- gsub("Acc", "_Acceleration_",names(selected_cols))
names(selected_cols) <- gsub("Gyro", "_Gyrometer_",names(selected_cols))
names(selected_cols) <- gsub("^t", "Time_",names(selected_cols))
names(selected_cols) <- gsub("\\.tBody", "_Time_Body",names(selected_cols))
names(selected_cols) <- gsub("^f", "Frequency_",names(selected_cols))
names(selected_cols) <- gsub("Mag", "_Magnitude_",names(selected_cols))
names(selected_cols) <- gsub("\\.mean", "Mean",names(selected_cols), ignore.case = TRUE)
names(selected_cols) <- gsub("\\.std", "STD",names(selected_cols), ignore.case = TRUE)
names(selected_cols) <- gsub("BodyBody", "Body",names(selected_cols))
names(selected_cols) <- gsub("freq", "Frequency",names(selected_cols))
names(selected_cols) <- gsub("^angle", "Angle",names(selected_cols))
names(selected_cols) <- gsub("gravity", "Gravity",names(selected_cols))
names(selected_cols) <- gsub("__", "_",names(selected_cols))
names(selected_cols)

#Create data set with the average of each variable for each activity
data_means <- selected_cols %>% group_by(subject_code, activity) %>% summarise_all(list(mean))
names(data_means)

#Export the data
write.table(data_means, "./data_means.txt")

