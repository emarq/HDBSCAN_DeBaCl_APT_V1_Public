%Plotting cluster centers and their sizes
function DistGnrtdWOthers=PP1_PlotClusterCenterSize(DatasetName,VideoFrameRate,VideoDuration,CaptureVideo,iHaveNonPersisResults)
TempName=['FinalResults/' DatasetName '_DatasetForClusterAnalysis.txt'];
X=importdata(TempName);
AxisLimits=[min(X(:,1)) max(X(:,1));...
            min(X(:,2)) max(X(:,2));...
            min(X(:,3)) max(X(:,3))];

 if iHaveNonPersisResults
     [gnrtdClusCenters,hdbAllClusCenters,hdbSelClusCenters,DaBaClClusCntrNoPersis,KNNClusCntrNoPersis,DaBaClClusCntrWithPersis,KNNClusCntrWithPersis]=PP1_02function_AllPersis(AxisLimits,DatasetName);
 else
     [DistGnrtdWOthers,gnrtdClusCenters,hdbAllClusCenters,hdbSelClusCenters,DaBaClClusCntrWithPersis,KNNClusCntrWithPersis]=PP1_01function_OnlyPersis(AxisLimits,DatasetName);
 end
     

if iHaveNonPersisResults
    PP1_1stFunction_DeBaClNoPersistancy(gnrtdClusCenters,hdbAllClusCenters,hdbSelClusCenters,DaBaClClusCntrNoPersis,AxisLimits,VideoFrameRate,VideoDuration,KNNClusCntrNoPersis,CaptureVideo)
end
PP1_2ndFunction_DeBaClNoPersistancy(gnrtdClusCenters,hdbAllClusCenters,hdbSelClusCenters,DaBaClClusCntrWithPersis,AxisLimits,VideoFrameRate,VideoDuration,KNNClusCntrWithPersis,CaptureVideo)




end
