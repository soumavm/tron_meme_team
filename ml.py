import pandas as pd
import numpy as np
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix, roc_curve, auc
from sklearn.ensemble import RandomForestClassifier 
import random
import seaborn as sns
from sklearn.utils.multiclass import unique_labels

from keras import layers, models
import matplotlib.pyplot as plt
from keras.applications import MobileNet
from keras.optimizers import Adam

random.seed(1234)
np.random.seed(1234)
data = pd.read_csv(r"D:\Dhruv\spaceapps_data.csv")
target = data['% positive cases (may 25)']
data.drop('% positive cases (may 25)', axis=1, inplace=True)
#data.drop('may 25 - may 28', axis=1, inplace=True)
#data.drop('% positive cases (may 18)', axis=1, inplace=True)

x_train, x_test, y_train, y_test = train_test_split(data, target, test_size = 0.2)
x_validate, x_test, y_validate, y_test = train_test_split(x_test, y_test, test_size=0.5)

def random_forest():
    clf = RandomForestClassifier(n_estimators = 60, max_depth = 4, min_samples_split = 0.01)
    clf.fit(x_train, y_train)
    y_pred = clf.predict(x_validate)
    clf_accuracy = accuracy_score(y_validate, y_pred)
    return clf_accuracy
    
    
def create_model():
    model = models.Sequential()
    model.add(Dense(6, input_dim=6,kernel_initializer='normal', activation='relu'))
    model.add(Dense(1, kernel_initializer='normal'))
    model.compile(loss='mse', optimizer='adam')
    return model

estimator = KerasRegressor(build_fn=create_model(), epochs=100, batch_size=5, verbose=0)
kfold = KFold(n_splits=10)
results=cross_val_score(estimator, x_validation, y_validation, cv=kfold)
print("Baseline: %.2f (%.2f) MSE" % (results.mean(), results.std()))
