###########################################################
# Random Forest Hyperparameter Tuning - Heart Disease
###########################################################

# Install/load packages
required_packages <- c("caret","randomForest","pROC")
for(pkg in required_packages){
  if(!require(pkg, character.only = TRUE)) install.packages(pkg)
  library(pkg, character.only = TRUE)
}

# Load Cleveland dataset from UCI
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
col_names <- c("age","sex","cp","trestbps","chol","fbs","restecg",
               "thalach","exang","oldpeak","slope","ca","thal","target")
heart_data <- read.csv(url, header = FALSE, col.names = col_names, na.strings = "?")

# Binary target
heart_data$target <- ifelse(heart_data$target > 0, 1, 0)
heart_data$target <- factor(heart_data$target, levels = c(0,1), labels = c("No","Yes"))
heart_data <- na.omit(heart_data)

# Train/Test split
set.seed(123)
train_index <- createDataPartition(heart_data$target, p = 0.7, list = FALSE)
train_data <- heart_data[train_index, ]
test_data  <- heart_data[-train_index, ]

# Train Control: 10-fold CV
train_ctrl <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary)

# Hyperparameter grid
rf_grid <- expand.grid(mtry = c(2,3,4,5))

# Train Random Forest
set.seed(123)
rf_tuned <- train(target ~ ., data = train_data,
                  method = "rf",
                  metric = "ROC",
                  tuneGrid = rf_grid,
                  trControl = train_ctrl,
                  ntree = 500)

print(rf_tuned)

# Predict & evaluate
rf_preds <- predict(rf_tuned, test_data)
print(confusionMatrix(rf_preds, test_data$target))

# ROC-AUC
rf_probs <- predict(rf_tuned, test_data, type = "prob")
roc_rf <- roc(as.numeric(test_data$target=="Yes"), rf_probs$Yes)
cat("Random Forest ROC AUC:", auc(roc_rf), "\n")
