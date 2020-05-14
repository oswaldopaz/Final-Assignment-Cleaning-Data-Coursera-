

##########################  FINAL PROJECT: GETTING & CLEANING DATA ############################

Dear reader/marker: this file is intended to explain the script "run_analysis.R" BUT mostly in the context of
Coursera's final project assignment for the "Getting and Cleaning Data" course, so it will abound in details and reasoning
behind the way it was approched and the assumptions taken. I am a beginner in Data Sience with very little experience in R,
therefore I took a step-by-step approach, very conservative, and trying to stick to the contents/packages taught in the videos
of the course.

Firstly I should give some credit to the references and authors that I referred to, which include: "Getting & Cleaning Data: The Assignment"
by David Hood, the famous "Tidy Data: by Hadley Wickham, as well as the numerous Q&As posted by my peers in the forum.

Note to markers before moving on: Please use "Notepad++" or similar to read my text file in Coursera to getdata%2Fprojectfiles%2FUCI%20HAR%20Dataseta decent view of th contents,
MS Notepad or WordPad.

I) A little background information:

Without going into too much details, the data collected for this project came from a experiment with 30 subjects split into two groups: "test" and "train" with 30%-70% distribution
respectively and tasked with 6 different activities (exercises)  from which plenty of measurements were made. The data were abundant with  wide variaty of measurements that included means 
and stardard deviation in some of them. Some read files were provided to describe the activity, which helped to figure out how to construct the original data set.

The whole purpose of the the 5 different parts that comprise this project for the course, in my understanding, is getting, manipulating/cleaning and reshaping the raw data to produce
a "tidy" data frame that complies with all the requirements set forth through parts 1 to 5. In its broadest sense, a tidy data set should comply with at least the following premises:

1) Each variable forms a column.
2) Each observation forms a row.
3) Each time of observational unit forms a table.

The packages used included: dplyr, tidyr and mgsub.

II) Part 1: "Merges the training and the test sets to create one data set."

After checking all available information, including the README text files, Hood's guidelines, and noticing the naming conventions with Y's and X's, and the data sets dimensions
I finally figured out how to assemble the orignal data frame. I proceeded step by step by making two blocks (test and train), and merging  them together by rows in the final step.
First I merged  the first two columns of Subjects and Activities for both blocks and then merged the bulk of the actual values. After getting the upper (test) and lower (train) blocks
I merged them together using bind_rows. The dimensions at this point were 10.299 by 563.

Note on getting the data: I used "read.table' after downloading the different data sets, because it is the "mother" of this package and it had the right default values (I used read.delim
initially but I had some issues with the X data in the delimeters part, so I played safe with read.table that got me clean DFs). I also chose "stringsAsFactors = FALSE) becase I didn't 
expect to be dealing with qualitative values but mostly quatitative. From the information I assumed I didn't need the "Initial Signals" data, which ended up being a good assumption.


III) Part 2: "Extracts only the measurements on the mean and standard deviation for each measurement."

I made use of "grep" for this. By looking at the variables I noticed that the ones that fulfilled the requirements contained either "mean()" or "std()", so I filtered
with METACHARACTERS "*mean()*" OR "*sdt()*". By the way, at this point I had already covered parts 3 and 4 of the assignment, so basically narrowing down the DF was my last step
 and I only noticed it at the end but it doesn't really  matter and obviously the final result doesn't change. The resulting DF narrowed down to 10.299 by 81.

IV) Part 3: "Uses descriptive activity names to name the activities in the data set".

For this part I just used "mgsub" package, which is similar to gsub, but found it cleaner and more straight forward for the task. I used the provided labels file for this.


V) Part 4: "Appropriately labels the data set with descriptive variable names.".

I had to think about this because, at least to me, the variable names were already quite descriptive, in the sense that they had no underscores or dots or spaces. Anyway, following some comments
in the forum and for the sake of fulfilling the excercise, I figured I could change the names that started with a "t" like "tBodyAcc-mean()-X" to "timeBodyAcc-mean()-X" and those which started
with "f" to "freq" to mean "frequency" (these were not free assumptions but rather based on the read.me files provided). I used gsub for this actually at the beginning of the script.

