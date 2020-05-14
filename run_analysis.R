

##########################  FINAL PROJECT: GETTING & CLEANING DATA ############################


URLF <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## I WILL START BY DOWNLOADING, UNZIPPING AND THEN READING THE INTERESTING FILES:

download.file(URLF, "data.zip")

unzipped <- unzip("data.zip")

unzipped[] ## to display all file paths

README <- read.table("./UCI HAR Dataset/README.txt",stringsAsFactors = F)

Xtrain2 <- read.table("./UCI HAR Dataset/train/X_train.txt" ,stringsAsFactors = F)

Ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt"  ,stringsAsFactors = F)

Stest <- read.table("./UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = F)

Strain <- read.table("./UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = F)

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt"  ,stringsAsFactors = F)

Ytest <- read.table("./UCI HAR Dataset/test/y_test.txt"  ,stringsAsFactors = F)

labels <- read.table("./UCI HAR Dataset/activity_labels.txt" ,stringsAsFactors = F)

features <- read.table("./UCI HAR Dataset/features.txt" ,stringsAsFactors = F)

featuresinfo <- read.delim("./UCI HAR Dataset/features_info.txt" ,stringsAsFactors = F)

## HERE I DO SOME EXPLORING OF THE DATA TO UNDERSTAND CONTENTS AND RELATIVE POSITIONS TO PUT TOGETHER FINAL DF:

table(Ytrain) ### to explore levels (6 -> activities more or less evenly distruted, arond 1,000 of each)
table(Ytest)  ### to explore levels (6 -> activities more or less evenly distruted, arond 500 of each)
table(Stest)  ### to explore subject distribution (9 subjects ->  2, 4, 9, 10,  12,  13,  18,  20, 24)
table(Strain) ### to determine distribution (21 subjects ->  1,  3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30)
anyDuplicated(features) ### to determine if theres is a duplicated variable, it returned "0", therefore it's tidy in that sense.
dim(Xtest)    ### number of rows (2947) match the corresponding columns for Subjects (Stest) and activities (Ytest) for test part.
              ### number of columns (561) match the corresponding variables/features.
dim(Xtrain)   ### number of rows (7352) match the corresponding columns for Subjects (Strain) and activities (Ytrain) for train part.
              ### number of columns (561) match the corresponding variables/features.


### Changing variable names ("features") to something more readable, before proceding to merge
### to fulfill point 4 of the assignment: "Appropriately labels the data set with descriptive variable names."

feat <- features[,2]  ## dropping first column to keep only the names

newfeat <- gsub("^t", "time",feat)   ### correcting "t" for "time"

newfeat2 <- gsub("^f", "freq",newfeat) ### correcting "f" for "freq" to mean "frequency".

colnames(Xtest) <- newfeat2  ### changing variable names for test data

colnames(Xtrain) <- newfeat2  ### changing variable names for train data

## MERGING TEST PART:

merge12_test <- bind_cols(Stest,Ytest)  ## first two columns corresponding to Susbjects and Actvity, respectively.

colnames(merge12_test) <- c("Subject","Activity")  ## naming these first two columns

merging_test <- bind_cols(merge12_test ,Xtest)  ## now merging first two (y) columns with X (test) data


## MERGING TRAIN PART:

merge12_train <- bind_cols(Strain,Ytrain)   ## first two columns corresponding to Susbjects and Actvity, respectively.

colnames(merge12_train) <- c("Subject","Activity") ## for consistency with upper test part, to avoid issues with final row merge

merging_train <- bind_cols(merge12_train ,Xtrain)  ## now merging first two (y) columns with X (test) data

## MERGING TEST + TRAIN FOR FINAL DF:

all_together <- bind_rows(merging_test,merging_train)

dim(all_together)   ## it returns 10.299 by 563, as expected, after merging upper (test) block with lower (train) block.

### CHANGING THE LABELS FOR THE ACTIVITIES WITH mgsub PACKAGE (similar to "gsub"):

all_together$Activity <-  mgsub(final$Activity, labels$V1, labels$V2) ## now all activities feature the corresponding label in col 2.
                                                                      ## to fulfill point 3 of the assignment: "Uses descriptive activity names to name the activities in the data set"

### NOW I WILL NARROW DOWN THE VARIABLES TO THOSE WITH "mean" OR "stardard" VALUES:

### BY LOOKING AT THE VARIABLES THE ONLY VALID ONES CONTAIN THE WORDS "mean()" AND "std()", SO I CAN FILTER BY METACHARACTERS "*mean()*" OR "sdt()*":

grep_col <- grep("Subject|Activity|*std()*|*mean()*", names(all_together)) ## -> localizes the columns/variable names, that fulfill the criteria in variable.
                                                                           ## I also add in "Subject' and "Activity" in the same subsetting code:


DF_for_part_4 <- all_together[,grep_col] ## MY SEMI-TIDY DATA FRAME UP TO PART 4

dim(DF_for_part_4) ## DIMENSIONS OF DF: 10299 ROWS AND 81 COLUMNS



#################################################### PART 5 FROM THIS POINT ON  ####################################################


grouped_df  <- group_by(DF_for_part_4,Subject,Activity) ## Grouping by Subject and Activity, according to my insterpretation of this part ("wide" option)


final_part_5 <- summarise_all(grouped_df, mean)         ## getting the mean for all variables with all possible Subject+Activity pairs
                                                        ## Dimensions 180x81

final_part_5_df <- as.data.frame(final_part_5)          ## transforming back from tbl to DF.

write.table(final_part_5_df, file = "Tidy_DF_final.tx" ,row.names = F) ## my final tidy DF to text (optional step but looks nicer than tbl in R environment)


