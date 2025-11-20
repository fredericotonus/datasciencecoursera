### In order to clean the sets and get them together, first of all we need to
### figure out how to read them and put them in a dataframe. To do so, we must
### read the sets as a character and get out of them the values by using the 
### function str_split from stringr library. The objective is to get a final 
### dataframe with all the records of both parts of the experiment (training and
### test) as rows and all the variables as columns (subject + activity + 561 features).

library(stringr)

## Section 1: Cleaning the training dataset

# read x_train dataset as a character
raw_x_train <- readLines("./UCI HAR Dataset/train/x_train.txt")

# split the data in each element of the above character separated by one or more spaces
# and turn it into a matrix with simplify
cleaned_x_train <- str_split(raw_x_train, "\\s+", simplify = TRUE)

# transform the above matrix into a dataframe with numeric class columns
x_train <- as.data.frame(apply(cleaned_x_train, 2, as.numeric))

# first column is full of NAs, so drop it
x_train <- x_train[1:7352, 2:562]

# read subject_train dataset as a dataframe and name its only variable as "subject"
subject_train <- read.delim("./UCI HAR Dataset/train/subject_train.txt", header=FALSE)
colnames(subject_train) <- "subject"

# read y_train dataset as a dataframe and name its only variable as "activity"
y_train <- read.delim("./UCI HAR Dataset/train/y_train.txt", header=FALSE)
colnames(y_train) <- "activity"

# create the final training dataset by combining all previous read or created 
# dataframes in this section
train_set <- cbind(subject_train, y_train, x_train)


## Section 2: Cleaning the test dataset

# read x_test dataset as a character
raw_x_test <- readLines("./UCI HAR Dataset/test/x_test.txt")

# split the data in each element of the above character separated by one or more spaces
# and turn it into a matrix with simplify
cleaned_x_test <- str_split(raw_x_test, "\\s+", simplify = TRUE)

# transform the above matrix into a dataframe with numeric class columns
x_test <- as.data.frame(apply(cleaned_x_test, 2, as.numeric))

# first column is full of NAs, so drop it
x_test <- x_test[1:2947, 2:562]

# read subject_test dataset as a dataframe and name its only variable as "subject"
subject_test <- read.delim("./UCI HAR Dataset/test/subject_test.txt", header=FALSE)
colnames(subject_test) <- "subject"

# read y_test dataset as a dataframe and name its only variable as "activity"
y_test <- read.delim("./UCI HAR Dataset/test/y_test.txt", header=FALSE)
colnames(y_test) <- "activity"

# create the final test dataset by combining all previous read or created 
# dataframes in this section
test_set <- cbind(subject_test, y_test, x_test)


## Section 3: Answering the items

### 1. Merging the training and the test sets into one dataset.
whole_set <- rbind(train_set, test_set)
str(whole_set)
# 'data.frame':	10299 obs. of  563 variables:
# $ subject                                 : int  1 1 1 1 1 1 1 1 1 1 ...
# $ activity                                : int  5 5 5 5 5 5 5 5 5 5 ...
# $ V2                                      : num  0.289 0.278 0.28 0.279 0.277 ...
# $ V3                                      : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
# $ V4                                      : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
# $ V5                                      : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
# ...


### 2. Extracting the measurements on the mean and standard deviation for each
### measurement.

# read features dataset as a character
features <- readLines("./UCI HAR Dataset/features.txt")

# extract the mean measurements with a regular expression using grep function
mean <- grep("mean", features, ignore.case=TRUE)

# extract the standard deviation measurements with a regular expression using 
# grep function
std <- grep("std", features, ignore.case=TRUE)

# combine both vectors sorting it in ascending order
# then sum 2 to the resulting vector, since the column indexes of the features
# have been moved in the whole_set by the adding of two other variables
mean_std <- sort(c(mean, std))
new_mean_std <- mean_std + 2

# dataset with only the extracted variables
mean_std_set <- whole_set[, c(1:2, new_mean_std)]
str(mean_std_set)
# 'data.frame':	10299 obs. of  88 variables:
# $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
# $ activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
# $ V2                                  : num  0.289 0.278 0.28 0.279 0.277 ...
# $ V3                                  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
# $ V4                                  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
# $ V5                                  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
# ...


### 3. Naming the activities with descriptive names in the dataset as follows:
### 1 walking / 2 ascending / 3 descending / 4 sitting / 5 standing / 6 laying

