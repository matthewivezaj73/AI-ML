# Week 3 Programming Assignment, IT 540: Random Forest

# A description of the dataset may be found at:
# http://archive.ics.uci.edu/ml/datasets/Heart+Disease
# It is extremely important to read such descriptions, which can often
# inform you of peculiarities of the data that you may need to change
# before performing an analysis, or whether or not the data file contains
# a header line that has the names of the variables (columns).

# In what follows, any line that is commented out with THREE hash symbols ###
# indidates a line or section where you need to write some code.

### Task 1. 4 points Get the data from:
### http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data
### And put that data in whatever location you wish on your computer.
### You can do that manually, if you wish.  If you want 3 additional points of
### extra credit, you can figure out a way to do it programmatically in R.
cleveland_data = read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data", header=TRUE)
write.csv(cleveland_data, file = "C:\\Users\\matth\\OneDrive\\cleveland_data.csv")

### Task 2. 4 points. Point your working directory to where your input data is.
### setwd(<your code here>) # delete the angle brackets < and >
setwd("C:\\Users\\matth\\OneDrive\\Desktop\\")
library("randomForest") # Install this package before you run this line!

# When you read your data in, it matters whether your data has a header
# row or not.  The default assumption for read.csv is that your data does 
# contain a header row, but read.table's assumption is that
# there is no header. With either function, you may need to override the default.
# Type '?read.csv' or ?read.table to see the list of parameters and their defaults.

### Task 3. 6 points. Read your data into a variable.
### Make sure you treat the existence of a header (or lack of) correctly,
### so you'll have to find out if the raw data contains one or not.

heart.data <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data",
                         sep = ",")

# If you did that correctly, you should now see the following in the
# upper right window of RStudio: heart.data    303 obs. of 14 variables

### Task 4. 12 points Add some additional code to do some initial data exploration.
### Read the following comments before you do this! Use AT LEAST TWO of the
### data visualization techniques that are described in EMC, section 3.2.3

# HINT:  Some of the rows of data contain missing values for 1 or more
# of the columns.  Can you discover how that is represented in the data?
# Make sure you CAREFULLY read of my comments for 'tail' here!

# Some functions to try in this section are:
# dim,     to see the dimensions (# of rows, # of columns) of your data frame.
# names,   to see the names of the variables (i.e. the column names)
#          Notice how R automatically creates names when the input data file
#          does not contain a header row.
#          In assignment 4 you will learn how to manually replace these
#          automatically supplied variable names with more meaningful ones.
# summary, look to see what information is provided
#          Also, if you look carefully at V12 and V13 in the summary you will
#          notice that they look very different from the other variables.
#          Read my comment below for 'tail' to help discover why.
# str,     look to see how this is different from summary
# head,    to see the first 6 rows of the data by default
# tail,    to see the last 6 rows of the data by default
#          Look CAREFULLY at variable V12 of tail and you will
#          see how this dataset represents missing data, which is IMPORTANT
#          for the next task.  You might have to look at more than the default
#          6 rows to see anything unusual.
# plot,    supply an informative title and labels and pleasing colors
#          Make sure you use the following argument parameters for plot:
#           main: string value for title of entire plot
#           xlab: string value for the label on x-axis
#           ylab: string value for the label on y-axis
#           pch:  numeric value for the symbol used to represent the point,
#                 See the the documentation for 'points' in the Help tab on
#                 the lower right window of RStudio
#           col:  The color of the symbol, e.g. "red" etc.
# Other plotting functions described in EMC section 3.2.3 are:
# barplot, dotchart, hist, stem, etc.


### -- put your exploratory code here on multiple lines ---
head(heart.data)
tail(heart.data)
### Task 5. 8 points. Since there is missing data in some of these rows, 
### you need to delete those rows before you start to do any analysis.
### BEFORE you do that, read the data in a SECOND TIME and use 
### parameter na.strings="?" to inform R that the question mark represents
### missing data in this file.

### This part is worth 1 of the 8 points
heart.data <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data", na.strings="?",
                         sep = ",")

# Let's look at how the missing data is now represented in the data frame:
# This will now look different w.r.t. V12 and V13 than it did the first time

summary(heart.data)

