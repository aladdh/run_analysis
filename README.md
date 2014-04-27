## Samsung Mobile Phone Data Analysis

This script reads training and test data from TXT files and writes the results to an output TXT file.

A number of assu,mptions hold.
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
* Output is written to a CSV-format file named Samsung_data.txt
