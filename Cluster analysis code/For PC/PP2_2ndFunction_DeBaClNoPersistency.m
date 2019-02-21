%Post processing DeBaCl analysis results without considering persistency
function PP2_2ndFunction_DeBaClNoPersistency(gnrtdClusterID,AxisLimits,DatasetName)
tempFileName1=['FinalResults\' DatasetName '_CuAtomsInClusterandSolidSolution.txt'];
gnrtdDataset=importdata(tempFileName1);%x,y,z,mass,ID
figHdl=figure(511);
ID=gnrtdClusterID;
[rowGen col]=find(gnrtdDataset(:,5)==ID);
plot3(gnrtdDataset(rowGen,1),gnrtdDataset(rowGen,2),gnrtdDataset(rowGen,3),'r.','MarkerSize',3)
NumOfAtmsInThisClus=size(rowGen,1);

hold on
[rowGen col]=find(gnrtdDataset(:,5)~=ID & gnrtdDataset(:,5)~=-1);
plot3(gnrtdDataset(rowGen,1),gnrtdDataset(rowGen,2),gnrtdDataset(rowGen,3),'.','MarkerSize',3,'color',([230/255,190/255,138/255]))

tempFileName2=['FinalResults\' DatasetName '_GnrtdClstrCntrAndSize.txt'];
gnrtdClusCenters=importdata(tempFileName2);
hold on
plot3(gnrtdClusCenters(:,1),gnrtdClusCenters(:,2),gnrtdClusCenters(:,3),'k.','MarkerSize',15)


hdbAllClusCenters=importdata('FinalResults\11_HDBSCAN_ClusterCentersNOTconsideringPersistancyThreshold.txt');
hold on
plot3(hdbAllClusCenters(:,6),hdbAllClusCenters(:,7),hdbAllClusCenters(:,8),'O','MarkerSize',7,'color',([0/255,0/255,0]),'LineWidth',1)


hdbSelClusCenters=importdata('FinalResults\11_HDBSCAN_ClusterCentersconsideringPersistancyThreshold.txt');
hold on
plot3(hdbSelClusCenters(:,6),hdbSelClusCenters(:,7),hdbSelClusCenters(:,8),'O','MarkerSize',4,'color',([0/255,0,255/255]),'LineWidth',1)

DaBaClClusCntrWithPersis=importdata('FinalResults\30_DeBaCl_ClusterCentersAndSize_ConsideringPersistancy.txt');
hold on
plot3(DaBaClClusCntrWithPersis(:,1),DaBaClClusCntrWithPersis(:,2),DaBaClClusCntrWithPersis(:,3),'.','MarkerSize',8,'color',[0,1,1])

hold off
set(gcf,'Units','Normalized','OuterPosition',[0.25, 0.07, .65, .92])
legend({'Selected Cluster','Other Clusters','GNRTD Clus centers','HDBSCAN_-All','HDBSCAN_-Sel','DeBaCl_-WithPersistancy'},'location','best')

xlim([AxisLimits(1,1) AxisLimits(1,2)])
ylim([AxisLimits(2,1) AxisLimits(2,2)])
zlim([AxisLimits(3,1) AxisLimits(3,2)])

xlabel('X (nm)')
ylabel('Y (nm)')
zlabel('Z (nm)')
TITLE={['Cluster number ' num2str(ID) ' is highlighted (Considering persistency)'];...
       ['Number of atoms in this cluster is ' num2str(NumOfAtmsInThisClus)]};
title(TITLE)

saveas(figHdl,'PP_2_HighlightedCluster_Considering persistency.tiff')
saveas(figHdl,'PP_2_HighlightedCluster_Considering persistency.fig')
%close(figHdl)

end