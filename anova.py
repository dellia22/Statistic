#!/usr/bin/python

#One-way anova with PYTHON

import sys

import os

import numpy as np # fundamental package for scientific computing with Python

import pandas as pd 

import xlrd #Extract data from Excel spreadsheets

from openpyxl import Workbook #Openpyxl is a Python library for reading and writing Excel (with extension xlsx/xlsm/xltx/xltm) files 

import matplotlib #Matplotlib is a Python 2D plotting library which produces publication quality figures in a variety of hardcopy formats and interactive environments across platforms
import matplotlib as mpl
import matplotlib.pyplot as plt
from matplotlib import pyplot

import plotly #Plotly is an online collaborative data analysis and graphing tool. The Python API allows you to access all of Plotly's functionality from Python.
plotly.tools.set_credentials_file(username='laurahj', api_key='RVPLUoRgWfFI8EmphsEv') #it is a requeriment for visualizating tables of levene and shapiro, create account in https://plot.ly/  #se puede usar la cuenta laurahj porque se creo para este script
import plotly.plotly as py
import plotly.graph_objs as go
import plotly.figure_factory as ff

import statsmodels.api as sm  #statsmodels is a Python module that provides classes and functions for the estimation of many different statistical models, as well as for conducting statistical tests, and statistical data exploration
from statsmodels.formula.api import ols
from statsmodels.graphics.gofplots import qqplot
from statsmodels.stats.multicomp import pairwise_tukeyhsd

import scipy  #is a free and open-source Python library used for scientific computing and technical computing. 
from scipy import stats
from scipy.stats import levene
from scipy.stats import shapiro


#Open the Directory
current, dirs, files = os.walk('/home/gonzalez/Documentos/laura/Docencia/python').next()

#Save data in variable df  
df = pd.read_excel(io="ANOVALUZ.xlsx", sheet_name= "Hoja1")
print(df) #see data in the terminal

#Visualization of data
df.boxplot('Colonias', by='factor', figsize=(12, 8))
plt.show()

#Calculating ANOVA  
mod = ols('Colonias ~ factor', data=df).fit() #we obtain a fitted model that we later use with the anova_lm method to obtain a ANOVA table
aov_table = sm.stats.anova_lm(mod, typ=2) #tabla de anova con el estadistico F
aov_table.to_excel('tabla_anova.xlsx')  #fichero de salida con la tabla de anova


#VALIDATION OF ASSUMPTIONS
#1-VARIANCE HOMOGENEITY BY LEVENE TEST
luzverde=df['Colonias'][0:3] #accessing values of luzverde
luzamarilla=df['Colonias'][3:] #accessing values of luzamarilla
levene_results= scipy.stats.levene(luzverde, luzamarilla)
matrix_lv = [['', 'DF', 'Test Statistic', 'p-value'], ['Sample Data', len(luzverde+luzamarilla) -1, levene_results[0], levene_results[1]]]
levene_table= ff.create_table(matrix_lv, index=True)
py.iplot(levene_table, filename='levene-table') #result is showed in https://plot.ly/account, you should create an account in that webside)


#2-NORMAL DISTRIBUTION BY SHAPIRO TEST
x = df['Colonias'] #data for test
shapiro_results = scipy.stats.shapiro(x)
matrix_sw = [['', 'DF', 'Test Statistic', 'p-value'], ['Sample Data', len(x) -1, shapiro_results[0], shapiro_results[1]]]
shapiro_table = ff.create_table(matrix_sw, index=True)
py.iplot(shapiro_table, filename='shapiro-table') #result is showed in https://plot.ly/account, you should create an account in that webside) 


#MULTIPLE PAIRWISE-COMPARISON BETWEEN THE MEANS OF GROUPS BY TUKEY TEST
groups=df['factor']
x = df['Colonias'] 
test_tukey=pairwise_tukeyhsd(x, groups)  
	#convert statsmodels summary object to panda dataframe and open as xlsx file
results = pd.DataFrame(data=test_tukey._results_table.data[1:], columns=test_tukey._results_table.data[0]) 
results.to_excel('test-tukey.xlsx') #we reject the hypothesis that the treatments have the same mean 



	






