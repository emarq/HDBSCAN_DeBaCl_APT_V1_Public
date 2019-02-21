====================================
Before starting:
====================================
(1) The methods and code are described in Ghamarian & Marquis, Hierarchical Density-Based Cluster Analysis Framework for Atom Probe Tomography Data, Ultramicroscopy, 2019. https://doi.org/10.1016/j.ultramic.2019.01.011

(2) As many other cluster finding algorithms, the answer might depend on the parameter value selection. We suggest that the user become familiar with the selection of parameter values by simulating clusters microstructures and evaluating parameters values for optimal selection.

(3) We tested the code for volumes containing up to 526000 atoms of interest, on a MAC MacBook Pro (specificity of the computer in terms of speed and memory). We found the code to unreliably work on Windows and the performance has not been tested on Linux. 

====================================
INSTALLATION of Python and required packages :
====================================
-------
For MAC:
-------
(1) Install python: to run the code in MATLAB, we need to install python because some parts of the calculations are done in python.
This link "https://docs.python-guide.org/starting/install/osx/" provides python 2.7.15.
(2) The command "pip list" will show the installed packages. To avoid incompatibility, it is important to install packages with the version mentioned below. 
for instance, if you install the recent release of the networkx package, the code will not work. The installed packages are:
backports.functools-lru-cache     1.5
cycler                            0.10.0
Cython                            0.28.2
decorator                         4.3.0
kiwisolver                        1.0.1
matplotlib                        2.2.2
networkx                          1.11
numpy                             1.14.3
pandas                            0.22.0
pip                               10.0.1
prettytable                       0.7.2
pyparsing                         2.2.0
python-dateutil                   2.7.3
pytz                              2018.4
scikit-learn                      0.19.1
scipy                             1.1.0
seaborn                           0.8.1
setuptools                        39.1.0
six                               1.11.0
subprocess32                      3.5.0
wheel                             0.31.0
hdbscan                           0.8.13
debacl                            1.1 

To install a package (for instance, BeautifulSoup package version 3.2.0), use the command:
python -m pip install BeautifulSoup==3.2.0

You should see the following lines on your screen.
Collecting BeautifulSoup==3.2.0
  Downloading https://files.pythonhosted.org/packages/33/fe/15326560884f20d792d3ffc7fe8f639aab88647c9d46509a240d9bfbb6b1/BeautifulSoup-3.2.0.tar.gz
Building wheels for collected packages: BeautifulSoup
  Running setup.py bdist_wheel for BeautifulSoup ... done
  Stored in directory: /Users/ghamaria/Library/Caches/pip/wheels/09/f5/19/ba8e673d27909fd79928eccfbe8c1fdee0683d3b553870f6d1
Successfully built BeautifulSoup
Installing collected packages: BeautifulSoup
Successfully installed BeautifulSoup-3.2.0

