# MAKE SURE YOU READ EVERY SINGLE COMMENT IN THIS FILE. IF YOU DO NOT,
# YOU COULD EASILY STRUGGLE WITH THE ASSIGNMENT.

# In what follows, any line that is commented out with 3 hash symbols ###
# indicates a line or section of code that you need to modify. Make sure you 
# then REMOVE those 3 '###' symbols in order to then run that code!

# IMPORTANT:  Make sure THIS code file is in the same directory
#             as where your input data is!  If you do not, then you will get
#             an error message when you try to read in your data.

# When you read your data in, it matters whether your data has a header
# row or not.  The default assumption for read.csv is that your data DOES 
# contain a header row, but read.table's assumption is that
# there is NO HEADER. With either function, you may need to override the default.
# Type '?read.csv' to see the list of parameters and their defaults.
# In the code that follows, I used 'assg1Data' as the variable name to hold
# your data.

### Task 1, Read in your dataset: 5 points
# Use the function read.csv() if your data is in a .csv file.
# Otherwise, use read.table().  Since our data is in a .csv file we will use:

assg1Data <- read.csv("C:/Users/matth/OneDrive/Desktop/cancer_data_cleaned.csv") 

# REMEMBER to remove the 3 '###' of your line of code before you run it!

# There is a way to read your data in if it's in a different location than
# where your code file is.  If you set your 'working directory' to the location
# of your data, then it can be anywhere.  Use the function setwd() to set
# the working directory.  For example, here is how I have it on my Mac:
# setwd("~/Documents/Work/Walsh/Week 1/Code") #This is where my data is.

# For a Windows machine, your path will look more like this:
# setwd("C:/Users/Godden/Documents/Walsh") 

# If you want to see where your current working directory is, type the following
# into the console window in the lower left:
# getwd() and then press Enter

dim(assg1Data)  # What are the dimensions of this dataframe?
head(assg1Data) # Look at the first 6 rows of your data.

### Task 2, look at last 4 rows of your data: 2 points
# The tail() function is just like head(), but it looks at the last rows
# of your data frame.  Like head(), the tail() function's default is to 
# display 6 rows of data.  You can change that to any number you wish by
# adding a second argument.  Type '?tail' in the console window below to see
# the documentation (and examples at the bottom) for tail( ).

tail(assg1Data, n=4) # Look at the last 4 rows.

### Task 3: Make a plot(): 7 points

# In this dataset, the name of the response variable that we want to predict is
# 'TARGET_deathRate' per 100,000 people and the others are potential predictors.
# The variable 'incidenceRate' is the mean diagnoses per 100,000,
# so we would expect that to be highly correlated with the actual disease.
# Therefore, let's plot those two variables to see if they look linearly related.
# Choose parameters to create a custom label for the x and y axes, and a main
# title to the plot. Type ?plot into the console window to see how to use
# the plot() function.  If you have difficulty understanding the documentation,
# I suggest just using Google to find examples of it.

plot(assg1Data$incidenceRate,assg1Data$TARGET_deathRate,xlab = "incident rates values", ylab = "target death rates", main  = "Cancer Deaths")
#Checking the value of the mean of assg1Data$incidenceRate.
#mean(assg1Data$incidenceRate)
#mean(assg1Data$TARGET_deathRate)
# Now let's create a linear model using these two variables.

model.fit <- lm(assg1Data$TARGET_deathRate ~ assg1Data$incidenceRate, data = assg1Data)

# The so-called 'formula' syntax: responseVariable ~ predictorVariable
# is what we have used here to indicate that TARGET_deathRate is the response
# variable and incidenceRate is the predictor.

# The parameter 'data' is not actually necessary. However,
# if we did not include 'data = assg1Data' this would have produced an error
# because without it, R would think that TARGET_deathRate and incidenceRate
# are just variables. Then it would not find any values for them and
# throw an error.  
model.fit
#So if you omit 'data = ' you would have to reference the variables this way: 
model.fit <- lm(assg1Data$TARGET_deathRate ~ assg1Data$incidenceRate)
# The nameOfDataFrame$ syntax tells R where to find those variables. 

