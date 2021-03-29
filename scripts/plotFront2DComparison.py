import pandas as pd 
import matplotlib.pyplot as plt
import sys
import numpy as np


paretoFront = "OW_NSGAII_160321_160131_Front"
paretoFront = str(sys.argv[1])

start = paretoFront.find('data') if paretoFront.find('data') != -1 else 0
title = paretoFront[paretoFront.find('data'):]

f = pd.read_csv(paretoFront, header=0, delimiter="\t", index_col=False)
separatorIndex = f.loc[f.iloc[:,0]=="="]
prismIndex = separatorIndex.index[0]
stormIndex = separatorIndex.index[1]

evo   = pd.DataFrame({f.columns[0]:f.iloc[:prismIndex,0], f.columns[1]:f.iloc[:prismIndex,1]})
prism = pd.DataFrame({f.columns[0]:f.iloc[prismIndex+1:stormIndex,0], f.columns[1]:f.iloc[prismIndex+1:stormIndex,1]})
storm = pd.DataFrame({f.columns[0]:f.iloc[stormIndex+1:,0], f.columns[1]:f.iloc[stormIndex+1:,1]})

new_dtypes = {c : np.float64 for c in f.columns}
evo   = evo.astype(new_dtypes)
prism = prism.astype(new_dtypes)
storm = storm.astype(new_dtypes)

plt.scatter(evo.iloc[:,0], evo.iloc[:,1], c="r", label='Evo')# s=area, c=colors, alpha=0.5)
plt.scatter(prism.iloc[:,0], prism.iloc[:,1], c="b", marker='x', label='Prism')# s=area, c=colors, alpha=0.5)
plt.scatter(storm.iloc[:,0], storm.iloc[:,1], c="g", marker='.', label='Storm')# s=area, c=colors, alpha=0.5)
plt.xlabel(f.columns[0], fontsize=14)
plt.ylabel(f.columns[1], fontsize=14)
plt.title(title, fontsize=16)
plt.legend()

plt.savefig(title)
plt.show()
