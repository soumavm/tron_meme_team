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
from keras.wrappers.scikit_learn import KerasRegressor
from keras.layers import Dense

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold

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
x_train = x_train.astype(float)
x_validate = x_validate.astype(float)
x_test = x_test.astype(float)
y_train = y_train.astype(float)
y_validate = y_validate.astype(float)
y_test = y_test.astype(float)
    
def create_model():
    model = models.Sequential()
    model.add(Dense(5, input_dim=5,kernel_initializer='normal', activation='relu'))
    model.add(Dense(10, input_dim=5, kernel_initializer='normal', activation='relu'))
    model.add(Dense(1, kernel_initializer='normal', activation='relu'))
    model.compile(loss='mse', optimizer='adam')
    return model

estimator = KerasRegressor(build_fn=create_model, epochs=100, batch_size=5, verbose=0)
kfold = KFold(n_splits=10)
results=cross_val_score(estimator, x_test, y_test, cv=kfold)
print("Baseline: %.2f (%.2f) MSE" % (results.mean(), results.std()))