On how to install a specific version of a package, follow: This link (https://docs.python.org/2.7/installing/index.html).

-------
For PC (as stated above, it is NOT recommended to use Windows for your cluster analysis)
-------
(1) Install python: to run the code in MATLAB, we need to install python because some parts of the calculations are done in python.
Please install python 2.7.14 from this link "https://www.python.org/downloads/release/python-2714/"
(2) Click on the Windows Start button and type CMD. Then go to the python directory (i.e., C:\Python27) using cd command.
You should use the following commands to make sure that you installed the python package properly.
C:\Users\Iman>cd ..            
C:\Users>cd ..
C:\>cd Python27
C:\Python27>python
Python 2.7.14 (v2.7.14:84471935ed, Sep 16 2017, 20:25:58) [MSC v.1500 64 bit (AM
D64)] on win32
Type "help", "copyright", "credits" or "license" for more information.

(3) I got the list of installed python packages by executing the following commands in CMD.
import pip
installed_packages = pip.get_installed_distributions()
installed_packages_list = sorted(["%s==%s" % (i.key, i.version)
     for i in installed_packages])
print(installed_packages_list)

'backports.functools-lru-cache==1.5' 
'cycler==0.10.0'
'cython==0.27.3', 
'debacl==1.1', 
'decorator==4.2.1', 
'hdbscan==0.8.12', 
'matplotlib==2.1.2', 
'networkx==1.11', 
'numpy==1.14.1', 
'pandas==0.22.0', 
'pip==9.0.1'
'prettytable==0.7.2', 
'pyparsing==2.2.0', 
'python-dateutil==2.6.1', 
'pytz==2018.3', 
'scikit-learn==0.19.1', 
'scipy==1.0.0', 
'seaborn==0.8.1', 
'setuptools==38.5.1', 
'six==1.11.0', 
'wheel==0.30.0'

To avoid incompatibility, it is important to install packages with the version mentioned above. 
for instance, if you install the recent release of the networkx package, the code will not work.

You can install packages with their specific version by using the commands mentioned here "https://docs.python.org/2.7/installing/index.html"
For instance, we can simply install package "BeautifulSoup" version 3.2.0 by running the following command.
C:\Python27>python -m pip install BeautifulSoup==3.2.0
Collecting BeautifulSoup==3.2.0
  Downloading https://files.pythonhosted.org/packages/33/fe/15326560884f20d792d3
ffc7fe8f639aab88647c9d46509a240d9bfbb6b1/BeautifulSoup-3.2.0.tar.gz
Building wheels for collected packages: BeautifulSoup
  Running setup.py bdist_wheel for BeautifulSoup ... done
  Stored in directory: C:\Users\Iman\AppData\Local\pip\Cache\wheels\09\f5\19\ba8
e673d27909fd79928eccfbe8c1fdee0683d3b553870f6d1
Successfully built BeautifulSoup
Installing collected packages: BeautifulSoup
  Found existing installation: BeautifulSoup 3.2.1
    Uninstalling BeautifulSoup-3.2.1:
      Successfully uninstalled BeautifulSoup-3.2.1
Successfully installed BeautifulSoup-3.2.0

This link (https://docs.python.org/2.7/installing/index.html) can help you learn how to install a specific version of a package.

====================================
CLUSTER ANALYSIS and POST-PROCESSING codes:
====================================
The cluster analysis code is provided in the "Cluster Analysis" folder. 

For MAC, use the code inside the "For MAC" folder.
For PC, use the code inside the "For PC" folder.

Remember to use "/" for a path in MAC and "\" for a path in PC
							
hdbscanAnalysis.m and debaclAnalysis.m files must be updated before running the code:				
-------
In MAC:
-------							
- update the following line in hdbscanAnalysis.m file based on your installation path
    !/usr/local/bin/python2.7 hdbscanImanSecond.py
- update the following line in debaclAnalysis.m based on your installation path
    !/usr/local/bin/python2.7 debaclImanSecond.py	
-------
In PC:
-------							
- update the following line in hdbscanAnalysis.m file based on your installation path
	!C:\Python27\python.exe hdbscanImanSecond.py
- update the following line in debaclAnalysis.m based on your installation path
    !C:\Python27\python.exe debaclImanSecond.py	
	
To run the code, open "Main_ClusterAnalysis.m" file and update parameters before "%-----------------------------------------"

The post process codes are only useful for synthetic datasets.
To do post processing, open "PostProcess.m" file and update parameters before "%------------------------------------"

Place the following files in the "" folder before running PostProcess.m file (what is this "" folder?)
YOURFILE_GnrtdClstrCntrAndSize.txt
YOURFILE_DatasetForClusterAnalysis.txt
YOURFILE_CuAtomsInClusterandSolidSolution.txt

Finally, note that the hdbscanImanSecond.py file is also different between the MAC and PC versions.
In PC:
clusterer = hdbscan.HDBSCAN(min_cluster_size=MinClusterSize,min_samples=MinSamples,
          cluster_selection_method='eom',approx_min_span_tree=False,core_dist_n_jobs=1).fit(X)

In MAC:
clusterer = hdbscan.HDBSCAN(min_cluster_size=MinClusterSize,min_samples=MinSamples,
                            cluster_selection_method='eom',approx_min_span_tree=False).fit(X)
			    
====================================
To GENERATE a dataset:
====================================
(1) Open Main_DataSetGenerator.m in MATLAB and change the parameters before "%----------------------"
(2) Run the code 
(3) Open the GeneratedDatasetResults folder. The file used for cluster analysis is YOURFILE_DatasetForClusterAnalysis.txt. 

Some other files are also prepared to provide more information about the generated dataset.

YOURFILE_DatasetForClusterAnalysis.pos: You can open this file in the IVAS software. 

YOURFILE_GnrtdClstrCntrAndSize.txt: The first three columns of this file are X, Y and Z of the cluster centers. The last column is the size of each cluster.

YOURFILE_CuAtomsInClusterandSolidSolution.txt: The first three columns are X, Y and Z of each atom inside the dataset. The fourth column shows the element ID for each atom. We considered 63 for Cu atoms inside a cluster and 65 for Cu atoms in a matrix. The fifth column shows the the cluster ID. We assigned -1 to atoms inside the matrix.

YOURFILE_ParamtersUsedForDatasetGeneration.txt: You can find the paramters used for the cluster analysis here. 

YOURFILE_GnrtdClstrCntrAndSize.txt and YOURFILE_CuAtomsInClusterandSolidSolution.txt will be used in post processing of the cluster analysis results.
