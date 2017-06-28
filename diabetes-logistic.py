import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv('pima-data.csv')
del df['skin']
diabetes_map = {True:1, False:0}
df['diabetes'] = df['diabetes'].map(diabetes_map)

from sklearn.model_selection import train_test_split
featured_col_names = ['num_preg', 'glucose_conc', 'diastolic_bp', 'thickness', 'insulin', 'bmi', 'diab_pred', 'age']
predicted_class_names = ['diabetes']
x = df[featured_col_names].values #Predictor containing feature columns
y = df[predicted_class_names].values #Predicted class column

from sklearn import preprocessing
min_max_scaler=preprocessing.MinMaxScaler()
x=min_max_scaler.fit_transform(x)

split_test_size = 0.30 #Give split as 30% for test
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=split_test_size, random_state=666)
from sklearn.preprocessing import Imputer
fill0 = Imputer(missing_values=0, strategy="mean", axis=0) # axis=0 means column
x_train = fill0.fit_transform(x_train)
x_test = fill0.fit_transform(x_test)

from sklearn.linear_model import LogisticRegression
from sklearn import metrics
lr_model = LogisticRegression(C=0.7)
lr_model.fit(x_train, y_train.ravel())
lr_predict_test = lr_model.predict(x_test)
metrics.confusion_matrix(y_test, lr_predict_test, labels=[1,0])
print(metrics.classification_report(y_test, lr_predict_test, labels=[1,0]))