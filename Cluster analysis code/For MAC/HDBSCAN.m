%Calling the functions required for HDBSCAN analysis
function [hdbscanCluster FirstScanOutput SecondScanOutput]=HDBSCAN(DatasetName,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,AxisLimits,hdbscanAnalysisTwoTimes,PrefactForPersistancy)                   

if hdbscanAnalysisTwoTimes
    FirstScanOutput=hdbscanAnalysis(DatasetName,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,AxisLimits);
    NewDatasetName=MakeFilteredDataset(DatasetName,FirstScanOutput);%This function removes all the detetced points regardless of the persistancy value
    NEWhdbscanPersistencyThreshold=PrefactForPersistancy*hdbscanPersistencyThreshold;
    SecondScanOutput=hdbscanAnalysis(NewDatasetName,NEWhdbscanPersistencyThreshold,hdbscanProbabilityThreshold,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,AxisLimits);
    %To avoid wrong results in SecondScanOutput, I may need to filter it
    %based on persistancy rate
    hdbscanCluster=FirstScanOutput;
    AcceptedSecondScan=[];
    if size(SecondScanOutput,2)>0
        LabelCounter=size(FirstScanOutput,2);
        for i=1:size(SecondScanOutput,2)
            if SecondScanOutput(i).persistence>NEWhdbscanPersistencyThreshold
                hdbscanCluster(LabelCounter+1).labels=LabelCounter;
                hdbscanCluster(LabelCounter+1).probabilities=SecondScanOutput(i).probabilities;
                hdbscanCluster(LabelCounter+1).persistence=SecondScanOutput(i).persistence;
                hdbscanCluster(LabelCounter+1).atomPositions=SecondScanOutput(i).atomPositions;
                TempPosi=SecondScanOutput(i).atomPositions;
                AcceptedSecondScan=[AcceptedSecondScan;SecondScanOutput(i).persistence size(TempPosi,1)];
                LabelCounter=LabelCounter+1;
            end
        end
        if size(AcceptedSecondScan,1)>0
            LLL1=figure(14);
            subplot(1,2,1)
            boxplot(AcceptedSecondScan(:,1))
            ylabel('Persistancy for the second HDBSCAN scan')
        
            subplot(1,2,2)
            boxplot(AcceptedSecondScan(:,2))
            ylabel('Cluster size for the second HDBSCAN scan')
            TITLE=['Number of Detected clusters in the second HDBSCAN is ' num2str(size(AcceptedSecondScan,1))];
            suptitle(TITLE)
            saveas(LLL1,'2_DetectedClustersBySecondHDBSCAN.tiff')
            %close(LLL1)
        end
    end
    
else
    hdbscanCluster=hdbscanAnalysis(DatasetName,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,AxisLimits);
    FirstScanOutput=[]; 
    SecondScanOutput=[];
end

    PlotDetectedClustersbyHDBSCAN(DatasetName,hdbscanCluster,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,AxisLimits)
    WriteHDBSCANclusterCenters(hdbscanCluster,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold)

end