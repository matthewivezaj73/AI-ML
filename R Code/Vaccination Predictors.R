#Importing the data.
Covid_data <- read.csv("/Users/monty/Desktop/Vaccine_Hesitancy_for_COVID-19__County_and_local_estimates\ copy.csv") 
#Cleaning out the na values and displaying the data afterwards.
Covid_data <- na.omit(Covid_data)
#Viewing the values
dim(Covid_data)  # What are the dimensions of this dataframe?
head(Covid_data) # Look at the first 6 rows of your data.
is.na(Covid_data)
#Installing stringr and loading the library.
install.packages("stringr")
library("stringr")
tail(Covid_data, n=4) # Look at the last 4 rows.
#bool_data <- Covid_data$Vaccine_Hesitant > 45
#str_count(bool_data, "TRUE")
#Viewing a summary of the data after removing the na values.
summary(Covid_data)
# Creating a linear model of the data from these variables.

#Creating a boxplot.
boxplot(Covid_data)
#Creating a function that I will need for randomForest.
get.random.indices <- function(x, y) {
  sample(nrow(x), 
         round(nrow(x)*y))
}
#Creating a function to grab samples from the two sets of data.
train.indices <- sample(nrow(Covid_data), 
                        round(nrow(Covid_data)*0.70))
# Now we will use that function definition to get our training and test data:

train.indices <- get.random.indices(Covid_data[1:18], 0.70)
train.data    <- Covid_data[train.indices, ] 
test.data     <- Covid_data[-train.indices,]
plot(Covid_data$Vaccine_Hesitant)
#train.data$Race <- as.factor(train.data$Race)
str(train.data)
#Installing randomForest.
library("randomForest") 
rfnews()
train.data$Vaccine_Hesitant = as.factor(train.data$Vaccine_Hesitant)
#Creating a randomForest out of the first 17 variables in the data and examining the results.
Forest <- randomForest(x=train.data[1:17],y=train.data$Vaccine_Hesitant,mtry = ncol(train.data[1:17]),Proximity = TRUE, importance = TRUE)
summary(Forest)
str(Forest)
#Plotting the random forest.
plot(Forest)
#Making a prediction over the randomForest.
forest.preds = predict(Forest, newdata=test.data)
#Creating a confusion matrix.
bag.confusion.matrix <- table(Predicted = forest.preds, Actual = test.data$Vaccine_Hesitant)
bag.confusion.matrix
#Computing the mean error rate.
forest.accuracy <- (bag.confusion.matrix[1,1] + bag.confusion.matrix[2,2]) / nrow(test.data)
#Printing the mean error.
plot_err_rate <- 1 - forest.accuracy
plot_err_rate
plot(plot_err_rate)
mean(forest.preds!=test.data[, 18]) 
#DIsplaying the importance for each variable.
importance(Forest)
#Creating an importance plot. Here I found out that the most important 
#variable in deciding whetehr someone will get the vaccine or not is vaccine_hesitant.
varImpPlot(Forest)

#Creating a logistic model.
model.fit <- glm(Covid_data[1:17], data = Covid_data)

coef(model.fit)
#Examining the value of the linear model
model.fit
str(model.fit)
tail(model.fit)
head(model.fit)
#Examining a summary of the linear model.
summary(model.fit)
#Checking the type of the model.fit with typeof.
typeof(summary(model.fit))
length(model.fit)
#Grabbing the coefficients of model.fit and running str to check the data types.
coef(model.fit)
str(model.fit)

#Creating the probability of the vars and displaying them..
model.fit.probs <- predict(model.fit, type="response")
model.fit.probs
#Creating a prediction of the logistic model and displaying the first 50 results.
logistic.prob <- predict(model.fit, type="response")
logistic.prob[1:50]
#Examining the contrasts of vaccine_Hesitancy.
contrasts(train.data$Vaccine_Hesitant)
#Creating a linear model of vaccine hesitancy and the vaccine trust index so that I can examine the data through a linear graph.
Trust.Index.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Vaccine_Trust_Index, data = Covid_data)
str(Trust.Index.Model)

