# 0. Getting data
zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

temp <- tempfile()
download.file(zip_url,temp)

activity_labels <- read.table(unz(temp, file.path("UCI HAR Dataset", "activity_labels.txt")))

features <- read.table(unz(temp, file.path("UCI HAR Dataset", "features.txt")),stringsAsFactors = FALSE)

# train set
x_train <- read.table(unz(temp, file.path("UCI HAR Dataset", "train","X_train.txt")))

subject_train <- read.table(unz(temp, file.path("UCI HAR Dataset", "train","subject_train.txt")))

y_train <- read.table(unz(temp, file.path("UCI HAR Dataset", "train","y_train.txt")))

# test set
x_test <- read.table(unz(temp, file.path("UCI HAR Dataset", "test","X_test.txt")))

subject_test <- read.table(unz(temp, file.path("UCI HAR Dataset", "test","subject_test.txt")))

y_test <- read.table(unz(temp, file.path("UCI HAR Dataset", "test","y_test.txt")))

unlink(temp)

# 1. Merging the training and the test sets to create one data set
train_and_test_dataset <- rbind(x_train, x_test)

# 2. Extracting only the measurements on the mean and standard deviation for each measurement
indexes_of_selected_columns <- which(grepl("std()", features$V2) | grepl("mean()", features$V2))
train_and_test_dataset <- train_and_test_dataset[,indexes_of_selected_columns]

# 3. Using descriptive activity names to name the activities in the data set
# also appending activity vector
activity_vector <- rbind(y_train, y_test)
activity_vector_labeled <- merge(activity_vector, activity_labels, all.x = TRUE)

# also appending subject vector
subject_vector <- rbind(subject_train, subject_test)
train_and_test_dataset <- cbind(train_and_test_dataset, subject_vector, activity_vector_labeled[,2])

# 4. Appropriately labeling the data set with descriptive variable names
names(train_and_test_dataset) <- c(features$V2[indexes_of_selected_columns],"subject", "activity")

# 5. Creating independent tidy data set with the average of each variable for each activity and each subject
library(dplyr)
agg_tidy <- train_and_test_dataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(agg_tidy, "agg_tidy.txt", row.name=FALSE)
