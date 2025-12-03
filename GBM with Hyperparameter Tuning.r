###########################################################
# GBM Hyperparameter Tuning - Heart Disease
###########################################################

# Install/load packages
required_packages <- c("caret","gbm","pROC")
for(pkg in required_packages){
  if(!require(pkg, character.only = TRUE)) install.packages(pkg)
  library(pkg, character.only = TRUE)
}

# Load Cleveland dataset from UCI
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
col_names <- c("age","sex","cp","trestbps","chol","fbs","restecg",
               "thalach","exang","oldpeak","slope","ca","thal","target")
heart_data <- read.csv(url, header = FALSE, col.names = col_names, na.strings = "?")

# Binary target as factor
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

# Hyperparameter grid for GBM
gbm_grid <- expand.grid(
  n.trees = c(100,200,500),
  interaction.depth = c(1,3,5),
  shrinkage = c(0.01,0.05),
  n.minobsinnode = c(5,10)
)

# Train GBM
set.seed(123)
gbm_tuned <- train(target ~ ., data = train_data,
                   method = "gbm",
                   metric = "ROC",
                   tuneGrid = gbm_grid,
                   trControl = train_ctrl,
                   verbose = FALSE)

print(gbm_tuned)

# Predict & evaluate
gbm_preds <- predict(gbm_tuned, test_data)
print(confusionMatrix(gbm_preds, test_data$target))

# ROC-AUC
gbm_probs <- predict(gbm_tuned, test_data, type="prob")
roc_gbm <- roc(as.numeric(test_data$target=="Yes"), gbm_probs$Yes)
cat("GBM ROC AUC:", auc(roc_gbm), "\n")