### Now you are ready to delete those rows with missing data.
### There are a couple of ways to do this quite easily. 
### The function complete.cases( ) is one way.  
### Another (easier) way is to use na.omit( ).  Use one or the other here.
### I suggest using Google to look for examples on the web of these functions.
### Save this 'cleaned' data into a variable called heart.data.clean

### This part is worth 7 of the 8 points
heart.data.clean = na.omit(heart.data) 

# Verify that the rows with missing data are gone:
dim(heart.data.clean)      # This should show only 297 rows, not 303 any more
summary(heart.data.clean)  # You should no longer see NA data in V12, V13

# Before we can continue, there is one more thing we need to do with this data

# Look at the information again for variable V14, which is what we are trying
# to predict:
str(heart.data.clean)

# Notice that V14 is of type 'int', i.e. V14 contains integers.  We want to do
# a classification algorithm, but since the response variable is currently
# numeric, our models will try to do regression, not classification.  The easy
# fix is to convert V14 to be a 'factor' data type.  For our purposes
# 'factor' means 'category', which is what we want for classifiation.  Here is
# how you can do the conversion:

heart.data.clean$V14 <- as.factor(heart.data.clean$V14)

# That line selected V14 with the '$' syntax as a suffix to the data frame,
# converts it to a factor, and then saves the result back into V14.

# Let's verify that we now have a factor:

str(heart.data.clean)
# You should now see that V14 is identified as a factor.  BUT.....
# we are not quite done.  From the data description on the web we are told:
# "The "goal" field refers to the presence of heart disease in the patient. 
# It is integer valued from 0 (no presence) to 4".
#
# In other words, instead of all 5 factors we only care about "0" vs.
# the other four values.  So let us change those other values 1-4 to all be 1.
# Then our classifier will just try to predict 0 or 1, which is what we want.
# The following several lines of code make that change.  Study it.

# It's easier if we convert the factor back to integers, then change it, then
# convert back to a factor:

heart.data.clean$V14 <- as.integer(heart.data.clean$V14) -1 
str(heart.data.clean) # double check that they are again integers

# The reason for subtracting 1 relates to how factors are represented.
# If we did not subtract 1, then the conversion back to integer would have
# changed all of the integers to be 1 digit larger than previously.

booleanVector <- heart.data.clean$V14 > 0
# This line compares every value of V14 to 0.  If it is greater than 0, it 
# returns TRUE and if equal to 0, it returns FALSE. 

# Let's look at this boolean vector:
booleanVector

# If you did your Week 0
# prework (I TRUST that you did!!!!!) you will remember than FALSE is 
# equivalent to 0 (as it is in most programming languages) and TRUE is
# equivalent to 1.  Thus, all FALSE values represent the absence of heart
# disease and TRUE represents its presence, which is exactly what we want.
# We can now use this boolean vector to replace the existing integers with 
# 0 or 1:
heart.data.clean$V14 <- as.integer(booleanVector) # Convert boolean to integer
heart.data.clean$V14 <- as.factor(heart.data.clean$V14) # integer to factor
str(heart.data.clean) # You should now see: $ V14: Factor w/ 2 levels "0","1"

# We will use 70% of the data for training and 30% for testing.  
# Also, we want to select the training data RANDOMLY.
# If you google this topic, you will discover many ways to do it, but here
# is one way to do it.

set.seed(42) # This makes your code return the same 'random' numbers as mine.

# The next line uses 'sample' to get a random sample,
# but including set.seed is a way to get the SAME random set each time.
# Why would you want to do this?  It is for reproducibility.  If you are
# publishing a paper on your analysis, including set.seed will allow another
# person to get exactly the same set of data you used if they want to 
# check your work and validate if you did the analysis correctly or not.

train.indices <- sample(nrow(heart.data.clean), 
                        round(nrow(heart.data.clean)*0.70))

# Study this line of code.  We are using the function sample() to help us
# get a random sample of data.  Type into the console: sample(10, 7)
# You will see something like this: [1] 1 4 7 9 5 6 2, a random set of
# 7 numbers taken from the numbers 1 through 10.
# Ignore that [1] at the beginning. That just means that the next thing you see
# is the 1st element of the vector returned by sample( ).  

# Let's reference the new variable train.indices and see what its value 
# is in the console window below:
train.indices  # You will see 208 random integers between 1 and 297