### Creating a plot of county hesitancy vs vaccine trust index
plot(Covid_data$Vaccine_Hesitant,Covid_data$Vaccine_Trust_Index,xlab = "Vaccine Hesitancy", ylab = "Trust index", main  = "Trust Index per County Density", col = 'Green')
###Adding a linear regression line to the chart.
abline(Trust.Index.Model,col = "red")
#Creating a linear model of vaccine hesitancy and the Personal Responsability so that I can examine the data through a linear graph.
Personal.Responsibility.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Personal_Responsibility, data = Covid_data)
str(Personal.Responsibility.Model)
### Creating a plot of county hesitancy vs Personal_Responsibility
plot(Covid_data$Vaccine_Hesitant,Covid_data$Personal_Responsibility,xlab = "Vaccine Hesitancy", ylab = "Personal Responsibility", main  = "Personal Responsibility per County Density", col='Dark Green')
###Adding a linear regression line to the chart.
abline(Personal.Responsibility.Model,col = "red")
#Creating a linear model for vaccine hesitancy and perceived risk.
Perceived.Risk.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Perceived_Risk, data = Covid_data)
str(Perceived.Risk.Model)
### Creating a plot of county hesitancy vs Perceived_Risk
plot(Covid_data$Vaccine_Hesitant,Covid_data$Perceived_Risk,xlab = "Vaccine Hesitancy", ylab = "Perceived Risk", main  = "Perceived Risk per County Density", col = 'Blue')
###Adding a linear Vaccine_Hesitant line to the chart.
abline(Perceived.Risk.Model,col = "red")
#Creating a linear model for only the fear of needles and vaccine hesitancy.
Fear.Needles.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Fear_Needles, data = Covid_data)
str(Fear.Needles.Model)
### Creating a plot of county hesitancy vs Fear_Needles
plot(Covid_data$Vaccine_Hesitant,Covid_data$Fear_Needles,xlab = "Vaccine Hesitancy", ylab = "Fear Needles", main  = "Fear Needles per County Density", col = 'Dark Blue')
###Adding a linear regression line to the chart.
abline(Fear.Needles.Model,col = "red")
#Creating a linear model for only the condition pregnancy and vaccine hesitancy.
Condition.Pregnancy.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Condition_Pregnancy, data = Covid_data)
str(Condition.Pregnancy.Model)
### Creating a plot of county hesitancy vs Condition_Pregnancy
plot(Covid_data$Vaccine_Hesitant,Covid_data$Condition_Pregnancy,xlab = "Vaccine Hesitancy", ylab = "Condition Pregnancy", main  = "Condition Pregnancy per County Density (yes/no)", col='Purple')
###Adding a linear regression line to the chart.
abline(Condition.Pregnancy.Model,col = "red")
#Creating a linear model for only the condition immune and vaccine hesitancy.
Condition.Immune.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Condition_Immune, data = Covid_data)
str(Condition.Immune.Model)
### Creating a plot of county hesitancy vs Condition_Immune
plot(Covid_data$Vaccine_Hesitant,Covid_data$Condition_Immune,xlab = "Vaccine Hesitancy", ylab = "Condition Immune", main  = "Condition Immune (Yes/No)", col='Magenta')
###Adding a linear regression line to the chart.
abline(Condition.Immune.Model,col = "red")
#Creating a linear model for only the covid cases and vaccine hesitancy.
Condition.Immune.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$County_Cases, data = Covid_data)
str(Condition.Immune.Model)
### Creating a plot of county hesitancy vs County_Cases
plot(Covid_data$Vaccine_Hesitant,Covid_data$County_Cases,xlab = "Vaccine Hesitancy", ylab = "County Cases", main  = "County Cases", col='Grey')
###Adding a linear regression line to the chart.
abline(Condition.Immune.Model,col = "red")

#Creating a linear model for only the race and vaccine hesitancy.
Race.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Race, data = Covid_data)
str(Race.Model)
### Creating a plot of county hesitancy vs Race
plot(Covid_data$Vaccine_Hesitant,Covid_data$Race,xlab = "Vaccine Hesitancy", ylab = "Race", main  = "Race", col='Brown')
###Adding a linear regression line to the chart.
abline(Race.Model,col = "red")
#Creating a linear model for only the age and vaccine hesitancy.
Age.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Age, data = Covid_data)
str(Age.Model)
### Creating a plot of county hesitancy vs Age
plot(Covid_data$Vaccine_Hesitant,Covid_data$Age,xlab = "Vaccine Hesitancy", ylab = "Age", main  = "Age", col = 'Violet')
###Adding a linear regression line to the chart.
abline(Age.Model,col = "Black")

#Creating a linear model for only the College degree and vaccine hesitancy.
College.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$College_Degree, data = Covid_data)
str(College.Model)
### Creating a plot of county hesitancy vs College_Degree
plot(Covid_data$Vaccine_Hesitant,Covid_data$College_Degree,xlab = "Vaccine Hesitancy", ylab = "College Degree", main  = "Vaccine Hesitation among College Degree Holders", col='Dark Orange')
###Adding a linear regression line to the chart.
abline(College.Model,col = "Blue")

