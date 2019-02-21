%Highlight a specific cluster center among all the detected clusters.
function PP2_HighlightOneGNRTDcluster(gnrtdClusterID,DatasetName,iHaveNonPersisResults)

TempName=['FinalResults/' DatasetName '_DatasetForClusterAnalysis.txt'];
X=importdata(TempName);
AxisLimits=[min(X(:,1)) max(X(:,1));...
            min(X(:,2)) max(X(:,2));...
            min(X(:,3)) max(X(:,3))];

if iHaveNonPersisResults
    PP2_1stFunction_DeBaClNoPersistency(gnrtdClusterID,AxisLimits,DatasetName)
end
PP2_2ndFunction_DeBaClNoPersistency(gnrtdClusterID,AxisLimits,DatasetName)
end