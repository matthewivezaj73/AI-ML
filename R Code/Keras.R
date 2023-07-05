# Assignment3.Week5.keras.R
# 80 points, + max 4 points extra credit.
# Predict chess game results with a neural net built using Keras and TensorFlow.

# Before calling these library functions, you MUST have Anaconda Python,
# Keras and TensorFlow installed.  
# Also install ggplot2 if you want to see nice output for the plot(history)

library(keras)      # Functions to build and train a neural net
library(tensorflow) # The engine that does all the work
library(ggplot2)
# In what follows, any line that is commented out with THREE hash symbols ###
# indidates a line or section of code that you need to modify.

# Task 1: 2 points.  Point to the directory on your computer with the data
# that you downloaded from the Walsh server.

setwd('/Users/monty/Desktop/')

# This next line of code will take several seconds. 
# A red stop sign will appear in the top right of the console window 
# while it runs.  Just wait for it to finish.
load("matmob.data.sample.Rdata") 
# After that load is done, you will have a variable 'matmob.data.sample' 
# that is bound to a data frame with information about 100,000 games and 16 vars
# played between people with ratings from expert up to grandmaster.
dim(matmob.data.sample) # Should show 100000 rows, 16 variables

### Task 2, 2 points.  Use the head() function to show ONE of the sample
#  observations in the console.  The default number for the head() function
#  is 6 observations.  Look at the documentation for head() to find out
#  how to change that to just 1.

head(matmob.data.sample, n=1)

# You should also see a row number on the left hand side before the first 
# variable, 'w.mat.mean'.  That number, which should be '450478', refers to 
# the actual row number of a much larger dataset this sample was selected from.
# You can safely ignore these row numbers for the remainder of the assignment.

# Here is how you can actually suppress that unneeded information:

rownames(matmob.data.sample) <- NULL
head(matmob.data.sample, 1) # You will no longer see row numbers

# Task 3, 4 points Look at distribution of black wins, white wins and draws
# by constructing a table (use the function table( )) of the sample data's
# game outcome variable, which is called 'result'. In the rest of this assignment,
# refer to the data description document in Moodle to find out the names of the
# variables you need to refer to.

result.table <- table(matmob.data.sample$result) # just refer to the variable called 'result'
                                            # But make sure you refer to it the
                                            # the correct way in R, which you
                                            # should already know by now.
print(result.table) # Show this table in the console window.
str(matmob.data.sample$result)
# In chess, a win by black is written as "0-1".  A white win is written as
# "1-0" and a draw is written as "1/2-1/2".  That is what you should see
# as part of this 'print' statement.

# Why is R showing you that information?  Look at the structure information
# for the variable result:

str(matmob.data.sample)
# See how it's a factor variable? 
# In R, a factor variable is represented internally with numbers (hence, you
# can see the integers 1,2, and 3) but each one of those values has a string name,
# which are: "0-1","1-0","1/2-1/2"  These are called the 'levels' of a factor.
# So when you do print(result.table) you are seeing those string names and
# the counts for each of them.

# Task 4, 10 points. Use plot( ) to create a graphic of result.table
# Read the documentation for ?plot and ?par for ideas on how to make this
# look pleasing, but you must at least use the parameters 'main', 'xlab',
# 'ylab' in addition to the argument that references 
# the result.table variable from Task 3 above.
# Also use: type="b"
# which will make your graph create points connected by a line.

myplot = plot(result.table, xlab='X Values', ylab='Y values',main='matmob data sample',type="b")

# OPTIONAL Task 5, 4 points max extra credit.
# Use the function text( ) to add y-axis value labels by each of the 
# three plotted points. That is, the label for the point showing black wins
# should be the number of games won by black, and similarly for white wins
# and draws. Google is your friend to find out how to do this.

text(x=myplot,y=27000,seq_along(myplot), labels=result.table,pos=4) 
head(matmob.data.sample)
# ==================   Prepare Training and Test Data  ============