# In sample( ) above, we use nrow() to count the number of rows in your 
# cleaned.data.  That will be the first argument to sample(),
# then for the second argument we multiply that same number by 0.7 and then
# round() that to make sure the result is an integer.  That integer
# is then used as the second argument to the sample() function, which will 
# return a vector of 70% of the integers taken randomly from 1 
# to the number of rows.
# Those integers will be the indices of the rows of your heart.data.clean,
# and you want to get each of those rows and save only those rows
# for your 70% training data.  So if these training indices include the numbers
# 74, 21 and 8, then you want to get THOSE rows of data from heart.data.clean
# and save them (and all of the other 70% of the rows) into train.data.

# Then you want to save the OTHER rows (i.e. the ones that are NOT the
# training indices) into the test.data variable.
# The next two lines of code show you how to do this quite simply: 

train.data    <- heart.data.clean[train.indices, ] 
test.data     <- heart.data.clean[-train.indices,] 

# The [ ] operator is used to index the rows/columns of any data frame.
# Inside [ ] you will see a comma. The expression in front of that comma
# is a reference to the rows, and after it is an expression to reference
# the columns.  If either of those expressions is missing, then it just means
# to use ALL of the rows (if that is missing) or all of the columns (if missing).

# The most interesting line here is the reference to the rows for the test
# data.  The expression "-train.indices" refer to the rows that are NOT
# in the vector of train.indices, hence you get the other 30%.

### Task 6. 10 points. Revise the sample( ) line above as a new function
###                    called 'get.random.indices'.
### BEFORE you attempt this, read ALL of my following comments. Down below
### you will find another set of '###' where you will put your actual code.

# This function should be defined to take TWO arguments:
# The first argument will be some data frame, and the second argument
# will be the proportion of that data frame's rows that you want to reference.

# So instead of:
# train.indices <- sample(nrow(heart.data.clean), 
#                         round(nrow(heart.data.clean)*0.70))
# you will do this:
# train.indices <- get.random.indices(heart.data.clean, 0.70)

# Look back at assignment 1 to remind yourself how to define a function of
# two arguments.  dot.product is a function of two arguments.

# get.random.indices should be able to take ANY data frame as its 
# first argument, not just the particular data frame we are using in this
# assignment.  And its second argument should be ANY proportion between 
# 0 (the smallest possible value) and 1 (the largest possible value).
# Thus, if you have a totally different data frame called population.df
# and you want to get a random sample of 85% of that data frame's rows
# you would call it like this:
# train.indices <- get.random.indices(population.df, 0.85)

# In your function definition, you can use any names you want (e.g. x and y)
# for the local variables that refer to the two function arguments, but it's
# always best to use argument names that are meaningful in the sense
# that the names will remind you of the values they will have.

get.random.indices <- function(x, y) {
  sample(nrow(x), 
         round(nrow(x)*y))
}
# Now we will use that function definition to get our training and test data:

train.indices <- get.random.indices(heart.data.clean, 0.70)
train.data    <- heart.data.clean[train.indices, ] 
test.data     <- heart.data.clean[-train.indices,]

# You should now see in the upper right window of RStudio that
# train.indices still has 208 random integers, train.data has 208 observations
# and test.data has 89 observations.

# Now we can proceed to build our predictive model.

### Task 7. 10 points.  First build a bagging model.  You can do this by using 
### the function randomForest with the following parameters:
### x, y, and mtry.  
### Look at the documentation for the function randomForest.

# Parameter 'x' should use the data frame of your training data. 
# You already created that above.  Just make sure that x is set
# to only the predictor variables (columns) of training data.

# Parameter 'y' is the response variable, the thing you want to predict.
# You need to find which of the columns in the data is that response variable
# and then extract only that column from your training data and set that
# to be the value of parameter y.  

# Parameter 'mtry' is the number of variables you want to choose from when
# the algorithm is deciding to create a new node to split the tree.
# In the class lecture, you'll find that I told you that if this number is
# the same as the total number of predictor variables, then the random forest
# will be equivalent to a bagging model.  Therefore you want to set 'mtry' to be
# the number of predictor variables in this dataset.

# You should also use this parameter and value: importance = TRUE

bag.model <- randomForest(x = train.data,y = train.data$V14,mtry = ncol(x),importance = TRUE)

