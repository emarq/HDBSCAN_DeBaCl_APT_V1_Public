%Presenting DeBaCl results
function PlotttingDeBaClResults(TotoalNumberOfClusters,hdbscanCluster,MassLengthDeBaClThreshold,hdbscanProbabilityThreshold,DatasetName,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold)
    if IgnorePersistency
        hdbscanPersistencyThreshold=0;
        AllDeBaClResultsFolderPath='AllDeBaClResultsWithOUTPersistancy';
        FigNumber=100;
    else
        AllDeBaClResultsFolderPath='AllDeBaClResultsWithPersistancy';
        FigNumber=0;
    end
    K1=figure(30+FigNumber);
    ColorsForPlot = distinguishable_colors(TotoalNumberOfClusters);
    ColorCounter=0;
    ClusterCounter=0;
    ClusterSizeSaver=[];
    DetectedPositionsSaver=[];
    DetectedPositionCenterSaver=[];
    for i=1:size(hdbscanCluster,2)
        newName = sprintf('%s_%d', 'hdbscanCluster',i);
        FolderAddress=fullfile(AllDeBaClResultsFolderPath, newName);
        disp('Folder addressIman:')
        disp(FolderAddress)
        if exist(FolderAddress,'dir')==7
            LabelFileAddress=[FolderAddress '\DeBaCl_labels.txt']; 
            Temp=importdata(LabelFileAddress);
            Labels=Temp(:,2);
            Positions=hdbscanCluster(i).atomPositions;
            hdbProbFileAddress=[FolderAddress '\HDBSCANdClusterForDeBaCl_probabilities.txt'];
            hdbProb=importdata(hdbProbFileAddress);
            DeBaClDensityFileAddress=[FolderAddress '\DeBaCl_density.txt'];
            DeBaClDensity=importdata(DeBaClDensityFileAddress);
            NormalizedDBCdensity=(((DeBaClDensity - min(DeBaClDensity))/(max(DeBaClDensity) - min(DeBaClDensity)))./(4/3))+0.25;%Normalized between 0.25 and 1
            LabelshdbProbPositionsNormalizedDensity=[Labels hdbProb Positions NormalizedDBCdensity];
            LabelshdbProbPositionsNormalizedDensity(any(LabelshdbProbPositionsNormalizedDensity(:,1)==-1,2),:)=[];
            LabelshdbProbPositionsNormalizedDensity(any(LabelshdbProbPositionsNormalizedDensity(:,2)<hdbscanProbabilityThreshold,2),:)=[];
            Unique=unique(LabelshdbProbPositionsNormalizedDensity(:,1));
            for j=1:size(Unique,1)
                [row col]=find(LabelshdbProbPositionsNormalizedDensity(:,1)==Unique(j,1));
                tempPlot=LabelshdbProbPositionsNormalizedDensity(row,:);
                ColorCounter=ColorCounter+1;
                ClusterCounter=ClusterCounter+1;
                ClusterSizeSaver=[ClusterSizeSaver;size(tempPlot,1)];
                if size(Positions,2)==2
                    plot(tempPlot(:,3),tempPlot(:,4),'.','color',ColorsForPlot(ColorCounter,1:3),'MarkerSize',8)
                    DetectedPositionsSaver=[DetectedPositionsSaver;tempPlot(:,3) tempPlot(:,4)];
                    DetectedPositionCenterSaver=[DetectedPositionCenterSaver;mean(tempPlot(:,3)) mean(tempPlot(:,4))];
                else
                    XtempForThisPlot=[tempPlot(:,3),tempPlot(:,4),tempPlot(:,5)];
                    SelDensityTemp=tempPlot(:,6);
                    SelectedColor=ColorsForPlot(ColorCounter,1:3);
                    TransparencyOutput=Transparency(XtempForThisPlot,SelDensityTemp,SelectedColor);
                    hold on
                    arrayfun(@(a) plot3(a.X,a.Y,a.Z,'.','color',a.Col,'MarkerSize',8),TransparencyOutput, 'uni', 0);
                    DetectedPositionsSaver=[DetectedPositionsSaver;tempPlot(:,3) tempPlot(:,4) tempPlot(:,5)];
                    DetectedPositionCenterSaver=[DetectedPositionCenterSaver;mean(tempPlot(:,3)) mean(tempPlot(:,4)) mean(tempPlot(:,5))];
                end
                hold on
            end
         end
    end
    
    if (TotoalNumberOfClusters-ClusterCounter)>0
        WarningMsgMissClustersDueHDBSCANProb(TotoalNumberOfClusters,ClusterCounter)
    end
    
    TITLE=({['Number of detected clusters by DeBaCl is ' num2str(ClusterCounter)];...
        ['\deltaMass >= ' num2str(MassLengthDeBaClThreshold) '  Probability>=' num2str(hdbscanProbabilityThreshold) '  Persistency>=' num2str(hdbscanPersistencyThreshold)];...
        ['Transparency represents normalized DeBaCl-calculated density between 0.25 and 1']});
    title(TITLE)
    xlim([AxisLimits(1,1) AxisLimits(1,2)])
    ylim([AxisLimits(2,1) AxisLimits(2,2)])
    zlim([AxisLimits(3,1) AxisLimits(3,2)])
    xlabel('X (nm)')
    ylabel('Y (nm)')
    zlabel('Z (nm)')
    hold off
    view(-38, 30);
    set(gcf,'Units','Normalized','OuterPosition',[0.25, 0.07, .65, .92])
    if IgnorePersistency
        saveas(K1,'3_DetectedClustersByDeBaCl_NOTconsideringPersistency.tiff')
       % saveas(K1,'3_DetectedClustersByDeBaCl_NOTconsideringPersistency.fig')
    else
        saveas(K1,'3_DetectedClustersByDeBaCl_ConsideringPersistency.tiff')
      %  saveas(K1,'3_DetectedClustersByDeBaCl_ConsideringPersistency.fig')
    end
   % close(K1)
    
    if IgnorePersistency
        fid10 = fopen('30_DeBaCl_ClusterCentersAndSize_NOTconsideringPersistancy.txt','wt');
    else
        fid10 = fopen('30_DeBaCl_ClusterCentersAndSize_ConsideringPersistancy.txt','wt');
    end
    
    for i=1:size(DetectedPositionCenterSaver,1)
        PRINT=[DetectedPositionCenterSaver(i,1),DetectedPositionCenterSaver(i,2),DetectedPositionCenterSaver(i,3), ClusterSizeSaver(i,1)];
        fprintf(fid10, '%10.5f\t %10.5f\t %10.5f\t %6i\n', PRINT);
    end
    fclose(fid10);
    
    
    K2=figure(31+FigNumber);
    boxplot(ClusterSizeSaver(:,1),'Labels',{'All detected clusters by DeBaCl'})
    ylabel('Number of atoms in each cluster')
    if IgnorePersistency
        TITLE=[{'Distribution of detected clusters w.r.t. cluster size';'(NOT considering persistancy)'}];
        title(TITLE)
        saveas(K2,'3_DeBaCl_ClusterSizeDistributions_NOTconsideringPersistancy.tiff')
    else
        TITLE=[{'Distribution of detected clusters w.r.t. cluster size';'(Considering persistancy)'}];
        title(TITLE)
        saveas(K2,'3_DeBaCl_ClusterSizeDistributions_ConsideringPersistancy.tiff')        
    end
    %close(K2)
    
    Original=importdata(DatasetName);
    Rows=not(ismember(Original,DetectedPositionsSaver,'rows'));
    ConsideredAsNoise=Original(Rows,:);
        
    PlottingDeBaClClusterCentersInNoise(ConsideredAsNoise,DetectedPositionCenterSaver,ColorsForPlot,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold)
    PlottingDeBaClClusterCentersInAllatoms(Original,DetectedPositionCenterSaver,ColorsForPlot,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold)
    
end