#Creating a linear model for only the race and vaccine hesitancy.
Pandemic.Impact.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Pandemic_Impact, data = Covid_data)
str(Pandemic.Impact.Model)
### Creating a plot of county hesitancy vs Pandemic_Impact
plot(Covid_data$Vaccine_Hesitant,Covid_data$Pandemic_Impact,xlab = "Vaccine Hesitancy", ylab = "Pandemic Impact", main  = "Vaccine Hesitancy among Pandemic Impacted", col='Orange')
###Adding a linear regression line to the chart.
abline(Pandemic.Impace.Model,col = "Blue")


#Creating a linear model for only the race and vaccine hesitancy.
Pandemic.Network.Impact.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Pandemic_Impact_Network, data = Covid_data)
str(Pandemic.Network.Impact.Model)
### Creating a plot of county hesitancy vs Pandemic impact network.
plot(Covid_data$Vaccine_Hesitant,Covid_data$Pandemic_Impact_Network,xlab = "Vaccine Hesitancy", ylab = "Pandemic Impact Network", main  = "Vaccine Hesitancy due to Pandemic Impact Network", col='Tan')
###Adding a linear regression line to the chart.
abline(Pandemic.Network.Impact.Model,col = "Blue")

#Creating a linear model for only the infected personel and vaccine hesitancy.
Infected.Personel.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Infected_Personal, data = Covid_data)
str(Infected.Personel.Model)
### Creating a plot of county hesitancy vs Infected_Personal
plot(Covid_data$Vaccine_Hesitant,Covid_data$Infected_Personal,xlab = "Vaccine Hesitancy", ylab = "Infected Personal", main  = "Vaccine Hesitation among Infected Personal")
###Adding a linear regression line to the chart.
abline(Infected.Personel.Model,col = "red")


#Creating a linear model for only the infected personel and vaccine hesitancy.
Infected.Network.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Infected_Network, data = Covid_data)
str(Infected.Network.Model)
### Creating a plot of county hesitancy vs Infected_Network
plot(Covid_data$Vaccine_Hesitant,Covid_data$Infected_Network,xlab = "Vaccine Hesitancy", ylab = "Infected Network", main  = "Vaccine Hesitancy per Infected Network")
###Adding a linear regression line to the chart.
abline(Infected.Network.Model,col = "red")

#Creating a linear model for only the household income and vaccine hesitancy.
Household.Income.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Household_Income, data = Covid_data)
str(Household.Income.Model)
### Creating a plot of county hesitancy vs Household_Income
plot(Covid_data$Vaccine_Hesitant,Covid_data$Household_Income,xlab = "Vaccine Hesitancy", ylab = "Household Income", main  = "Vaccine Hesitancy per Household Income")
###Adding a linear regression line to the chart.
abline(Household.Income.Model,col = "red")

#Creating a linear model for only the household income and vaccine hesitancy.
Vaccine.Required.Model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$Vaccine_Required, data = Covid_data)
str(Vaccine.Required.Model)
### Creating a plot of county hesitancy vs Vaccine_Required
plot(Covid_data$Vaccine_Hesitant,Covid_data$Vaccine_Required,xlab = "Vaccine Hesitancy", ylab = "Vaccine Required", main  = "Vaccine Hesitancy among Vaccine Required")
###Adding a linear regression line to the chart.
abline(Vaccine.Required.Model,col = "red")

#Creating a linear model for only the household income and vaccine hesitancy.
County.Density.model <- lm(Covid_data$Vaccine_Hesitant ~ Covid_data$County_Density, data = Covid_data)

#Observing the correlation between county density through vaccine hesitancy through a plot.
plot(Covid_data$Vaccine_Hesitant,Covid_data$County_Density,main = "Vaccine Hesitancy per county density",xlab = "Vaccine hesitancy", ylab = "County Density")
### Adding a linear regression line to the chart.
abline(County.Density.model,col='red')

#Creating a linear model that will encompass all of the variables
zero_significance = lm(Covid_data$Vaccine_Hesitant ~ Covid_data$County_Density+Covid_data$Vaccine_Trust_Index + Covid_data$Personal_Responsibility + Covid_data$Perceived_Risk + Covid_data$Fear_Needles + Covid_data$Condition_Pregnancy + Covid_data$Condition_Immune + Covid_data$County_Cases + Covid_data$Race+Covid_data$Age+Covid_data$College_Degree+Covid_data$Pandemic_Impact+Covid_data$Pandemic_Impact_Network+Covid_data$Infected_Personal+Covid_data$Infected_Network+Covid_data$Household_Income+Covid_data$Vaccine_Required)                        
#Examining the level of significance.
summary(zero_significance)