# replace the numbers with their correspondent descriptive names on the activity column
# call magrittr library for using %<>% and %>% operators
library(magrittr)
mean_std_set$activity %<>% 
  gsub(1, "walking", .) %>%
  gsub(2, "ascending", .) %>%
  gsub(3, "descending", .) %>%
  gsub(4, "sitting", .) %>%
  gsub(5, "standing", .) %>%
  gsub(6, "laying", .)


### 4. Labeling appropriately the dataset with descriptive variable names.

# resuming features vector, split it in each element separated by one or more spaces
# and turn it into a matrix with simplify
feat <- str_split(features, "\\s+", simplify = TRUE)

# the second column of the resulting matrix gets the feature names
feat[, 2]
# [1] "tBodyAcc-mean()-X"                    "tBodyAcc-mean()-Y"                   
# [3] "tBodyAcc-mean()-Z"                    "tBodyAcc-std()-X"                    
# [5] "tBodyAcc-std()-Y"                     "tBodyAcc-std()-Z"                    
# [7] "tBodyAcc-mad()-X"                     "tBodyAcc-mad()-Y"                    
# [9] "tBodyAcc-mad()-Z"                     "tBodyAcc-max()-X"                    
# [11] "tBodyAcc-max()-Y"                    "tBodyAcc-max()-Z" 
# ...

# rename the mean_std_set dataframe variables with the features names that contain
# the expressions "mean" or "std", from V2 (3rd column) until the end
colnames(mean_std_set)[3:88] <- feat[, 2][mean_std]
str(mean_std_set)
# 'data.frame':	10299 obs. of  88 variables:
# $ subject                             : int  1 1 1 1 1 1 1 1 1 1 ...
# $ activity                            : chr  "standing" "standing" "standing" "standing" ...
# $ tBodyAcc-mean()-X                   : num  0.289 0.278 0.28 0.279 0.277 ...
# $ tBodyAcc-mean()-Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
# $ tBodyAcc-mean()-Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
# $ tBodyAcc-std()-X                    : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
# ...


### 5. Creating a new tidy dataset with the average of each variable for each subject
### and each activity.

# To achieve that, we need dplyr library
library(dplyr)

# With %>% operator, it is easier to write a more logical and intuitive code line
avg_tidy_set <- mean_std_set %>%
  group_by(subject, activity) %>% # first we indicate the variables to be grouped
  summarize(across(               # then we apply the mean function to the other columns and
    .cols = 1:86,                   # rename them
    .fns = ~mean(., na.rm=TRUE),
    .names = "mean_{.col}"
  ))

# Taking into consideration the intersection between the two grouped variables, we
# end up with 180 "groups" (30 individuals X 6 activities). So the final dataframe
# (called avg_tidy_set) must have 180 rows and 88 columns - besides the two grouped
# variables, the other are the mean of all that variables which contain the expressions
# "mean" and "std" in their names. Thus, we have:

str(avg_tidy_set)
# gropd_df [180 × 88] (S3: grouped_df/tbl_df/tbl/data.frame)
# $ subject                     : int [1:180] 1 1 1 1 1 1 2 2 2 2 ...
# $ activity                    : chr [1:180] "ascending" "descending" "laying" "sitting" ...
# $ mean_tBodyAcc-mean()-X      : num [1:180] 0.255 0.289 0.222 0.261 0.279 ...
# $ mean_tBodyAcc-mean()-Y      : num [1:180] -0.02395 -0.00992 -0.04051 -0.00131 -0.01614 ...
# ...

head(avg_tidy_set)
# A tibble: 6 × 88
# Groups:   subject [1]
# subject activity   `mean_tBodyAcc-mean()-X` `mean_tBodyAcc-mean()-Y` `mean_tBodyAcc-mean()-Z`
#      <int> <chr>                       <dbl>                    <dbl>                    <dbl>
# 1       1 ascending                     0.255                 -0.0240                   -0.0973
# 2       1 descending                    0.289                 -0.00992                  -0.108 
# 3       1 laying                        0.222                 -0.0405                   -0.113 
# 4       1 sitting                       0.261                 -0.00131                  -0.105 
# 5       1 standing                      0.279                 -0.0161                   -0.111 
# 6       1 walking                       0.277                 -0.0174                   -0.111 
# ℹ 83 more variables: `mean_tBodyAcc-std()-X` <dbl>, `mean_tBodyAcc-std()-Y` <dbl>...