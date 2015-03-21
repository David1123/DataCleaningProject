library(plyr)
library(dplyr)

#Reading train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)

#Reading test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)

#Reading labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

#Matching activity names
Y_test <- join(Y_test,activity_labels,by="V1")
Y_train <- join(Y_train,activity_labels,by="V1")

#Joining parts of test/train data
test <- cbind(subject_test,Y_test$V2, X_test)
train <- cbind(subject_train,Y_train$V2, X_train)

#Combining test and train data, and setting column names
final <- rbind(test,train)
names(final) <- c("subject", "activity", features$V2)


#Subsetting by relevant columns (means, std etc)
final <- final[grep("mean[(][)]|std[(][)]|subject|activity",names(final),ignore.case = TRUE)]

#Improving column names (valid column names, readability)
names(final) <- make.names(names(final),unique=TRUE)
names(final) <- gsub("[.]","",names(final))
names(final) <- gsub("mean","Mean",names(final))
names(final) <- gsub("std","Std",names(final))

#Creation of dataframe that averages by subject and activity
reduced <- group_by(final,subject,activity)
reduced <- summarise_each(reduced,funs(mean))

#Writing dataframe to text file
write.table(reduced, file = "TidyData.txt",row.name=FALSE)
