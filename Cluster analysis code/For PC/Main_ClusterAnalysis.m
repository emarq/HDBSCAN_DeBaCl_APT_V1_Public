clear all
clc
close all

%0) If the dataset is generated, it maybe good if we remove too small
%clusters because fluctuation in noise may result in formation of clusters.

%1)Write the name of the dataset that you want to study below
%If it is a synthetic dataset, please only change ExampleOne part.
DatasetName='ExampleOne_DatasetForClusterAnalysis.txt';

%2) Parameters used by hdbscanImanSecond.py are
MinClusterSizeHDBSCAN=25; %minimum number of atoms in a detected cluster
MinSamplesHDBSCAN=13;     %This parameter has a significant effect on clustering.
    %It provides a measure of how conservative you want your clustering to be.
    %The larger the value you provide, the more conservative the clustering and
    %more points will be declared as noise and clusters will be 
    %restricted to progressively more dense areas. 
    
hdbscanAnalysisTwoTimes=false; %This a logical variable which can be either true or false.
    %Sometimes, after filtering the original dataset with hdbscan, it may be good to remove the detetced points (as clusters)
    %from the dataset and repeat the hdbscanAnalysis again.
PrefactForPersistancy= 2;        %should be value larger than 1 and less than 3 to 5.
    %This prefactor is like a safety factor, that we can apply to hdbscan
    %analysis, when we are calling it for the second time

%3)Update the following variables (they are used in "hdbscanAnalysis" function) 
hdbscanPersistencyThreshold=0.03;%0.03%Generally, the persistancy rate should be set to small values becuase
                  %it may be more than one cluster in HDBSCAN detected cluster which may result in
                  % smaller persistancy rate
hdbscanProbabilityThreshold=0.50;%0.55

%4) Three parametrs used by debaclImanSecond.py are p, k and gamma.
%pDeBaCl=3; No need anymore. It is done in %p: The dimension of the dataset. (i.e., 2D or 3D) 
kDeBaCl=8; %k: Number of observations to consider as neighbor to a given point 
gammaDeBaCl=21;%30%gamma: Leaf nodes with fewer than this number (i.e., prune_threshold or 
    % gamma)of members are recursively merged into larger nodes. 
    % If prune_threshold is set to 'None' (the default) in debaclImanSecond.py, 
    % then no pruning is performed. We cannot do this action here, because
    % here we assumed that gammaDeBaCl is an integer value. 
    %Based on Try and Error, I noticed that gammaDeBaCl can be set based on
    %the minimum cluster size detetced by HDBSCAN. The value must be
    %smaller than the minium HBSCAN-detected cluster size, otherwise the
    %could crashes in "ReadDeBaCltreeOutput" function. Based on my
    %experience, 75-90% of MinClusterSizeHDBSCAN should be a good value
%5)    
IgnorePersisInDeBaClanalysis=false; %True: In the first run for DeBaCl and KNN it consider the persistency threshold and
                                    %in the second run it does not consider.
                                    %False: There is only one run of DeBaCl
                                    % and KNN and persistency threshold is
                                    % considered.
                                    
%6) "MassLengthDeBaClThreshold" variable is used in "DeBaClPostProcess"
%function to merge leaves which cannot survive for an acceptable level of 
%mass changes (i.e., EndMass-StartMass>MassLengthDeBaClThreshold) 
MassLengthDeBaClThreshold=0.25;%0.25

%7) Number of NN for KNN analysis. It must be an odd number. 
NNNforKNN=9;

%8)In order not to assign all the atoms detected in HDBSCAN to a cluster by KNN
%atoms which are considered as noise by DeBaCl and have DeBaCl calculated Density
%less than a fraction of the minimum DeBaCl density of a cluster are filtered.
%This action is done by DeBaClDensityThreshold=MinClusterDensity(1,1)*PrefactorDeBaClDensityThreshold;
%in "RemovePointsBasedonDeBeClDensity" function.
%This value must be between 0 and 1.
PrefactorDeBaClDensityThreshold=0.5;

IgnorehdbscanProbabilityThresholdAfterKNNrelabeling=false;%it maybe good to change it to a prefactor

%-----------------------------------------
[AxisLimits,pDeBaCl]=BeforeStartingAnalyses(DatasetName,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,hdbscanPersistencyThreshold,...
                       hdbscanProbabilityThreshold,kDeBaCl,gammaDeBaCl,MassLengthDeBaClThreshold,...
                       NNNforKNN,PrefactorDeBaClDensityThreshold,hdbscanAnalysisTwoTimes,PrefactForPersistancy,IgnorePersisInDeBaClanalysis,...
                       IgnorehdbscanProbabilityThresholdAfterKNNrelabeling);
                   
[hdbscanCluster FirstScanOutput SecondScanOutput]=HDBSCAN(DatasetName,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,AxisLimits,hdbscanAnalysisTwoTimes,PrefactForPersistancy);                   

DeBaClandKNNanalyses(hdbscanCluster,hdbscanPersistencyThreshold,MassLengthDeBaClThreshold,pDeBaCl,kDeBaCl,gammaDeBaCl,...
                        hdbscanProbabilityThreshold,DatasetName,AxisLimits,...  
                        NNNforKNN,PrefactorDeBaClDensityThreshold,...
                        IgnorePersisInDeBaClanalysis,IgnorehdbscanProbabilityThresholdAfterKNNrelabeling);

FinalMainFolderCleanUp(DatasetName)
                       