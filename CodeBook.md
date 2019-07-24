---
title: "Data preparation for activity tracking project"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Data
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - University degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Variables
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## Transformations

### 0. Getting data
```{r}
zip_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

temp <- tempfile()
download.file(zip_url,temp)

activity_labels <- read.table(unz(temp, file.path("UCI HAR Dataset", "activity_labels.txt")))

features <- read.table(unz(temp, file.path("UCI HAR Dataset", "features.txt")),stringsAsFactors = FALSE)
``` 

#### train set
```{r}
x_train <- read.table(unz(temp, file.path("UCI HAR Dataset", "train","X_train.txt")))

subject_train <- read.table(unz(temp, file.path("UCI HAR Dataset", "train","subject_train.txt")))

y_train <- read.table(unz(temp, file.path("UCI HAR Dataset", "train","y_train.txt")))
````

#### test set
```{r}
x_test <- read.table(unz(temp, file.path("UCI HAR Dataset", "test","X_test.txt")))

subject_test <- read.table(unz(temp, file.path("UCI HAR Dataset", "test","subject_test.txt")))

y_test <- read.table(unz(temp, file.path("UCI HAR Dataset", "test","y_test.txt")))

unlink(temp)
```

### 1. Merging the training and the test sets to create one data set.
```{r}
train_and_test_dataset <- rbind(x_train, x_test)
```

### 2. Extracting only the measurements on the mean and standard deviation for each measurement.
```{r}
indexes_of_selected_columns <- which(grepl("std()", features$V2) | grepl("mean()", features$V2))
train_and_test_dataset <- train_and_test_dataset[,indexes_of_selected_columns]
```
### 3. Using descriptive activity names to name the activities in the data set.
 also appending activity vector
```{r}
activity_vector <- rbind(y_train, y_test)
activity_vector_labeled <- merge(activity_vector, activity_labels, all.x = TRUE)
```
also appending subject vector
```{r}
subject_vector <- rbind(subject_train, subject_test)
train_and_test_dataset <- cbind(train_and_test_dataset, subject_vector, activity_vector_labeled[,2])
```

### 4. Appropriately labels the data set with descriptive variable names.
```{r}
names(train_and_test_dataset) <- c(features$V2[indexes_of_selected_columns],"subject", "activity")
```

### 5. Creating independent tidy data set with the average of each variable for each activity and each subject.
```{r}
library(dplyr)
agg_tidy <- train_and_test_dataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(agg_tidy, "agg_tidy.csv", row.name=FALSE)
```

