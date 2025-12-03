# Heart-Disease-risk-prediction-R
This R code loads the UCI dataset, clean it, build the decision tree, and output results
You may see errors like:

Timeout of 60 seconds

no package called 'stringi'

could not find function 'createDataPartition'

object 'train_data' not found

These errors are all connected:

The package stringi failed to download (usually due to a slow or blocked CRAN mirror).

Because stringi is missing, caret cannot install or load.

Functions from caret such as createDataPartition() and confusionMatrix() are therefore unavailable.

Since data splitting fails, objects like train_data, test_data, and the model are never created, causing downstream errors.

✔️ How to Fix

Try a different CRAN mirror:

chooseCRANmirror()
install.packages("stringi")
install.packages("caret")


Or install stringi manually from CRAN.

Or run the workflow without caret using manual train/test splitting.
