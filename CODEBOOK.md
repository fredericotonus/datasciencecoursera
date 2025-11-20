==================================================================

Coursera Data Science Specialization - John Hopkins University



Peer-graded Assignment - Getting and Cleaning Data Course Project

==================================================================

Frederico Silva Tonus



https://github.com/fredericotonus/datasciencecoursera

==================================================================



Variable Descriptions



* raw\_x\_train and raw\_x\_test

Type: Character vector

Description: Raw unprocessed data read directly from text files

Content: Each element contains space-separated numeric values for one record

Dimensions: raw\_x\_train (7,352 elements), raw\_x\_test (2,947 elements)



* cleaned\_x\_train and cleaned\_x\_test

Type: Character matrix

Description: Parsed data where space-separated values are split into individual columns

Processing: Uses str\_split() with regex \\\\s+ to handle multiple spaces

Structure: Matrix format with observations as rows and features as columns



* x\_train and x\_test

Type: Data frame with numeric columns

Description: Cleaned feature measurements converted from character to numeric

Dimensions: 561 columns (features) × 7,352 rows (train) / 2,947 rows (test)

Note: First empty column removed due to leading spaces in original data



* subject\_train and subject\_test

Type: Data frame

Description: Participant identifiers indicating which subject performed in each record

Content: Single column named "subject" with values 1-30

Purpose: Links observations to individual participants



* y\_train and y\_test

Type: Data frame

Description: Activity labels for each record

Content: Single column named "activity" with numeric codes 1-6

Mapping: 1=walking, 2=ascending, 3=descending, 4=sitting, 5=standing, 6=laying



* train\_set and test\_set

Type: Data frame

Description: Complete datasets combining subject IDs, activity labels, and feature measurements

Structure: Column-bound combination of subject\_train/test + y\_train/test + x\_train/test

Dimensions: 563 columns × 7,352 rows (train) / 2,947 rows (test)



* whole\_set

Type: Data frame

Description: Merged dataset combining training and test sets

Processing: Row-bound combination of train\_set + test\_set)

Dimensions: 563 columns × 10,299 rows (7,352 + 2,947 observations)



* features

Type: Character vector

Description: Names of all 561 measurement variables from the original dataset

Content: Index-number and feature name pairs (e.g., "1 tBodyAcc-mean()-X")



* feat

Type: Character matrix

Description: Split feature names separated into index and name components

Structure: Two-column matrix with feature indices and descriptive names



* mean

Type: Integer vector

Description: Indices of features containing "mean" in their names (case-insensitive)

Processing: Created using grep function in features character vector

Purpose: Identifies mean-related measurements for extraction



* std

Type: Integer vector

Description: Indices of features containing "std" (standard deviation) in their names

Processing: Created using grep function in features character vector

Purpose: Identifies standard deviation measurements for extraction



* mean\_std

Type: Integer vector

Description: Combined and sorted indices of mean and standard deviation features

Processing: sort(c(mean, std)) - merges and sorts both index vectors



* new\_mean\_std

Type: Integer vector

Description: Adjusted indices accounting for added subject and activity columns

Processing: adding 2 to each index to shift positions

Purpose: Correcting column positions in the whole\_set dataframe



* mean\_std\_set

Type: Data frame

Description: Subset containing only mean and standard deviation measurements

Content: Subject IDs, activity labels, and 86 selected features

Dimensions: 88 columns × 10,299 rows



* avg\_tidy\_set

Type: Grouped data frame (tibble)

Description: Final tidy dataset with averaged values for each subject-activity combination

Processing: Grouped by subject and activity, then averaged all measurements

Dimensions: 180 rows (30 subjects × 6 activities) × 88 columns

Naming: All measurement columns prefixed with "mean\_" to indicate averaging





