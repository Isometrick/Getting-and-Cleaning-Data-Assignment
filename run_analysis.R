## This script is used to clean data collected from the accelerometers from the Samsung Galaxy S smartphone.

## Ensure that your working directory has the unzipped data folder named "getdata-projectfiles-UCI HAR Dataset"

## Reading all required data files into R
ft <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
act <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
ttsbj <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
ttx <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
tty <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
trsbj <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
trx <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
try <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

## Naming the column in data file subject
names(ttsbj) <- "Subject"
names(trsbj) <- "Subject"

## Naming the column in data file y
names(tty) <- "Activity"
names(try) <- "Activity"

## Naming the features in data file X
names(ttx) <- ft[,2]
names(trx) <- ft[,2]

## Locating the required features (mean and standard deviation)
mn <- grep("-mean()",ft[,2],fixed=TRUE)
std <- grep("-std()",ft[,2],fixed=TRUE)
mnstd <- sort(c(mn,std))

## Extracting the required features from data file X
ttx2 <- ttx[,mnstd]
trx2 <- trx[,mnstd]

## Combining the 3 data files Subject, X, y into 1 object
tt <- cbind(ttsbj, tty, ttx2)
tr <- cbind(trsbj, try, trx2)

## Combining the test and train data files into 1 object
data <- rbind(tt,tr)

## Renaming the Activity column with activity names
data[,2] <- factor(data[,2], levels = act[,1], labels = act[,2])


## Creating a new data frame with combined subject and activity column
SubjAct <- paste0(data$Subject, data$Activity)
data2 <- cbind(SubjAct, data[,3:68])

## Taking the mean of each factor
summ <- apply(data2[,2:67], 2, function(x) tapply(x, data2[,1], mean))

## Saving tidy data set into a text file
write.table(summ, file = "tidy.txt", row.name=FALSE)