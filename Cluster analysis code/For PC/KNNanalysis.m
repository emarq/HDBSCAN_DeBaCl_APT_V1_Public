%functions related to KNN analysis are called here.
function KNNanalysis(TotoalNumberOfClusters,hdbscanCluster,NNNforKNN,hdbscanProbabilityThreshold,PrefactorDeBaClDensityThreshold,DatasetName,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold,IgnorehdbscanProbabilityThresholdAfterKNNrelabeling)
    if IgnorePersistency
        hdbscanPersistencyThreshold=0;
        AllDeBaClResultsFolderPath='AllDeBaClResultsWithOUTPersistancy';
        FigNumber=100;
    else
        AllDeBaClResultsFolderPath='AllDeBaClResultsWithPersistancy';
        FigNumber=0;
    end
    P1=figure(40+FigNumber);
    ColorsForPlot = distinguishable_colors(TotoalNumberOfClusters);
    ColorCounter=0;
    ClusterCounter=0;
    ClusterSizeSaver=[];
    DetectedPositionsSaver=[];
    DetectedPositionCenterSaver=[];
    for i=1:size(hdbscanCluster,2)
        newName = sprintf('%s_%d', 'hdbscanCluster',i);
        FolderAddress=fullfile(AllDeBaClResultsFolderPath, newName);
        if exist(FolderAddress,'dir')==7
            tempLabelsAddress=[FolderAddress '\DeBaCl_labels.txt'];
            tempLabels12=importdata(tempLabelsAddress); 
            tempLabels=tempLabels12(:,2);

            tempProbabilityAddress=[FolderAddress '\HDBSCANdClusterForDeBaCl_probabilities.txt'];
            tempProbabilities=importdata(tempProbabilityAddress);

            tempPositionsAddress=[FolderAddress '\HDBSCANdClusterForDeBaCl_position.txt'];
            tempPositions=importdata(tempPositionsAddress);
            
            tempDensityAddress=[FolderAddress '\DeBaCl_density.txt'];
            tempDensity=importdata(tempDensityAddress);

            if ismember(-1,unique(tempLabels)) %KNN is applied to assign a cluster label for points considered Noise by DeBaCl
                Data=RelabelByKNN(tempLabels,tempProbabilities,tempPositions,tempDensity,NNNforKNN,PrefactorDeBaClDensityThreshold);
            else
                Data=[tempLabels tempProbabilities tempPositions];
            end
if ~IgnorehdbscanProbabilityThresholdAfterKNNrelabeling
            Data(any(Data(:,2)<hdbscanProbabilityThreshold,2),:)=[];
end
            FinalUniqueLabels=unique(Data(:,1));
            for j=1:size(FinalUniqueLabels,1)
                [row, col]=find(Data(:,1)==FinalUniqueLabels(j,1));
                tempPlot=Data(row,:);
                ColorCounter=ColorCounter+1;
                ClusterCounter=ClusterCounter+1;
                ClusterSizeSaver=[ClusterSizeSaver;size(tempPlot,1)];
                if size(tempPlot,2)==4 %2D dataset
                    plot(tempPlot(:,3),tempPlot(:,4),'.','color',ColorsForPlot(ColorCounter,1:3),'MarkerSize',8)
                    DetectedPositionsSaver=[DetectedPositionsSaver;tempPlot(:,3) tempPlot(:,4)];
                    DetectedPositionCenterSaver=[DetectedPositionCenterSaver;mean(tempPlot(:,3)) mean(tempPlot(:,4))];
                else
                    plot3(tempPlot(:,3),tempPlot(:,4),tempPlot(:,5),'.','color',ColorsForPlot(ColorCounter,1:3),'MarkerSize',8)
                    DetectedPositionsSaver=[DetectedPositionsSaver;tempPlot(:,3) tempPlot(:,4) tempPlot(:,5)];
                    DetectedPositionCenterSaver=[DetectedPositionCenterSaver;mean(tempPlot(:,3)) mean(tempPlot(:,4)) mean(tempPlot(:,5))];
                end
                hold on
            end
        end
    end

    TITLE=({['Number of detected clusters by DeBaCl is ' num2str(ClusterCounter)];...
        ['NNNforKNN= ' num2str(NNNforKNN) '  Probability>=' num2str(hdbscanProbabilityThreshold) '  Prefactor of DeBaCl density threshold=' num2str(PrefactorDeBaClDensityThreshold)];...
        ['Persistancy threshold= ' num2str(hdbscanPersistencyThreshold)]});
    title(TITLE)
    xlim([AxisLimits(1,1) AxisLimits(1,2)])
    ylim([AxisLimits(2,1) AxisLimits(2,2)])
    zlim([AxisLimits(3,1) AxisLimits(3,2)])
    xlabel('X (nm)')
    ylabel('Y (nm)')
    zlabel('Z (nm)')
    hold off
    set(gcf,'Units','Normalized','OuterPosition',[0.25, 0.07, .65, .92])
    if IgnorePersistency
        saveas(P1,'4_KNNcorrectedDetectedClustersByDeBaCl_NOTconsideringPersistancy.tiff')
        saveas(P1,'4_KNNcorrectedDetectedClustersByDeBaCl_NOTconsideringPersistancy.fig')
    else
        saveas(P1,'4_KNNcorrectedDetectedClustersByDeBaCl_ConsideringPersistancy.tiff')
        saveas(P1,'4_KNNcorrectedDetectedClustersByDeBaCl_ConsideringPersistancy.fig')
    end
   % close(P1);
    
    if IgnorePersistency
        fid10 = fopen('40_KNN_ClusterCentersAndSize_NOTconsideringPersistancy.txt','wt');
    else
        fid10 = fopen('40_KNN_ClusterCentersAndSize_ConsideringPersistancy.txt','wt');
    end
    
    for i=1:size(DetectedPositionCenterSaver,1)
        PRINT=[DetectedPositionCenterSaver(i,1),DetectedPositionCenterSaver(i,2),DetectedPositionCenterSaver(i,3), ClusterSizeSaver(i,1)];
        fprintf(fid10, '%10.5f\t %10.5f\t %10.5f\t %6i\n', PRINT);
    end
    fclose(fid10);
    
    P2=figure(41+FigNumber);
    boxplot(ClusterSizeSaver(:,1),'Labels',{'All detected clusters by DeBaCl'})
    ylabel('Number of atoms in each cluster')
    if IgnorePersistency
        TITLE=[{'KNN-corrected distribution of detected clusters w.r.t. cluster size';'(NOT Considering Persistancy)'}];
        title(TITLE)
        saveas(P2,'4_KNNCorrected_DeBaCl_ClusterSizeDistributions_NOTconsideringPersistancy.tiff')
    else
        TITLE=[{'KNN-corrected distribution of detected clusters w.r.t. cluster size';'(Considering Persistancy)'}];
        title(TITLE)
        saveas(P2,'4_KNNCorrected_DeBaCl_ClusterSizeDistributions_ConsideringPersistancy.tiff')
    end
    close(P2)
   
    Original=importdata(DatasetName);
    Rows=not(ismember(Original,DetectedPositionsSaver,'rows'));
    ConsideredAsNoise=Original(Rows,:);
    
    PlottingKNNClusterCentersInNoise(ConsideredAsNoise,DetectedPositionCenterSaver,ColorsForPlot,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold)
    
   
end