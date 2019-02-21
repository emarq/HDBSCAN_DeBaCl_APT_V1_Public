%Three plots are made
%plot 500: disntance between gnrtd clusters with 1)itself, 2)nearest All
%HDBSCAN 3) Selected HDBSCAN 4)DeBaCl 
%plot 501)CLuster size
%plot502) Distribution in space
function [gnrtdClusCenters,hdbAllClusCenters,hdbSelClusCenters,DaBaClClusCntrNoPersis,KNNClusCntrNoPersis,DaBaClClusCntrWithPersis,KNNClusCntrWithPersis]=PP1_02function_AllPersis(AxisLimits,DatasetName)
hdbAllClusCenters=importdata('FinalResults\11_HDBSCAN_ClusterCentersNOTconsideringPersistancyThreshold.txt');
hdbSelClusCenters=importdata('FinalResults\11_HDBSCAN_ClusterCentersconsideringPersistancyThreshold.txt');
DaBaClClusCntrNoPersis=importdata('FinalResults\30_DeBaCl_ClusterCentersAndSize_NOTconsideringPersistancy.txt');
DaBaClClusCntrWithPersis=importdata('FinalResults\30_DeBaCl_ClusterCentersAndSize_ConsideringPersistancy.txt');
tempFileName=['FinalResults\' DatasetName '_GnrtdClstrCntrAndSize.txt'];
gnrtdClusCenters=importdata(tempFileName);

PP0Figh=figure(500);
NamesForPLot = categorical({'Generated','HDBSCAN_-All','HDBSCAN_-Selected','DeBaCl_-NoPersis','DeBaCl_-WithPersis'});
NamesForPLot =reordercats(NamesForPLot,{'Generated','HDBSCAN_-All','HDBSCAN_-Selected','DeBaCl_-NoPersis','DeBaCl_-WithPersis'});
ClusterSizeFOrPlot = [size(gnrtdClusCenters(:,1),1),size(hdbAllClusCenters(:,1),1),size(hdbSelClusCenters(:,1),1),size(DaBaClClusCntrNoPersis(:,1),1),size(DaBaClClusCntrWithPersis(:,1),1)];
bar(NamesForPLot,ClusterSizeFOrPlot)
text(1:length(ClusterSizeFOrPlot),ClusterSizeFOrPlot,num2str(ClusterSizeFOrPlot'),'vert','bottom','horiz','center'); 
box off
ylabel('Number of clusters')
saveas(PP0Figh,'PP_1_NumberOfDetectedClusters.tiff')
%close(PP0Figh)

Save=[];
for i=1:size(gnrtdClusCenters,1)
    TempSave=[];
    for j=1:size(gnrtdClusCenters,1)
        if j~=i
            temper=sqrt(((gnrtdClusCenters(i,1)-gnrtdClusCenters(j,1)).^2)+...
                        ((gnrtdClusCenters(i,2)-gnrtdClusCenters(j,2)).^2)+...
                        ((gnrtdClusCenters(i,3)-gnrtdClusCenters(j,3)).^2));
            TempSave=[TempSave;temper];
        end
    end
    distgnrtd=min(TempSave); 
    
    distHDB=min(sqrt(((gnrtdClusCenters(i,1)-hdbAllClusCenters(:,6)).^2)+...
                ((gnrtdClusCenters(i,2)-hdbAllClusCenters(:,7)).^2)+...
                ((gnrtdClusCenters(i,3)-hdbAllClusCenters(:,8)).^2)));
            
    distHDBsel=min(sqrt(((gnrtdClusCenters(i,1)-hdbSelClusCenters(:,6)).^2)+...
                ((gnrtdClusCenters(i,2)-hdbSelClusCenters(:,7)).^2)+...
                ((gnrtdClusCenters(i,3)-hdbSelClusCenters(:,8)).^2)));
            
  
    distDBC=min(sqrt(((gnrtdClusCenters(i,1)-DaBaClClusCntrNoPersis(:,1)).^2)+...
                ((gnrtdClusCenters(i,2)-DaBaClClusCntrNoPersis(:,2)).^2)+...
                ((gnrtdClusCenters(i,3)-DaBaClClusCntrNoPersis(:,3)).^2)));
            
    distDBCwPersis=min(sqrt(((gnrtdClusCenters(i,1)-DaBaClClusCntrWithPersis(:,1)).^2)+...
                ((gnrtdClusCenters(i,2)-DaBaClClusCntrWithPersis(:,2)).^2)+...
                ((gnrtdClusCenters(i,3)-DaBaClClusCntrWithPersis(:,3)).^2)));
            
    Save=[Save;distgnrtd distHDB(1,1) distHDBsel(1,1) distDBC(1,1) distDBCwPersis(1,1)];
end
gnrtedClusID=(1:size(gnrtdClusCenters,1))';
DistGnrtdWOthers=[Save gnrtedClusID]; 

dbcWdbc(1:size(DaBaClClusCntrNoPersis,1),1)=0;
for i=1:size(DaBaClClusCntrNoPersis,1)
    dist=[];
    for j=1:size(DaBaClClusCntrNoPersis,1)
        if j~=i
            temp=sqrt(((DaBaClClusCntrNoPersis(i,1)-DaBaClClusCntrNoPersis(j,1)).^2)+...
                ((DaBaClClusCntrNoPersis(i,2)-DaBaClClusCntrNoPersis(j,2)).^2)+...
                ((DaBaClClusCntrNoPersis(i,3)-DaBaClClusCntrNoPersis(j,3)).^2));
            dist=[dist;temp];
        end
    end
    dbcWdbc(i,1)=min(dist);
end

dbcWdbcWithPersis(1:size(DaBaClClusCntrWithPersis,1),1)=0;
for i=1:size(DaBaClClusCntrWithPersis,1)
    dist=[];
    for j=1:size(DaBaClClusCntrWithPersis,1)
        if j~=i
            temp=sqrt(((DaBaClClusCntrWithPersis(i,1)-DaBaClClusCntrWithPersis(j,1)).^2)+...
                ((DaBaClClusCntrWithPersis(i,2)-DaBaClClusCntrWithPersis(j,2)).^2)+...
                ((DaBaClClusCntrWithPersis(i,3)-DaBaClClusCntrWithPersis(j,3)).^2));
            dist=[dist;temp];
        end
    end
    dbcWdbcWithPersis(i,1)=min(dist);
end

PP1Figh=figure(501);
group = [ ones(size(Save(:,1)));...
         2 * ones(size(Save(:,2)));...
         3 * ones(size(Save(:,3)));...
         4 * ones(size(Save(:,4)));...
         5 * ones(size(dbcWdbc(:,1)));...
         6*ones(size(Save(:,5)));...
         7*ones(size(dbcWdbcWithPersis(:,1)))];
boxplot([Save(:,1); Save(:,2); Save(:,3); Save(:,4); dbcWdbc(:,1);Save(:,5);dbcWdbcWithPersis(:,1)],group)
ylim([0 inf])
set(gca,'XTickLabel',{'Generated','HDBSCAN_All','HDBSCAN_Selected','DeBaCl_NoPersis','DeBaClWDeBaCl_NoPersis','DeBaCl_WPersis','DeBaClWDeBaCl_WPersis'},'YMinorTick','on')
set(gcf,'Units','Normalized','OuterPosition',[0.02, 0.1, .93, .8])
grid on
grid minor
title('Distribution of minimum distance between cluster centers')
ylabel('Closest distance between cluster centers (nm)')

saveas(PP1Figh,'PP_1_DistributionOfMinimumDistanceBetweenClusterCenters.tiff')
%close(PP1Figh)

KNNClusCntrNoPersis=importdata('FinalResults\40_KNN_ClusterCentersAndSize_NOTconsideringPersistancy.txt');
KNNClusCntrWithPersis=importdata('FinalResults\40_KNN_ClusterCentersAndSize_ConsideringPersistancy.txt');


PP2Figh=figure(502);

group1=[ones(size(gnrtdClusCenters(:,4)));...
       2*ones(size(hdbAllClusCenters(:,9)));...
       3*ones(size(hdbSelClusCenters(:,9)));...
       4*ones(size(DaBaClClusCntrNoPersis(:,4)));...
       5*ones(size(DaBaClClusCntrWithPersis(:,4)));...
       6*ones(size(KNNClusCntrNoPersis(:,4)));...
       7*ones(size(KNNClusCntrWithPersis(:,4)))];
boxplot([gnrtdClusCenters(:,4); hdbAllClusCenters(:,9); hdbSelClusCenters(:,9); DaBaClClusCntrNoPersis(:,4);DaBaClClusCntrWithPersis(:,4); KNNClusCntrNoPersis(:,4);KNNClusCntrWithPersis(:,4)],group1)
ylim([0 inf])
set(gca,'XTickLabel',{'Generated','HDBSCAN_All','HDBSCAN_Selected','DeBaCl_NoPersistancy','DeBaCl_WithPersistancy','KNN_NoPersistancy','KNN_WithPersistancy'},'YMinorTick','on')
set(gcf,'Units','Normalized','OuterPosition',[0.01, 0.1, .97, .8])
grid on
grid minor
title('Cluster size distributions')
ylabel('Number of atoms')
saveas(PP2Figh,'PP_1_ClusterSizeDistributions.tiff')
%close(PP2Figh)
