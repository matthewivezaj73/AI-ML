#Importing the data.
Covid_data <- read.csv("/Users/matthewivezaj/Desktop/Data\ Science\ Projects/Active\ Projects/Underlying\ Condition\ Covid19/Data/Conditions_Contributing_to_COVID-19_Deaths__by_State_and_Age__Provisional_2020-2023.csv") 
Covid_data <- na.omit(Covid_data)
#Checking the dimensions of the dataframe.
dim(Covid_data)  
#Looking at the first 10 rows of the data
head(Covid_data, n=10) 
#Checking the value of each element.
is.na(Covid_data)
#Installing stringr and loading the library.
install.packages("stringr")
library("stringr")
# Look at the last 10 rows.
tail(Covid_data, n=10) 
#Viewing a summary of the data after removing the na values.
summary(Covid_data)
#Viewing the data types.
str(Covid_data)
#Assigning each data type to a 
Condition = Covid_data[9]

#Installing randomForest.
library("randomForest") 
rfnews()
#Creating a function that I will need for randomForest.
get.random.indices <- function(x, y) {
  sample(nrow(x), 
         round(nrow(x)*y))
}
#Creating a function to train the data.
train.indices <- sample(nrow(Covid_data), 
                        round(nrow(Covid_data)*0.70))
#To examine how many columns there are.
ncol(Covid_data)
#Acquiring the training and test data.
train.indices <- get.random.indices(Covid_data[1:14], 0.70)
train.data    <- Covid_data[train.indices, ] 
test.data     <- Covid_data[-train.indices,]
#Examining the train data.
str(train.data)
Condition = as.factor(train.data$Condition)
#Creating a randomForest
Forest <- randomForest(x=train.data[1:14],y=Condition,mtry = ncol(train.data[1:14]),Proximity = TRUE, importance = TRUE)
summary(Forest)
str(Forest)
#Plotting the random forest.
plot(Forest)
#Making a prediction over the randomForest.
forest.preds = predict(Forest, newdata=test.data)
#Creating a confusion matrix.
bag.confusion.matrix <- table(Predicted = forest.preds, Actual = test.data$Condition)
bag.confusion.matrix
#Computing the mean error rate.
forest.accuracy <- (bag.confusion.matrix[1,1] + bag.confusion.matrix[2,2]) / nrow(test.data)
#Printing the mean error.
plot_err_rate <- 1 - forest.accuracy
plot_err_rate
mean(forest.preds!=test.data[, 14]) 
#Displaying the importance for each variable.
importance(Forest)
plot(Condition)