### Task 4: Add the linear regression line to the plot we already made: 5 points

# Add the linear regression line in RED color to your plot. See the documentation
# for abline() and LOOK AT THE EXAMPLES at the bottom of the page, especially
# the example right after: z <- lm(dist ~ speed, data = cars)
# Don't forget to make the color red for this regression line.
# Your variables will, of course, be different from the ones in the example.

abline(model.fit,col = "red")

# The plot shows that the fit is roughly linear, but this is not unexpected, 
# and it's also not particularly enlightening.  Thus, let's fit a model on ALL 
# of the predictors to see what that can tell us:

### Task 5: Create a multivariable linear model using lm(): 7 points

# Your code will be similar to the simple regression above, but there is a
# small change that will allow you to predict the response variable using
# ALL of the other variables WITHOUT actually typing any of their names.
# Use Google to figure out how to do this, as it is not in the documentation
# for lm( ), at least on the version of R I have installed on my computer.

linear_model = lm(TARGET_deathRate ~ ., data=assg1Data)
summary(linear_model)


# Look at the results of your model

### Extra Credit (optional): 4 points
# Using the information in that summary, create ANOTHER model that 
# uses ONLY those predictors which are significant at the 0 or 0.001 levels.
# If you recall, I have a lecture slide that explains all of the output
# of the summary( ) function. That provides the information you need
# to choose the correct variables.  You will also have to type out all of
# the appropriate variables using a different syntax than the two models
# we created above.  Yet again, Google is your friend.






### --Your code goes here --
all_data = lm(TARGET_deathRate ~ ., data=assg1Data)
summary(all_data, digits = 10)
plot(assg1Data$incidenceRate,assg1Data$TARGET_deathRate,main = "My data points",xlab = "X values", ylab = "Y values")
zero_significance = lm(assg1Data$TARGET_deathRate ~ assg1Data$incidenceRate+assg1Data$medIncome + assg1Data$popEst2015 + assg1Data$BirthRate + assg1Data$PctUnemployed16_Over + assg1Data$PctPrivateCoverage + assg1Data$PctOtherRace)                        
summary(zero_significance)



# Before you continue, let's RE-RUN the SIMPLE linear model above in 
# order to get THAT model back into your variable 'model.fit'.
model.fit <- lm(assg1Data$TARGET_deathRate ~ assg1Data$incidenceRate)

# Now you'll compute the coefficients yourself and compare them to what lm() gets.
# If your code is correct, your computed values of the beta 0 and beta 1
# coefficients should both be less than epsilon away from the values computed  
# by the lm( ) function above.

epsilon <- 0.00001

# For the function definitions below, some useful built-in R functions that
# you can use are: sum, *, ^ (for exponentiation)

# The following is how you define a function in R. Then you can use it
# as if it was part of the R language itself.  I'll do the first one for you,
# so look at it carefully.  You have to finish the next four by yourself.

# Compute the dot product of two equal-length vectors x and y
# The 'dot product' is a linear algebra operation that computes
# the sum of the element-wise products of two equal-length numeric vectors.
# A vector is a sequence of numbers. You will see examples of using vectors
# in the code that follows right AFTER this definition.
# Pay attention to this function and REMEMBER it because we will see
# the dot product operation in future weeks.  It's simple, but also
# EXTREMELY IMPORTANT, as you will see during this course.

# You should always include comments like the ones immediately under
# the first line of the function definition to explain what
# the function does, and what its argument variables are.

dot.product <- function(x, y) {
  # Compute the dot product of two equal-length vectors x and y
  # x and y are both either a single number or a vector of numbers
  sum(x*y) 
}

# dot.product computes the dot product of x and y.  See how easy it is?
# Only one line was needed to define the body of this function: sum(x*y)
# The inputs to this function, x and y, are both either single numbers
# or both equal-length vectors of numbers.  
# Notice how you first compute the product (x*y) and then 
# take the sum of that result. In an R function definition like this,
# the LAST thing your function definition computes will be returned as the
# value of the function.

