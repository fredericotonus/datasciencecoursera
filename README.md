==================================================================

Coursera Data Science Specialization - John Hopkins University



Peer-graded Assignment - Getting and Cleaning Data Course Project

==================================================================

Frederico Silva Tonus



https://github.com/fredericotonus/datasciencecoursera

==================================================================



The Course Project starts with some txt files about experiments on human activity recognition using smartphones. They contain a explanation of how the experiments were conducted and 

a presentation of the resulting data. The data itself is split in more than one file, and not in an intuitive and understandable way. So the first step was to find a solution to this 

problem of data messiness. The data cleaning methods learned along the course needed to be put to the test. 



Basically there were two sets to be cleaned and organized, each one regarding to a part or group of the experiment: training and test. The initial objective was to get a final dataframe with all the records of both parts of the experiment (training and test) as rows and all the variables as columns (subject + activity + 561 features).



With the aim of cleaning the sets and getting them together, first of all I needed to figure out how to read them and put them in a dataframe. To do so, I had to read the sets as a 

character vector using the readLines function (the code lines refer to the training set, but they are the same for the test set either). 



* raw\_x\_train <- readLines("./UCI HAR Dataset/train/x\_train.txt")





Then I had to get out of vectors the values by using the function str\_split from stringr library. I used the criterion "\\\\s+", which stands for one or more spaces and returned the result as a matrix.



* cleaned\_x\_train <- str\_split(raw\_x\_train, "\\\\s+", simplify = TRUE)





The next step was to turn that matrix into a dataframe, converting all the strings to numeric class. As a result, I got a dataframe with rows representing the records of the experiment 

and 562 columns. Since it is told in the README that there were 561 features, I investigated the extra column and noticed it was all NAs. So I subsetted the sets so as to get rid of this

column. 



* x\_train <- as.data.frame(apply(cleaned\_x\_train, 2, as.numeric))
* x\_train <- x\_train\[1:7352, 2:562]





Yet the sets lacked two variables, subject and activities, which were in other txt files. Since there was no need to split their data, I could read them directly as a dataframe with the

read.delim function. 



* subject\_train <- read.delim("./UCI HAR Dataset/train/subject\_train.txt", header=FALSE)
* colnames(subject\_train) <- "subject"



* y\_train <- read.delim("./UCI HAR Dataset/train/y\_train.txt", header=FALSE)
* colnames(y\_train) <- "activity"





1\. Merging the training and the test sets into one dataset.



So now I had three datasets for each part: one with subjects identifiers, one with the activities labels and one with the records of all 561 features. To join them together, I simply 

used cbind function, and then I got one dataset for training data and another for test data. Finally, with rbind function I merged them to achieve the goal of the first part of 

the assignment - a whole dataset that contained the training and test data. 



* train\_set <- cbind(subject\_train, y\_train, x\_train)
* whole\_set <- rbind(train\_set, test\_set)





Data Flow:

Raw Text Files →  Parsed Matrix   → Numeric Dataframe → Bound Dataset → Merged Dataset

&nbsp;    ↓                  ↓                  ↓                 ↓                ↓

x\_train.txt    →  cleaned\_x\_train → numeric x\_train   → train\_set     →   whole\_set

x\_test.txt     →  cleaned\_x\_test  → numeric x\_test    → test\_set      ⬈





Final Dataset Structure

The merged whole\_set contains:



10,299 observations (7,352 training + 2,947 test)

563 variables:

* subject: Participant identifier (1-30)
* activity: Activity code (1-6)
* 561 feature measurements 





2\. Extracting the measurements on the mean and standard deviation for each measurement.



The key to this item was in the list of features (features txt file) that had all 561 features measured by each record of the experiment. It was read as a character vector in order to 

extract only the features that were either mean or standard deviation measurements. To do such a extraction the grep function was used with the use of regular expressions.



* features <- readLines("./UCI HAR Dataset/features.txt")
* mean <- grep("mean", features, ignore.case=TRUE)
* std <- grep("std", features, ignore.case=TRUE)





Then I wrote a code that combined mean and standard deviation indices into a single vector and sorted them in ascending order. Then I added 2 to each index of this vector to account for the addition of subject and activity columns in the main dataset. 



* mean\_std <- sort(c(mean, std))
* new\_mean\_std <- mean\_std + 2





The final purpose here was to create a new dataset containing only columns with subject and activity labels and columns identified in new\_mean\_std (mean and standard deviation measurements)



* mean\_std\_set <- whole\_set\[, c(1:2, new\_mean\_std)]





That resulted in a dataset with 88 variables (2 identifiers + 86 measurements) and 10,299 observations.







3\. Naming the activities with descriptive names in the dataset as follows: 1 walking / 2 ascending / 3 descending / 4 sitting / 5 standing / 6 laying



In order to make this replacement, I used magrittr package for pipe operations to chain all the replacements, which were executed by the gsub function:



* mean\_std\_set$activity %<>% 

&nbsp;	 gsub(1, "walking", .) %>%

&nbsp;	 gsub(2, "ascending", .) %>%

&nbsp;	 gsub(3, "descending", .) %>%

&nbsp;	 gsub(4, "sitting", .) %>%

&nbsp;	 gsub(5, "standing", .) %>%

&nbsp;	 gsub(6, "laying", .)







4\. Labeling appropriately the dataset with descriptive variable names.



The following code splits the feature names using regular expression "\\\\s+" (one or more whitespace characters) and creates a matrix where the second column contains the actual feature 

names.



* feat <- str\_split(features, "\\\\s+", simplify = TRUE)





The next code applies the descriptive names using indices in the mean\_std vector to columns 3-88 of the dataset named mean\_std\_set.



* colnames(mean\_std\_set)\[3:88] <- feat\[, 2]\[mean\_std]







5\. Creating a new tidy dataset with the average of each variable for each subject and each activity.



The final code groups data by subject (30 individuals) and activity (6 types) and the cCalculates the mean for each measurement variable within each group. Besides it creates new 

variable names prefixed with "mean\_" to indicate they are averaged values. This was achieved with the use of group\_by and summarize functions chained with %>% operator, both from dplyr package.



The result is a tidy dataset with 180 rows (30 subjects × 6 activities) and 88 columns, assigned as avg\_tidy\_set.



* avg\_tidy\_set <- mean\_std\_set %>%  group\_by(subject, activity) %>%  summarize(across(.cols = 1:86, .fns = ~mean(., na.rm=TRUE), .names = "mean\_{.col}"))





Data Structure

The processed data follows tidy data principles:

* Each variable forms a column
* Each observation forms a row
* Each type of observational unit forms a table
