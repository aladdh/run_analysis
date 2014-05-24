# This script reads training and test data from TXT files and
# writes the results to an output TXT file.
#
# Note that this requires the reshape package
#
# A number of assumptions hold.
# 1. All input files reside in the working directory.
# 2. The input files are...
#		activity_labels.txt		numeric and text mappings
#		features.txt			numeric and text mappings
#		subject_train.txt		list of subject IDs for training records
#		y_train.txt				list of activity codes for training records
#		X_train.txt				rows of test data for training records
#		subject_test.txt		list of subject IDs for test records
#		y_test.txt				list of activity codes for test records
#		X_test.txt				rows of test data for test records
# 3. Output is written to a tab separated format file named Samsung_data.txt
# See the README.md file for more details

# read the set of activity codes for mapping codes to text later
acts <- read.table("activity_labels.txt")
names(acts) <-c ("actCode","activity")

# read the full set of feature names from features.txt
feats <- read.table("features.txt")
names(feats) <- c("featCode","featName")
# create a "logical array" which selects those features containing
# either 'mean' or 'std' (in a case-insensitive manner)
dataColsSubset <- grepl("mean()|std()", feats$featName, ignore.case=FALSE)

# READ ALL THE TRAINING DATA

# read the set of people for each record and assign a descriptive name
personColTrain <- read.table("subject_train.txt")
names(personColTrain) <- c("subjectID")

# read the activity codes for each record and...
activityColTrain <- read.table("y_train.txt")
names(activityColTrain) <- c("actCode") 

# read the full set of features, one per column, for each test
dataColsAllTrain <- read.table("X_train.txt")
names(dataColsAllTrain) <- feats$featName
# reduce the data columns to only those features required
dataColsTrain <- dataColsAllTrain[,dataColsSubset]

# bind all these columns for each test together
dfTrain <- cbind(personColTrain, activityColTrain, dataColsTrain)
names(dfTrain)[1] <- "subjectID"
names(dfTrain)[2] <- "activity"


# READ ALL THE TEST DATA

# read the set of people for each record and assign a descriptive name
personColTest <- read.table("subject_test.txt")
names(personColTest) <- c("subjectID")

# read the activity codes for each record and...
activityColTest <- read.table("y_test.txt")
names(activityColTest) <- c("actCode")

# read the full set of features, one per column, for each test
dataColsAllTest <- read.table("X_test.txt")
names(dataColsAllTest) <- feats$featName
# reduce the data columns to only those features required
dataColsTest <- dataColsAllTest[,dataColsSubset]

# bind all these columns for each test together
dfTest <- cbind(personColTest, activityColTest, dataColsTest)
names(dfTest)[1] <- "subjectID"
names(dfTest)[2] <- "activity"


# BIND TRAIN AND TEST DATA ROWS INTO ONE BIG DATA.FRAME

df <- rbind(dfTrain, dfTest)

# CREATE SUMMARY DATA BY AVERAGING ALL VALUES OVER EACH PERSON-ACTIVITY PAIR

# needs reshape package
package_name = "reshape"
is_installed <- function(mypkg) {
	is.element(mypkg, installed.packages()[,1])
}
if (!is_installed(package_name)) {
	install.packages(package_name, repos="http://lib.stat.cmu.edu/R/CRAN")
}
library(package_name, character.only=TRUE, quietly=TRUE, verbose=FALSE)

df1 <- melt(df, id=c("subjectID", "activity"))
df2 <- cast(df1, ... ~ variable, mean)

# ...convert to a descriptive text using activity labels read earlier
map <- setNames(acts$activity, acts$actCode)
df3 <- cbind("subjectID"=df2[,1],
			 "activity"=apply(df2[,1:2], 2, function(x) map[as.character(x)])[,2],
			 df2[,-1:-2])

write.table(df3, file="Samsung_data.txt", sep='\t', row.names=FALSE)