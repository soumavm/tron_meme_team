import pandas as pd
import numpy as np
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix, roc_curve, auc
from sklearn.ensemble import RandomForestClassifier
import random
from sklearn.utils.multiclass import unique_labels
from keras.wrappers.scikit_learn import KerasRegressor
from keras.layers import Dense

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold

from keras import layers, models
import matplotlib.pyplot as plt
from keras.optimizers import Adam

import tensorflowjs as tfjs

random.seed(1234)
np.random.seed(1234)
data = pd.read_csv(r"D:\Dhruv\spaceapps_data.csv")
target = data['% positive cases (may 25)']
data.drop('% positive cases (may 25)', axis=1, inplace=True)
#data.drop('may 25 - may 28', axis=1, inplace=True)
#data.drop('% positive cases (may 18)', axis=1, inplace=True)

x_train, x_test, y_train, y_test = train_test_split(
    data, target, test_size=0.2)
x_validate, x_test, y_validate, y_test = train_test_split(
    x_test, y_test, test_size=0.5)
x_train = x_train.astype(float)
x_validate = x_validate.astype(float)
x_test = x_test.astype(float)
y_train = y_train.astype(float)
y_validate = y_validate.astype(float)
y_test = y_test.astype(float)


def create_model():
    model = models.Sequential()
    model.add(Dense(5, input_dim=5, kernel_initializer='normal', activation='relu'))
    model.add(Dense(10, input_dim=5, kernel_initializer='normal', activation='relu'))
    model.add(Dense(1, kernel_initializer='normal', activation='relu'))
    model.compile(loss='mse', optimizer='adam')
    # Trains model on 100 iterations (epochs). The model is called "estimator"
    estimator = KerasRegressor(
        build_fn=create_model, epochs=100, batch_size=5, verbose=0)
    kfold = KFold(n_splits=10)
    # evaluates model on the test set (after validation using validation set)
    results = cross_val_score(estimator, x_test, y_test, cv=kfold)
    return estimator

# print("Baseline: %.2f (%.2f) MSE" % (results.mean(), results.std())) #This finds and displays mean squared error, and standard deviation of the data to indicate how accurate the model is

#print(estimator.predict([65161, 16516, 156151, 231, 561]))

# you won't be using the tensorflow.js library
# you'll just need to do in JS: Why isn't tensorflow installing
#
# async function predict(values) {
#     const resp = await fetch(`http://127.0.0.1:8081/predict?values=${values.join(",")}`)
#     return await resp.json()
# }
#
# and
#
# predict([1, 2, 3, 4, 5, 6]).then(function (result) {
#      // do something with result
# })
#


import flask
from flask.json import jsonify

app = flask.Flask(__name__)

@app.route('/predict', methods=['GET'])
def home():
    values = map(float, flask.request.args.get("values").split(",")) # parse the parameters

    # call the estimator 
    result = {}  # TODO
    return jsonify(result)


app.run(host="0.0.0.0", port=8081)