# Task 6, 6 points. We only need the variables for the game mean of material 
# and mobility, the length (in half moves) of the games, and the game result 
# (which will, as indicated above, be '0-1' or '1-0' or '1/2-1/2') for black 
# win, white win, or draw. Consult the chess data description document to 
# identify which vars you need to keep and omit the rest.  Use Google if you 
# need to find out how to get a "subset of a data frame in R" that keeps all 
# rows but only some of the variables.  
# Hint: Use the '[ ]' notation.  Do NOT use the subset() function.

# BUT BE CAREFUL HERE!  Make sure that the 'result' variable is the
# right-most variable or you will have a problem in another task below.
# Hint: To make this happen, use the names of the columns (not column numbers)
# for this task.
matmob.data.sample <-matmob.data.sample[,c('b.mat.mean','w.mat.mean','b.mob.mean','w.mob.mean','half.moves','result')]
head(matmob.data.sample) # Check that it looks correct.
# If 'result' is not the right-most column, then you need to find a way
# to make it the right-most.

dim(matmob.data.sample)  # There should be 6 columns (variables).

# Before we split the data into training and test sets, we have to 
# do some data preparation, also called 'data munging' or 'data wrangling', etc.
str(matmob.data.sample)
# Notice again that the 'result' var is a factor. Neural nets require numeric
# data, so we have to associate numbers with each of the 3 possible results.
# Let's look at the result of the first 10 games:
matmob.data.sample$result[1:10]

# When we print a factor variable to the console we see the string form
# of the variable, e.g. '0-1' or '1-0' or '1/2-1/2', but those are just 
# the surface names.  The REAL underlying values are the numbers that you see
# when you look at str(matmob.data.sample). If you look at the previous two
# commands in your Console window, you should be able to see that the first
# 2 games resulted in a white win: 1-0, the second 2 games were a black win
# 0-1 and the 5th game was a draw: 1/2-1/2.  Looking at the output of str()
# you should notice for the result variable that 2 is used to represent 
# the string "1-0", 1 represents "0-1" and 3 represents "1/2-1/2".

# How did those mappings occur and not a different one?
# By default, factors are mapped to the positive integers in alphabetical order
# by their string names, hence string "0-1" maps to 1, etc.

# As I said above, neural nets need to use numbers rather than strings,
# so it looks like all we have to do is make sure that R uses those numbers
# rather than the strings by converting 'result' to a numeric var.
# In assignment 2 you saw how to change a numeric variable to a factor.

### Task 7: 4 points. For this assignment, you need to change a factor variable
###         to a numeric one. So go back to assignment 2 and look to 
###         see how we converted a numeric value to a factor, and that will
###         give you a huge clue how to convert the 'result' variable
###         from a factor to numeric.

matmob.data.sample$result = as.numeric(matmob.data.sample$result)

# Now when we do the following, you will see ONLY those numbers:
str(matmob.data.sample)
# Before the conversion, the first 6 results that we saw with head() were:
# result
# 1-0
# 1-0
# 0-1
# 0-1
# 1/2-1/2
# 1-0

# They have now become: 2 2 1 1 3 2, which you can see here:
head(matmob.data.sample)

# 1 corresponds to 0-1, 2 to 1-0 and 3 to 1/2-1/2.
# So it appears that we are all set because now we can just use these numbers
# 1, 2, and 3.  However, if we continue we will eventually encounter an error
# that is due to a difference between R and Python.  

# Python is involved because Keras is implemented in Python, which is why
# you had to install that language before using the 'keras' package in R.

# To avoid the error, we need to use 0, 1, 2 instead of 1, 2, 3, i.e.
# map: 0-1 to 0, 1-0 to 1 and 1/2-1/2 to 2, which we can do quite easily:
matmob.data.sample$result <- matmob.data.sample$result - 1
head(matmob.data.sample)

# The explanation of the difference between R and Python is the following: 
# Keras is implemented in Python, and Python indexes vectors and arrays
# beginning from 0, while R uses 1-based indexing.  Thus, we need to change
# the mapping from 1, 2, 3 to 0, 1, 2. 

### Task 8, 8 points. Use 85% of the data for training and 15% for testing.
### You should already know how to do this by now.  If not, look at your previous
### assignments. 

set.seed(42)
# Use the FUNCTION you created in Assignment 2 for the next line of code!!
# You will have to copy that function definition and paste it into this
# code file, and then use it in the next line.