bag.model       # This will print a summary of the model to the Console window,
# including a confusion matrix for the training data.

plot(bag.model) # This will print a plot, where the overall 'out of bag' errors are in black.
# The red curve is the error rate for category 0
# and the green curve is the error rate for category 1
# You can figure these color associations out by looking at the confusion matrix 
# that is printed if you simply type 'bag.model' at the Console.
# This is explained at 
# https://stats.stackexchange.com/questions/51629/multiple-curves-when-plotting-a-random-forest 

bag.preds = predict(bag.model, newdata=test.data) # get the predictions for the test data

### Task 8. 8 points. Create a confusion matrix for your test data.
# We will study this more in Week 4, but a confusion matrix lets you find 
# true/false positives and true/false negatives in a convenient table.  The columns
# represent the truth, while the rows represent your model's predictions.  
# The main diagonal (top left to lower right) are the number of correct predictions and the 
# the off-diagonal (top right to lower left) are the number of errors made by your model.
# Use the R function table() to create this confusion matrix, and either use 
# the R documentation for this function OR use google to find out what arguments
# to use in order to create your confusion matrix.  But since you want to compare
# the predictions vs. the ground truth, clearly you'll need to use 
# bag.preds from above and also the ground truth (actual response values) from
# the test.data variable that you created earlier.

### In the line below, supply 2 arguments to the function table( ).
### The R documentation does not make this clear, but you should use keyword
### arguments, e.g. 'Predicted' and 'Actual'.  If you simply supply the values
### then it will not be clear if the rows or the columns are Predicted or Actual,
### but by explicitly using these keyword names, you will see it clearly in
### the output.

bag.confusion.matrix <- table(Predicted = bag.preds, Actual = test.data$V14)


bag.confusion.matrix # Let's look at that confusion matrix

# Here is code to compute the mean error rate of the model by first computing
# the accuracy and simply subtracting that from 1.
# Recall from our text that accuracy is the number of correct predictions
# divided by the total number of observations in the dataset (test.data).
bag.accuracy <- (bag.confusion.matrix[1,1] + bag.confusion.matrix[2,2]) / nrow(test.data)
1 - bag.accuracy # This will print the mean error rate of the bagging model.

# And here is a much simpler way to get the mean error rate:
mean(bag.preds!=test.data[, 14]) 

# This line will print info about the importance of each variable with respect
# to each outcome being predicted (0 or 1)
importance(bag.model)
?importance # Read the documentation for this function.
varImpPlot(bag.model) # This shows the importance plot, which I showed you in class

### Task 9. 10 points. Now let's duplicate some of the above code for a random forest model.
### To get a random forest model, you can use the same code as above for 
### bagging except that you need to change the value assigned to the parameter
### 'mtry'.  Refer to your text, my lecture notes, or use Google to find a good value to use, or
### perhaps read the documentation for the function randomForest for an idea.
### Hint: It depends on the number of predictors in your dataset.

rf.model <- randomForest(x = train.data,y = train.data$V14,mtry = 4,importance = TRUE)

rf.model
plot(rf.model) 
# Black: overall OOB error rate
# Red:   0 predictions
# Green: 1 predictions
# For both bagging and random forest, what do you notice about the error
# rates as the number of trees is increased?

rf.preds = predict(rf.model, newdata=test.data) # get predictions

### Task 10. 8 points. Compute the confusion matrix for the test data.
rf.confusion.matrix <- table(Predicted = bag.preds, Actual = test.data$V14)

rf.confusion.matrix

mean(rf.preds!=test.data[, 14]) # mean error rate of random forest
# How did the mean error rate of the bag.preds compare with rf.preds?
# If you want to get a better error rate, what could you do to change
# your code?

### To get 3 MORE extra credit points, find a new random forest model
### that produces a lower error rate. 

second.rf.model <- randomForest(x = train.data,y = train.data$V5,mtry = 4,importance = TRUE)

second.rf.model
plot(second.rf.model) 

second.rf.preds = predict(rf.model, newdata=test.data) # get predictions

second.rf.confusion.matrix <- table(Predicted = bag.preds, Actual = test.data$V14)

second.rf.confusion.matrix

mean(second.rf.preds!=test.data[, 14]) # mean error rate of random forest
