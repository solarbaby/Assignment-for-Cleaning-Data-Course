#y_test and y_train tell which type of activity the person is doing 
#(activity_labels.txt gives the corresponding activity for each number 1-6)

#X_test and X_train have 561 different variables -- they correspond to values in features


activity_labels=read.table("UCI HAR Dataset/activity_labels.txt")
features=read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)
names(features)=c("value", "name")

features$name<-gsub("[[:punct:]]", "", tolower(features$name))

y_test=read.table("UCI HAR Dataset/test/y_test.txt")
X_test=read.table("UCI HAR Dataset/test/X_test.txt")
subject_test=read.table("UCI HAR Dataset/test/subject_test.txt")

y_train=read.table("UCI HAR Dataset/train/y_train.txt")
X_train=read.table("UCI HAR Dataset/train/X_train.txt")
subject_train=read.table("UCI HAR Dataset/train/subject_train.txt")

#concatinate the training/test data

y_vals=rbind(y_train, y_test)
names(y_vals)="Activity"
X_vals=rbind(X_train, X_test)

#add the names
names(X_vals)=features$name

#add in the subjects
subject_vals=rbind(subject_train, subject_test)
names(subject_vals)="Subject"

#subselect just mean/stds
data_set=cbind(subject_vals, y_vals, X_vals)
meanstd_names=grep("mean|std", names(X_vals))
myvars=features$name[meanstd_names]
myvars=c("Subject", "Activity", myvars)
data_subset=data_set[myvars]

#take averages over Subject and Activity
average_data_subset<-aggregate(.~Subject+Activity, data=data_subset, FUN=mean)

#Output tidy data set
write.csv(average_data_subset, file="tidy_data_set.csv")
