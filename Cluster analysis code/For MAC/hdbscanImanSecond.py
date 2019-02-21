import sys
import hdbscan
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
X=np.genfromtxt('TempHDBSCANfile.txt')
Y=np.genfromtxt('TempHDBSCANparameters.txt')
MinClusterSize=int(Y[0])
MinSamples=int(Y[1])

clusterer = hdbscan.HDBSCAN(min_cluster_size=MinClusterSize,min_samples=MinSamples,
                            cluster_selection_method='eom',approx_min_span_tree=False).fit(X)
tree=clusterer.condensed_tree_.plot(select_clusters=True,selection_palette=sns.color_palette())
np.savetxt('HDBSCANoutputs/Labels.txt',clusterer.labels_, fmt='%d',comments='')
np.savetxt('HDBSCANoutputs/Persistence.txt',clusterer.cluster_persistence_,comments='')
np.savetxt('HDBSCANoutputs/Probabilities.txt',clusterer.probabilities_,comments='')    
