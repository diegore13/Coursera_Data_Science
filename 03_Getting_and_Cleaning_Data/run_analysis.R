library(tidyverse)

##################################################################
# 1. Merges the training and the test sets to create one data set.
##################################################################

#Define working directory
directory <- "/Users/diego/Documents/Data_Science/R/03_Getting&Cleaning_Data/UCI\ HAR\ Dataset/"

#Read label files
activity_labels <- read_table(paste0(directory, 
                     "activity_labels.txt"), 
                     col_names = c("activityLabels", "activityName"))

#Links the class labels with their activity name
features <- read_table2(paste0(directory,
                       "features.txt"), 
                       col_names = c("featureLabels", "featureName"))

#Read test data
subject_test <- read_table(paste0(directory, "test/subject_test.txt"), 
                                  col_names = c("subjectId"))

#Read mean test data for X and y 
X_test <- read.table(paste0(directory, "test/X_test.txt"))
y_test <- read.table(paste0(directory, "test/y_test.txt"))

#Convert to tibble
X_test <- tbl_df(X_test)
y_test <- tbl_df(y_test)

#Combine all test data and give column names
colnames(X_test) <- features$featureName
colnames(y_test) <- c("activity_labels")
test <- cbind(subject_test, X_test, y_test)
test_data <- tibble::as_tibble(test, vctrs::vec_as_names(names(test)))

#Read training data
subject_train <- read_table(paste0(directory, "train/subject_train.txt"), 
                                   col_names = c("subjectId"))
#Read mean train data for X and y
X_train <- read.table(paste0(directory, "train/X_train.txt"))
y_train <- read.table(paste0(directory, "train/y_train.txt"))

#Convert to tibble
X_train <- tibble::as_tibble(X_train)
y_train <- tibble::as_tibble(y_train)

#Combine all training data and give column names
colnames(X_train) <- features$featureName
colnames(y_train) <- c("activity_labels")
train <- cbind(subject_train, X_train, y_train)
train_data <- tibble::as_tibble(train, vctrs::vec_as_names(names(train)))

#Combine test and training data
all_data <- bind_rows(train_data, test_data)

##################################################################
# 2. Extracts only the measurements on the mean and standard 
# deviation for each measurement. 
##################################################################

#select only variables with mean and std pattern
#also include the subject ID and activity
mean_sd <- select(all_data, c(1, grep(pattern = 'mean\\(\\)|std\\(\\)', 
                                     x = names(all_data))), activity_labels)

############################################################################
# 3. Uses descriptive activity names to name the activities in the data set.
############################################################################

#join data with activity labels as common column to create a new activity name 
#column with the label the same as the activity name
mean_sd_data <- full_join(mean_sd, activity_labels, 
                          by = c("activity_labels" = "activityLabels"))

#Select all data, except the original activity labels column
mean_sd_data <- select(mean_sd_data, -activity_labels)

###########################################################################
# 4. Appropriately labels the data set with descriptive variable names.
###########################################################################

#remove the () for the mean and std name columns
colnames(mean_sd_data) <- gsub(pattern = '\\(\\)', replacement = "", 
                               x = names(mean_sd_data))

##move the activity name column to the second column
mean_sd_data <- mean_sd_data[, c(1, 68, 2:67)]

#Save the tidy data in a txt file
write.table(mean_sd_data, file = paste0(directory, 'tidy_data.txt'), 
            row.names = F, quote = F, sep = "\t")

#############################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
#############################################################################

mean_sd_data_IdAn <- group_by(mean_sd_data, subjectId, activityName) %>% 
  summarise_all(funs(mean))

#Save the new mean tidy data in a txt file
write.table(mean_sd_data_IdAn, file = paste0(directory, 'tidy_data_mean.txt'), 
            row.names = F, quote = F, sep = "\t")