get.random.indices <- function(x, y) {
  sample(nrow(x), 
         round(nrow(x)*y))
}
train.indices <- get.random.indices(matmob.data.sample, 0.85)
train.data    <- matmob.data.sample[train.indices, ]
test.data     <- matmob.data.sample[-train.indices, ]

# If you did that correctly, you should now see all 6 of your variables 
# in each of train.data and test.data.  Let's check:
head(train.data)
head(test.data)

# We DO have all 6, but Keras needs to have only the predictor variables
# referenced in your compiled neural net.  So let's save the result variable
# separately (so we can use it during training and evaluation) and then
# we will delete the result variable from our training and test data frames.

train.data.result <- train.data$result
test.data.result  <- test.data$result

# Now we will drop the result column, convert to a matrix for Keras,
# and scale (normalize) the predictor variables so they have similar ranges.
train.data <- scale(as.matrix(train.data[, -6]))
test.data  <- scale(as.matrix(test.data[,  -6]))
# Verify the result var is gone and data is scaled:
head(train.data)
summary(train.data) # After scaling, each variable has a mean of 0

# So now, these two matrices only contain the predictor variables.
# The data we want to predict are, of course, those game results that
# we just saved in train.data.result and test.data.result

# ============= Fit neural net model and predict test data outcomes ==============

# Build and train a neural net that predicts a game outcome
# from the other variable values. You can consult the MNIST tutorial that you
# probably already completed: 
# 1. Click on the 'Packages' tab in the lower right-hand window of RStudio.
# 2. Scroll down until you see the 'keras' package and click on its name.
# 3. Near the top, click on 'User guides, package vignettes and other documentation.'
# 5. Ideally, you wilL DO the MNIST tutorial before you attempt this assignment, 
#    and then the remainder of this assignment should be super easy.  
#    But basically, you can skip down to the section called
#    'Defining the Model' to see how to do the rest of this assignment.

#  You should NOT try to copy the model created for MNIST.  
#  It won't work because of the way we have structured our data.
#  You only need 2 layers, including the output.
#  Also, in this model I want you to use the following hyperparameter values
#  in your first dense layer:
# a. units = 50
# b. activation = 'sigmoid'
# c. You MUST use: input_shape = c(5) because there are 5 predictor vars
#
# Your output layer will also be dense and you MUST use these 2 hyperparameters:
# a. units = 3 (because we are predicting one of three game outcomes)
# b. activation = 'softmax' # Do you remember the softmax function? 
# We have discussed it already in class.

### Task 9, 2 points. Create your initial, empty model with no layers.
# IMPORTANT NOTE: If you get an error like this, when you execute your code
# for task 9:
#            "Error: Python shared library not found, Python bindings not loaded.
#             Use reticulate::install_miniconda() if you'd like to install a  
#             Miniconda Python environment."
# then double check that you have the R package called 'reticulate' installed.
# You can just install it again, which will not hurt anything if it is
# already installed.  Then, as it tells you in the error message, type (or copy
# and paste) the following from the error message into the console window
# of RStudio in the lower right, and press the Enter key:
# reticulate::install_miniconda()
# This will take a few minutes to finish.  After it does, then try to run
# your Task 9 code again.  It should run, but it might also install more
# software, which again will take a couple of minutes. Just be patient and wait
# for it to finish.  If it does, you should be able to continue just fine.
# If not, then please contact me immediately for help.

nn.model <- keras_model_sequential()

### Task 10, 21 points (7 + 7 + 7, see below).  

?"%>%" # look at magrittr documentation to understand the pipe operator
?layer_dense   # Read this to understand layer_dense

# This part is the first 7 points for Task 9.
nn.model %>% layer_dense(units=50,activation='sigmoid',input_shape = c(5)) %>%
layer_dense(units=3,activation='softmax')

summary(nn.model) # You should see onlt 453 parameters to learn. Very tiny!

# Next 7 points for Task 9:

