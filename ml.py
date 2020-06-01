import pandas as pd
import numpy as np
from sklearn.metrics import accuracy_score
import pandas as pd
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix, roc_curve, auc
from sklearn.ensemble import RandomForestClassifier 

#from treeinterpreter import treeinterpreter as ti, utils
import matplotlib.pyplot as plt
from matplotlib.colorbar import ColorbarBase
import numpy as np
import random
from sklearn.utils.multiclass import unique_labels

from sklearn.model_selection import cross_val_score
from sklearn.model_selection import KFold

random.seed(1234)
np.random.seed(1234)
data = pd.read_csv(r"D:\Dhruv\spaceapps_data.csv")
target = data['Hotspot']
data.drop('% positive cases (may 25)', axis=1, inplace=True)
data.drop('Hotspot', axis=1, inplace=True)

x_train, x_test, y_train, y_test = train_test_split(data, target, test_size=0.1)

x_train = x_train.astype(float)
#x_validate = x_validate.astype(float)
x_test = x_test.astype(float)
y_train = y_train.astype(float)
#y_validate = y_validate.astype(float)
y_test = y_test.astype(float)

clf = RandomForestClassifier(n_estimators=60, max_depth=4, min_samples_split=0.01)
clf.fit(x_train, y_train)
#y_pred_test = clf.predict(x_test)
#print(accuracy_score(y_test, y_pred_test))

#print(x_test.iloc[0].shape)

#arr = [[0, 40, 120630, 1, 1485.79, 288, 39.4, 952421]]
#arr = np.array(arr) 
#print(clf.predict(arr))

import flask
from flask.json import jsonify

app = flask.Flask(__name__)

@app.route('/predict', methods=['GET'])
def home():
    values = [float(x.strip()) for x in flask.request.args.get("values").split(",")] 
    #map(float, flask.request.args.get("values").split(",")) # parse the parameters
    # call the estimator 
    result = {
        "Value:": clf.predict([values])[0] 
        }  # This will take in the values and give it to Adi
    return jsonify(result)
app.run(host="0.0.0.0", port=8094)
