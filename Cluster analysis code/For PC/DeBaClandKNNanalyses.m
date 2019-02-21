%Calling functions required for DeBaCl and KNN analysis
function DeBaClandKNNanalyses(hdbscanCluster,hdbscanPersistencyThreshold,MassLengthDeBaClThreshold,pDeBaCl,kDeBaCl,gammaDeBaCl,...
                        hdbscanProbabilityThreshold,DatasetName,AxisLimits,...  
                        NNNforKNN,PrefactorDeBaClDensityThreshold,...
                        IgnorePersisInDeBaClanalysis,IgnorehdbscanProbabilityThresholdAfterKNNrelabeling)
                                    
if IgnorePersisInDeBaClanalysis
    NumberOfLoops=2;
else
    NumberOfLoops=1;
end

for i=1:NumberOfLoops
    if i==1
        IgnorePersistency=false;
    else
        IgnorePersistency=true;
    end
    TotoalNumberOfClusters=debaclAnalysis(hdbscanCluster,hdbscanPersistencyThreshold,MassLengthDeBaClThreshold,pDeBaCl,kDeBaCl,gammaDeBaCl,IgnorePersistency);
    PlotttingDeBaClResults(TotoalNumberOfClusters,hdbscanCluster,MassLengthDeBaClThreshold,hdbscanProbabilityThreshold,DatasetName,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold)
    KNNanalysis(TotoalNumberOfClusters,hdbscanCluster,NNNforKNN,hdbscanProbabilityThreshold,PrefactorDeBaClDensityThreshold,DatasetName,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold,IgnorehdbscanProbabilityThresholdAfterKNNrelabeling)

end        
                    
                    
               
end