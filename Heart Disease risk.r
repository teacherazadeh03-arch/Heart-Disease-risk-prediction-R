###########################################################
# R Pipeline: Load directly from UCI
###########################################################

# 1️⃣ Install/load packages
required_packages <- c("caret","rpart","rpart.plot","randomForest","gbm","pROC")
for(pkg in required_packages){
  if(!require(pkg, character.only = TRUE)) install.packages(pkg)
  library(pkg, character.only = TRUE)
}

# 2️⃣ Load Cleveland dataset directly from UCI
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"

# Column names as per UCI description
col_names <- c("age","sex","cp","trestbps","chol","fbs","restecg",
               "thalach","exang","oldpeak","slope","ca","thal","target")

heart_data <- read.csv(url, header = FALSE, col.names = col_names, na.strings = "?")

# 3️⃣ Data cleaning
heart_data$target <- ifelse(heart_data$target > 0, 1, 0)  # binary: 0=no disease, 1=disease
heart_data$target <- as.factor(heart_data$target)
heart_data <- na.omit(heart_data)  # remove rows with missing values

# 4️⃣ Train/Test Split
set.seed(123)
train_index <- createDataPartition(heart_data$target, p = 0.7, list = FALSE)
train_data <- heart_data[train_index, ]
test_data  <- heart_data[-train_index, ]

# 5️⃣ Evaluation helper function
evaluate_model <- function(preds, test_target, model_name){
  preds_class <- if(is.numeric(preds)) ifelse(preds > 0.5, 1, 0) else preds
  preds_class <- as.factor(preds_class)
  cat("\n------------------------------\n")
  cat(model_name,"\n")
  cat("------------------------------\n")
  print(confusionMatrix(preds_class, test_target))
  # ROC-AUC
  if(is.numeric(preds)){
    roc_obj <- roc(as.numeric(test_target), preds)
    cat("ROC AUC:", auc(roc_obj), "\n")
  }
}

###########################################################
# 6️⃣ Decision Tree
###########################################################
dt_model <- rpart(target ~ ., data = train_data, method = "class")
dt_preds <- predict(dt_model, test_data, type = "class")
evaluate_model(dt_preds, test_data$target, "Decision Tree")
rpart.plot(dt_model)

###########################################################
# 7️⃣ Random Forest
###########################################################
rf_model <- randomForest(target ~ ., data = train_data, ntree = 500, mtry = 4)
rf_preds <- predict(rf_model, test_data)
evaluate_model(rf_preds, test_data$target, "Random Forest")

###########################################################
# 8️⃣ Logistic Regression
###########################################################
log_model <- glm(target ~ ., data = train_data, family = binomial)
log_preds <- predict(log_model, test_data, type = "response")
evaluate_model(log_preds, test_data$target, "Logistic Regression")

###########################################################
# 9️⃣ Gradient Boosting (GBM)
###########################################################
# Numeric target for GBM
train_data$target_num <- as.numeric(as.character(train_data$target))
test_data$target_num  <- as.numeric(as.character(test_data$target))

gbm_model <- gbm(
  target_num ~ .,
  data = train_data[, -which(names(train_data) == "target")],
  distribution = "bernoulli",
  n.trees = 500,
  interaction.depth = 3,
  shrinkage = 0.01,
  n.minobsinnode = 10,
  verbose = FALSE
)

gbm_preds <- predict(gbm_model, test_data[, -which(names(test_data) %in% c("target","target_num"))],
                     n.trees = 500, type = "response")
evaluate_model(gbm_preds, test_data$target, "Gradient Boosting")

###########################################################
#  🔟 Random Forest Feature Importance
###########################################################
importance <- data.frame(Feature = rownames(rf_model$importance),
                         Importance = rf_model$importance[,1])
importance <- importance[order(importance$Importance, decreasing = TRUE), ]
print(importance)
barplot(importance$Importance, names.arg = importance$Feature, las=2,
        main="Random Forest Feature Importance", cex.names=0.8)
