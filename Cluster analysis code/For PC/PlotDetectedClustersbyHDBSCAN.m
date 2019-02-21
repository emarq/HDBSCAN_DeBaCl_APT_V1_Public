%This function plots clusters detected by HDBSCAN
function PlotDetectedClustersbyHDBSCAN(DatasetName,hdbscanCluster,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,AxisLimits)

    ColorsForPlot = distinguishable_colors(size(hdbscanCluster,2));
    
    AlldataPoints=importdata(DatasetName);
    Xsave=[];
    SizeVsPersistencySave=[];
    f1=figure(10);
    ClusterCounter=0;
    for i=1:size(hdbscanCluster,2)
        if hdbscanCluster(i).persistence>=hdbscanPersistencyThreshold
            ClusterCounter=ClusterCounter+1;
            Xtemp=hdbscanCluster(i).atomPositions;
            Probability=hdbscanCluster(i).probabilities;
            [row col]=find(Probability(:,1)>=hdbscanProbabilityThreshold);
            if size(Xtemp,2)==2   %2D dataset
                X=Xtemp(row,1:2);
                Xsave=[Xsave;X];
                SizeVsPersistencySave=[SizeVsPersistencySave;size(X,1) hdbscanCluster(i).persistence i];%i is for colorID to be the same between two plots
                plot(X(:,1),X(:,2),'.','color',ColorsForPlot(i,1:3),'MarkerSize',8)
            else                  %3D dataset
                X=Xtemp(row,1:3);
                Xsave=[Xsave;X];
                SizeVsPersistencySave=[SizeVsPersistencySave;size(X,1) hdbscanCluster(i).persistence i];%i is for colorID to be the same between two plots
                SelProbTemp=Probability(row,1);
                SelectedColor=ColorsForPlot(i,1:3);
                TransparencyOutput=Transparency(X,SelProbTemp,SelectedColor);
                hold on
                 arrayfun(@(a) plot3(a.X,a.Y,a.Z,'.','color',a.Col,'MarkerSize',8),TransparencyOutput, 'uni', 0);
            end
            hold on
        end
    end

    if size(Xsave,1)==0
        error('IMAN: HDBSCAN did not detect any cluster. Please change the values of MinClusterSizeHDBSCAN and MinSamplesHDBSCAN parameters.');
    end
        
    AlldataPoints(ismember(AlldataPoints,Xsave,'rows'),:)=[]; %Noise points
    if size(AlldataPoints,2)==2
        plot(AlldataPoints(:,1),AlldataPoints(:,2),'.','color','k','MarkerSize',2)
    else
        plot3(AlldataPoints(:,1),AlldataPoints(:,2),AlldataPoints(:,3),'.','color','k','MarkerSize',2)
    end
    TITLE=({['Number of detected clusters by HDBSCAN is ' num2str(ClusterCounter)];...
        ['Persistency>= ' num2str(hdbscanPersistencyThreshold) '  Probability>= ' num2str(hdbscanProbabilityThreshold)]});
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
    saveas(f1,'2_DetectedClustersByHDBSCAN.tiff')
    saveas(f1,'2_DetectedClustersByHDBSCAN.fig')
    %close(f1)
    
    f2=figure(11);
    for i=1:size(SizeVsPersistencySave,1)
        plot(SizeVsPersistencySave(i,1),SizeVsPersistencySave(i,2),'.','color',ColorsForPlot(SizeVsPersistencySave(i,3),1:3),'MarkerSize',14)
        hold on
    end
    hold off
    ylim([0 1])
    xlabel('Number of atoms in each cluster')
    ylabel('Persistency')
    title('Detected clusters by HDBSCAN')
    saveas(f2,'2_HDBSCAN_PersistencyVsSize.tiff')
    %close(f2)
    
    f3=figure(12);
    boxplot(SizeVsPersistencySave(:,1),'Labels',{'All detected clusters'})
    ylabel('Number of atoms in each cluster')
    title('Distribution of HDBSCAN detected clusters w.r.t. cluster size')
    saveas(f3,'2_HDBSCAN_ClusterSizeDistributions.tiff')
    %close(f3)
    
    f4=figure(13);
    boxplot(SizeVsPersistencySave(:,2),'Labels',{'All detected clusters'})  
    ylabel('Persistency of each cluster')
    title('Distribution of HDBSCAN detected clusters w.r.t. persistency')
    saveas(f4,'2_HDBSCAN_ClusterPersistencyDistributions.tiff')
   % close(f4)
   
end