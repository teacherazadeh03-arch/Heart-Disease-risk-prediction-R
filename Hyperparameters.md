Hyperparameters

These are set by you before training.

They control how the model learns.

The model does not change them automatically.

Choosing the right hyperparameters can greatly improve performance.

Comparison Summary

| Metric                    | Untuned GBM | Tuned GBM | Change  |
| ------------------------- | ----------- | --------- | ------- |
| Accuracy                  | 0.8652      | 0.8876    | +0.0224 |
| Kappa                     | 0.7267      | 0.7723    | +0.0456 |
| Sensitivity (No)          | 0.9167      | 0.9375    | +0.0208 |
| Specificity (Yes)         | 0.8049      | 0.8293    | +0.0244 |
| Positive Predictive Value | 0.8462      | 0.8654    | +0.0192 |
| Negative Predictive Value | 0.8919      | 0.9189    | +0.0270 |
| Balanced Accuracy         | 0.8608      | 0.8834    | +0.0226 |
| ROC-AUC                   | N/A         | 0.9157    | +       |

Observations

All metrics improved after hyperparameter tuning.

Accuracy increased by ~2.2%, showing better overall predictions.

Kappa improved, indicating better agreement beyond chance.

Sensitivity and Specificity both improved → the model is now better at detecting both positives and negatives.

Positive/Negative Predictive Values also increased → predictions are more reliable.

Balanced Accuracy went up → tuning improved fairness between classes.

ROC-AUC is available after (0.9157), indicating strong discriminative power.

| Metric                     | Before Tuning | After Tuning | Change  |
| -------------------------- | ------------- | ------------ | ------- |
| Accuracy                   | 0.8764        | 0.8876       | +0.0112 |
| Kappa                      | 0.7481        | 0.7706       | +0.0225 |
| Sensitivity (Positive = 0) | 0.9583        | 0.9792       | +0.0209 |
| Specificity (Negative = 1) | 0.7805        | 0.7805       | 0       |
| Positive Predictive Value  | 0.8364        | 0.8393       | +0.0029 |
| Negative Predictive Value  | 0.9412        | 0.9697       | +0.0285 |
| Balanced Accuracy          | 0.8694        | 0.8798       | +0.0104 |
Observations

Accuracy improved slightly (~1.1%) after tuning.

Kappa increased, indicating slightly better agreement beyond chance.

Sensitivity increased → model is better at detecting positives.

Specificity stayed the same → model’s ability to detect negatives didn’t change.

Negative Predictive Value improved → fewer false negatives.

Balanced Accuracy increased slightly → better balance between sensitivity and specificity.