# The MNIST tutorial uses the categorical_crossentropy loss function because
# that tutorial uses 1-hot vectors (you will learn about them in Week 9)
# for the results variable. 
# But we are simply using the values 0, 1, 2 here to represent game outcomes,
# which requires that we use sparse_categorical_crossentropy.
# We will also use the stochastic gradient descent optimizer 
# (called 'optimizer_sgd'), and accuracy for the metrics.

nn.model %>% compile(
loss = 'sparse_categorical_crossentropy',
optimizer = optimizer_rmsprop(),
metrics = c('accuracy')
)


# And for the last 7 points, train your model, saving the results into 'history':
# For this part, make sure you call the fit() function, and give it both
# train.data as well as train.data.result.  Also, try running it for 100 epochs,
# with a batch size of 128.  Do not use validation_split.

# As your neural net is being trained, you should see some output every few
# seconds in the console window, which will show you the progress of the
# training.  You should notice the value of loss trending downward while
# accuracy trends sightly upward as the epochs increase.

history <- nn.model %>% fit(train.data,train.data.result, epochs=100,batch_size=128)

plot(history) # Let's look at the history

# Now, let's evaluate the performance of this model on the test data
nn.model %>% evaluate(test.data, test.data.result)

# Task 11, 21 points.  Build a SECOND neural net that uses DIFFERENT 
# values of the following hyperparameters to try and see if you can
# get even better results.  Once you get Task 9 working, just copy ALL of 
# that code down to here, but then change the values of the following 
# before you actually train and evaluate its results.  There is no guarantee
# that you will improve upon your Task 9 results, and your grade does not
# depend upon doing better, but you should be able to do better. In either case,
# I just want to see you build, execute, and evaluate a DIFFERENT model from
# the one in Task 9.
# The hyperparameters you can experiment with are:
#  1. units in your first dense layer (do NOT change units in your output layer)
#     Hint: in general, you'll get better results with more units.
#  2. activation function in the first layer (do NOT change softmax in output layer)
#  3. optimizer. Click on 'keras' in your package list to open up the documentation,
#       scroll down to the alphabetical section for -- O -- and look at all
#       the available optimizers.  Try something other than optimizer_sgd
#  4. epochs.  Hint: More epochs will generally give you better results.
#  5. batch_size.  Smaller batch size might give better results, but it will
#       take longer to run.
# You could also try adding a 2nd hidden dense layer between the first 
# hidden layer and the output layer.

# Make sure your FIRST line of code is this one: 
# nn.model <- keras_model_sequential() 

nn.model <- keras_model_sequential()

### Task 10, 21 points (7 + 7 + 7, see below).  

?"%>%" # look at magrittr documentation to understand the pipe operator
?layer_dense   # Read this to understand layer_dense

# This part is the first 7 points for Task 9.
nn.model %>% layer_dense(units=50,activation='sigmoid',input_shape = c(5)) %>%
  layer_dense(units=3,activation='softmax')

summary(nn.model) # You should see onlt 453 parameters to learn. Very tiny!

# Next 7 points for Task 9:

# The MNIST tutorial uses the categorical_crossentropy loss function because
# that tutorial uses 1-hot vectors (you will learn about them in Week 9)
# for the results variable. 
# But we are simply using the values 0, 1, 2 here to represent game outcomes,
# which requires that we use sparse_categorical_crossentropy.
# We will also use the stochastic gradient descent optimizer 
# (called 'optimizer_sgd'), and accuracy for the metrics.

nn.model %>% compile(
  loss = 'sparse_categorical_crossentropy',
  optimizer = optimizer_adam(),
  metrics = c('accuracy')
)


# And for the last 7 points, train your model, saving the results into 'history':
# For this part, make sure you call the fit() function, and give it both
# train.data as well as train.data.result.  Also, try running it for 100 epochs,
# with a batch size of 128.  Do not use validation_split.

# As your neural net is being trained, you should see some output every few
# seconds in the console window, which will show you the progress of the
# training.  You should notice the value of loss trending downward while
# accuracy trends sightly upward as the epochs increase.

history <- nn.model %>% fit(train.data,train.data.result, epochs=100,batch_size=90)

plot(history) # Let's look at the history

# Now, let's evaluate the performance of this model on the test data
nn.model %>% evaluate(test.data, test.data.result)