# Let's take that function we just created to see how you can use it:
# If you want to take the sum of the product of two vectors, just pass
# the two vectors to this function.  Here is how you create a vector 
# of numbers in R: c(1, 3, 5)  So if we want to multiply that vector with the
# vector c(2, 4, 6) you can do this:

c(1, 3, 5) * c(2, 4, 6) # Notice how this returns a vector of those multiples

# When you execute that line of code, you should see this is your console window:
# [1]  2 12 30  because 1*2 = 2, 3*4 = 12, and 5*6 = 30
# So if you want to compute the sum of that vector you can do this:

sum(c(1, 3, 5) * c(2, 4, 6))

# Notice how that returns the value 44.  First, it computed the code inside
# the parens of sum( ), which is that vector you saw a few lines back:
#  2 12 30

# Then, that vector was passed to the R function sum( ), which computed the
# sum of  2 12 30, and returned the value 44.

# That is how you do it manually.  But you don't have to do it manually because
# we defined the dot.product function above.  So you can do all of it like this:

dot.product(c(1, 3, 5), c(2, 4, 6)) 

# Often, it's easier to read if you do it like this:
vectorOne = c(1, 3, 5)
vectorTwo = c(2, 4, 6)
dot.product(vectorOne, vectorTwo)

# Look again at the definition of the dot.product function.  Here it is again:

dot.product <- function(x, y) {
  # Compute the dot product of two equal-length vectors x and y
  # x and y are both either a single number or a vector of numbers
  sum(x*y)
} # This } is REQUIRED in order to match the { above. It defines the end of
# your function definition.

# Notice that 'dot.product' is basically a variable whose value is the function
# that is defined by the rest of the code.  That is, function(-args-){-code-}
# defines a function, which is then assigned (using '<-' to the name of the 
# function, which I have chosen to be 'dot.product', but it could be something
# else, e.g. 'dot_product' or 'dotProduct' or 'sumOfMultipliedVectors' etc.
# It's good practice to use short, descriptive names for functions.

# When you execute: dot.product(c(1, 3, 5), c(2, 4, 6))
# R first computes the value of c(1, 3, 5) and returns a vector of numbers
# <1 3 5> This notation with the angle brackets is simply MY notation for 
# a vector. It is not part of R. Sometimes I may separate the numbers by commas.
# Either way, I'm just indicating to you that I'm talking about a vector
# (which means a sequence) of numbers.

# That vector becomes the value of the variable 'x' that represents
# the first argument in the function definition. x only has a value INSIDE
# the function.  If you type x into th console window it will give you an 
# error because x is not defined in the global environment, only the local
# environment of the function dot.product.

# Similarly, the vector <2 4 6> will become the value of the local
# variable y inside the function.  We say that y is 'bound' to <2 4 6>
# just like x is bound to <1 3 5>.

# Next, when R sees the code 'sum(x*y)' it knows that it needs to first
# compute x*y and then pass that result to the R function sum( ).
# Therefore, it computes the product of the vectors <1 3 5> and <2 4 6>.
# When vectors are multiplied, the multiplication happens element-wise.
# That is, the first two elements of each vector are multiplied 1*2, 
# followed by the next two elements 3*4, then 5*6. For longer vectors,
# this element-wise process continues to the end.  Remember: the vectors need
# to have the same length in order for each number to have a 'mate' in the
# other vector.  In our example here, those three
# products are then returned as a vector value: <1, 12, 30>, which is the
# input argument to sum( ), which simply adds each number of the vector
# and returns 44 (1 + 12 + 30)

# That is a DETAILED explanation of what happens when you define and then use
# a function definition.  As soon as the function finishes, then the local
# variables inside that function cease to have any values at all.  They are
# unbound, and waiting to be used again the next time you call the function.

# Now it's your turn to write functions, but I've written part of them for you.

### Tasks 6 through 9: Finish writing the next 4 functions: 10 points each

sum.squares <- function(x) { # this function only takes ONE argument
  # Compute the sum of the squares of a vector x
  sum(x^2)
}

# If you defined that correctly, then you should see a value of 14
# when you run this line of code:
sum.squares(c(1, 2, 3))