VI) Part 5: "From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

I also had to think about this for quite a while but at teh end I figured that there was no really right or wrong interpretation as long as I understood what I was doing. Therefore I 
assumed that I was being asked to "fix" Subject + Activities variables and average the rest of the data (values) for every unique pair ("wide" approach), and "group_by" + "summarize" suited 
me just fine for the task. I considered using "reshape2" which probably was more efficient coding, but decided to stick to what was taught in the course instead. Resulting dimensions: 180x81, 
and the DF was finally tidy since the last operation had taken care of the repeated Subject+Activity pairs. Now the DF complies with all three premises mentioned before.

Final words: I also did a lot of exploring to make sure I was going in teh right direction and the results were making sense along teh way, particularly when putting together teh initial
data frame. Some of the code I left in the script, as teh following:


table(Ytrain) ### to explore levels (6 -> activities more or less evenly distruted, arond 1,000 of each)
table(Ytest)  ### to explore levels (6 -> activities more or less evenly distruted, arond 500 of each)
table(Stest)  ### to explore subject distribution (9 subjects ->  2, 4, 9, 10,  12,  13,  18,  20, 24)
table(Strain) ### to determine distribution (21 subjects ->  1,  3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30)
anyDuplicated(features) ### to determine if theres is a duplicated variable, it returned "0", therefore it's tidy in that sense.
dim(Xtest)    ### number of rows (2947) match the corresponding columns for Subjects (Stest) and activities (Ytest) for test part.
              ### number of columns (561) match the corresponding variables/features.
dim(Xtrain)   ### number of rows (7352) match the corresponding columns for Subjects (Strain) and activities (Ytrain) for train part.
              ### number of columns (561) match the corresponding variables/features.

The other "extra work" I didn't leave in the script but was very beneficial to me,an inexperienced programmer, to get more familiar and dexterous with the coding.

Hopefully this text clarified my line of thought and approach to this assignment, which by the way I found challenging but very rewarding when finished.

I think a small subset of the final DF is in order, to close this document:

 final_part_5_df[1:15,1:6]
   Subject           Activity timeBodyAcc-mean()-X timeBodyAcc-mean()-Y timeBodyAcc-mean()-Z timeBodyAcc-std()-X
1        1             LAYING            0.2215982         -0.040513953          -0.11320355         -0.92805647
2        1            SITTING            0.2612376         -0.001308288          -0.10454418         -0.97722901
3        1           STANDING            0.2789176         -0.016137590          -0.11060182         -0.99575990
4        1            WALKING            0.2773308         -0.017383819          -0.11114810         -0.28374026
5        1 WALKING_DOWNSTAIRS            0.2891883         -0.009918505          -0.10756619          0.03003534
6        1   WALKING_UPSTAIRS            0.2554617         -0.023953149          -0.09730200         -0.35470803
7        2             LAYING            0.2813734         -0.018158740          -0.10724561         -0.97405946
8        2            SITTING            0.2770874         -0.015687994          -0.10921827         -0.98682228
9        2           STANDING            0.2779115         -0.018420827          -0.10590854         -0.98727189
10       2            WALKING            0.2764266         -0.018594920          -0.10550036         -0.42364284
11       2 WALKING_DOWNSTAIRS            0.2776153         -0.022661416          -0.11681294          0.04636668
12       2   WALKING_UPSTAIRS            0.2471648         -0.021412113          -0.15251390         -0.30437641
13       3             LAYING            0.2755169         -0.018955679          -0.10130048         -0.98277664
14       3            SITTING            0.2571976         -0.003502998          -0.09835792         -0.97101012
15       3           STANDING            0.2800465         -0.014337656          -0.10162172         -0.96674254

With warm regards,
Your humble (yet-to-be) Data Scientist.