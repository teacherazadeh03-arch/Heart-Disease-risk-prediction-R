# Load dataset directly from UCI
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
col_names <- c("age","sex","cp","trestbps","chol","fbs","restecg",
               "thalach","exang","oldpeak","slope","ca","thal","target")
heart_data <- read.csv(url, header = FALSE, col.names = col_names, na.strings = "?")

# Clean dataset
heart_data$target <- ifelse(heart_data$target > 0, 1, 0)
heart_data$target <- as.factor(heart_data$target)
heart_data <- na.omit(heart_data)

# Install packages if not already installed
install.packages(c("rpart","rpart.plot","caret"))

# Load packages
library(rpart)
library(rpart.plot)
library(caret)

# Split data
set.seed(123)
train_index <- createDataPartition(heart_data$target, p = 0.7, list = FALSE)
train_data <- heart_data[train_index, ]
test_data <- heart_data[-train_index, ]

# Train Decision Tree
heart_tree <- rpart(target ~ ., data = train_data, method = "class")

# Plot the tree
rpart.plot(heart_tree)

# Predictions
predictions <- predict(heart_tree, test_data, type = "class")

# Evaluate
confusionMatrix(predictions, test_data$target)
