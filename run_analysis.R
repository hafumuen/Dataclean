#Preparation
#Download data to local directory, 'User' by default
install.packages("data.table")
install.packages("plyr")
library(plyr)
library(data.table)
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

# Read data needed separately from the unzipped folder and convert them to characters
features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
y_train <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
data_train <-  data.frame(subject_train, y_train, x_train)
names(data_train) <- c(c('subject_id', 'activity_type'), features)
names(data_train)

x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
y_test <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
subject_test <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')
data_test <-  data.frame(subject_test,y_test,x_test)
names(data_test) <- c(c('subject_id', 'activity_type'), features)
names(data_test)
# Answer 1
data_merged <- rbind(data_train,data_test)

# Answer 2
mean_std <- grep('mean|std', features)
data_mean_std <- data_merged[,c(1,2,mean_std+2)]
# Answer 3
activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data_mean_std$activity_type <- activity.labels[data_mean_std$activity_type]

# Answer 4
names(data_mean_std) <- gsub("[(][)]", "", names(data_mean_std))
names(data_mean_std) <- gsub('Acc',"Acceleration",names(data_mean_std))
names(data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(data_mean_std))
names(data_mean_std) <- gsub('Gyro',"AngularSpeed",names(data_mean_std))
names(data_mean_std) <- gsub('Mag',"Magnitude",names(data_mean_std))
names(data_mean_std) <- gsub('^t',"TimeDomain.",names(data_mean_std))
names(data_mean_std) <- gsub('^f',"FrequencyDomain.",names(data_mean_std))
names(data_mean_std) <- gsub('\\.mean',".Mean",names(data_mean_std))
names(data_mean_std) <- gsub('\\.std',".StandardDeviation",names(data_mean_std))
names(data_mean_std) <- gsub('Freq\\.',"Frequency.",names(data_mean_std))
names(data_mean_std) <- gsub('Freq$',"Frequency",names(data_mean_std))
names(data_mean_std)

#Answer 5

tidy_data <- ddply(data_mean_std, c("subject_id","activity_type"), numcolwise(mean))
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)






