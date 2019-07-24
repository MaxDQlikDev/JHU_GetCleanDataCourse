---
title: "Data preparation for activity tracking project"
output: github_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## About

This repository is the peer-graded course project submission (Getting and Cleaning Data course). Data preparation for activity tracking project was performed using skills and knowledge studied.

## Files
- "CodeBook.md" - description of dataset, variables and transformation performed.

- "run_analysis.R" - script for data preparation. Includes performing required steps in course project task.
0. Getting data
1. Merging the training and the test sets to create one data set
2. Extracting only the measurements on the mean and standard deviation for each measurement
3. Using descriptive activity names to name the activities in the data set
4. Appropriately labeling the data set with descriptive variable names
5. Creating independent tidy data set with the average of each variable for each activity and each subject

- "agg_tidy.csv" - resulting aggregated output tidy data for further analysis.