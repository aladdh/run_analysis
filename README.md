## Samsung Mobile Phone Data Analysis

This script reads training and test data from TXT files and writes the results to an output TXT file.

A number of assumptions hold.

* All input files reside in the working directory.

* The input files are...
		activity_labels.txt		numeric and text mappings
		features.txt			numeric and text mappings
		subject_train.txt		list of subject IDs for training records
		y_train.txt				list of activity codes for training records
		X_train.txt				rows of test data for training records
		subject_test.txt		list of subject IDs for test records
		y_test.txt				list of activity codes for test records
		X_test.txt				rows of test data for test records
		
* Output is written to a tab separated file named Samsung_data.txt

The steps used in the process are the following...

* read the list of activity codes from activity_labels.txt for use in converting numeric activity codes into meaningful text

* read the full list of feature names from features.txt and, in a case-insensitive manner, select those that contain either the text "mean()" or "std()"

* read all the training data from 3 files and bind them column-wise into a train set

* read all the test data from 3 files and bind them column-wise into a test set

* bind the train and test data row-wise into a total data set

* use the functions melt and cast from the reshape package to average all data columns over each combination of subject and activity