#Running my own tests...
sum.squares(c(5,4,8))
#5*5 = 25, 4*4 = 16, 8*8 = 64. 25+16+64=105


# If you don't get 14, then your definition has an error. Revise it.
# You should run your OWN tests too and check the answers, e.g. try
# sum.squares(4), sum.squares(c(-1, -2, -3)) and so on.

square.sum <- function(x) { # again, only one argument
  # Compute the square of the sum of a vector x
  sum(x)^2
  
}
#Testing the function.

square.sum(c(4, 4, 4, 4))

sum.squares(c(4, 4, 4, 4))


# Remember to run some tests to make sure you get the expected answers.
# If not, then you need to revise your code until you see correct answers.
beta1 <- function(x, y, n) { # This function takes THREE arguments
  # Compute the value of beta_1 for a linear regression model where
  # x is the predictor, y is the response, and n is the number of observations
  # See instructions handout for math formula.  The NAME of the function
  # is 'beta1', which is useful to remind you of what it is computing.
  
  # As you think of how to write the code for the numerator and denominator
  # below, remember to USE THE FUNCTIONS DEFINED ABOVE.  In other words,
  # by the time you get here, you have already defined the functions called:
  # dot.product, sum.squares, and square.sum.  Each of THOSE functions can 
  # be used to help you define beta1 here and/or beta0 below.
  # So when you look at the math equations in the instructions handout for 
  # this assignment, think about how to relate the R functions to the
  # math notation, and then USE those R functions in the next two lines:
  #Skipping the assignment of x, since it was defined above.
  numerator = n*dot.product(x,y) - sum(x)*sum(y)
  denominator = n*sum.squares(x) - square.sum(x)
  #solving for beta1.
  numerator/denominator
}

beta0 <- function(x, y, z) {
  # Compute the value of beta_0 for a linear regression model where
  # x is the predictor, y is the response, and z is the value
  # computed by the function beta1 above.
  
  
  mean(y) - z*mean(x)
  ###    --your code goes here-- # See instructions handout for math formula
}

### Task 10: Compute beta_1 and beta_0: 5 points each
# Use the functions you just wrote to compute the beta_1 and beta_0 coefficients,
# saving them into the variables betaOne and betaZero.
# Your function beta1 needs to know the number of observations in your data
# as its third argument.  You can use the built-in R function nrow() 
# to pass that in.
#Creating betaOne.
betaOne <- beta1(assg1Data$incidenceRate, assg1Data$TARGET_deathRate, nrow(assg1Data))
betaZero <- beta0(assg1Data$incidenceRate,assg1Data$TARGET_deathRate,betaOne)
# Notice that 'betaOne' is just the name of some global variable that will be 
# bound to the value returned by the beta1 function.  I could have used ANY
# variable name, e.g. 'foo', but I chose to use betaOne in order to remind you
# of what its value means.  This is good practice in programming: choose variable
# names that are meaningful rather than arbitrary.

# Similarly, the variable called 'betaZero' is meaningful, rather than arbitrary.

# Now let's compare the coefficients computed by lm( ) to the coefficients
# that you just computed.  Remember that, way up above, you already created
# a linear model using lm( ) and saved its results into the varible model.fit.
# That variable contains a lot of information.  You can extract parts of it
# using a certain syntax.  For example 'model.fit$coefficients' will return
# the coefficients. Let's do that, saving those coefficients in the variable
# model.coeffs

model.coeffs <- model.fit$coefficients

# Now let's look at those coefficients by executing the next line of code.
model.coeffs

# Ready? Above you have computed those same coefficients using the functions
# you defined and saved them into the variables betaZero and betaOne.  So let's
# look at the values YOU computed and see how they compare with model.coeffs:

betaZero
betaOne

# How much difference is there between those vals and the model's coefficients?

# Tasks 11 and 12: 2 points each
# You don't have to write any more code, just execute these next two lines.
# If your code is correct both of these last 2 lines should print "TRUE"
abs(model.coeffs[1] - betaZero) < epsilon
abs(model.coeffs[2] - betaOne) < epsilon




