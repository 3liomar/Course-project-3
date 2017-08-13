STEP 1: Merges the training and the test sets to create one data set.

        The data set consist initially for 4 tables: 
        
        -activity labels, (is a list to merge with train and test data) 
        -features, (is a list to merge with train and test data)
        -train and 
        -test
        
        First the script make the activity labels table, reading data from "activity_labels.txt" 
        And features table, reading data from "features.txt". The first set contains the descriptive names of activity labels that the data have for identifying each row in the set. In the other hand, the second have the name of the variables that are in the "x_test.txt" and "x_train.txt" files.
        
        Next the script makes the test set, and the train set. For the construction of this two sets, first this script takes the data from "subject_test.txt" and "subject_train.txt" (contains the subject ID, for each row of the set). Then, take the measurements of each variable in the "x_test.txt" file (the name of each variable is taken from features data set) and take the activity id's from the "y_test.txt" file for each row. 
        
        Next, with a loop, the scrip takes the data of every file (that represents one variable, and their rows represents one measurement) in the inertial signals folder for each set, and calculates the mean and standard deviation for each measurement, adding 1 column for the mean of variable, and one column for the std, for each file (variable).
        
        For the name of each variable (file), the script takes the name of the file and paste it "mean" and "std", for each case.
        
        All of this variables, are joint in one table for each case (train and test), using cbind function.
        
        the script creates a columns for specify the type of set (train or test)
        
        After all, the script proceed to clean the names (the _test.txt and _train.txt that become from the file name in the inertial signal folder) of the variables and removing uppercases. The objective of this cleaning is to make the train and test set merge, having the same name columns for both sets.
        
        The train and test data sets are merged using the rbind function.


STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

        Then, the script take just the variables related to the identification of each row (subject, activity labels and set) and the result of the measurement for each variable.


STEP 3: Uses descriptive activity names to name the activities in the data set

        After all, the script assigns activities names to the activities labels, using the data of the activity labels table (merging the set table with the activity_labels table by activity labels). 

STEP 4: Appropriately labels the data set with descriptive variable names.

        This step was make in the previous steps

STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

        For the step 5 set, first select the id variables (the first 3 columns: activitynames + subject + set) and the measure variables (all except the first 3 columns) using the melt function.
        
        Then, it generate the mean for each variable for each activity name and subject using the dcast function.
        
        At the end, it generates the clean dataset.txt, with the data set of the step 5.
