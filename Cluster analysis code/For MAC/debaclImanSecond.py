import sys
import numpy as np
import matplotlib.pyplot as plt
import debacl as dcl
from sklearn.neighbors import KNeighborsClassifier
X=np.genfromtxt('HDBSCANdClusterForDeBaCl_position.txt')
n=len(X) #Number of atoms in the dataset
Y=np.genfromtxt('tempDeBaClparameters.txt')
p=int(Y[0])
k=int(Y[1])
gamma=int(Y[2])

#gamma: Leaf nodes with fewer than this number (i.e., prune_threshold or 
# gamma)of members are recursively merged into larger nodes. 
# If 'None' (the default), then no pruning is performed.

knn_graph, radii = dcl.utils.knn_graph(X, k, method='kd-tree')
density = dcl.utils.knn_density(radii, n, p, k)

#num_level: Number of density levels in the constructed tree.
#If None (default), num_levels is internally set to be the number of rows in X
#verbose: if True, a progress indicator is printed at every 100th leevl of tree construction
tree = dcl.construct_tree_from_graph(knn_graph, density, prune_threshold=gamma,
                                     verbose=False)
def out_fun():
    return str(tree)
output = out_fun()
file = open("DeBaClTempOutputs/DeBaCl_treeOutput.txt","w")
file.write(output)
file.close()

np.savetxt('DeBaClTempOutputs/DeBaCl_density.txt',tree.density)

#when fill_background is True, it means that
#the label of noise points is considered as -1
labels = tree.get_clusters(fill_background=True)
#The first column is the row number of the dataset(i.e., x,y,z of the atoms)
#The second column is the label of cluster for each atom.
np.savetxt('DeBaClTempOutputs/DeBaCl_labels.txt',labels,fmt='%d %d')

leaves = tree.get_leaf_nodes()
labels = tree.get_clusters()
fig = tree.plot(form='mass', color_nodes=leaves, colormap=plt.cm.jet)[0]
fig.show()
fig.savefig('DeBaClTempOutputs/DeBaCl_plot.png',dpi=(300))
