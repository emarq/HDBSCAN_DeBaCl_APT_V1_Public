%Generates an array containing a cluster size for each cluster
function [rSave,TotalNumberOfClusters,dmax]=ClusterSizeMaker(ClusterSizeInfo)

rSave=[];
for i=1:size(ClusterSizeInfo,1)
    r=[];
    ncluster=ClusterSizeInfo(i,1);
    ClusterRadius=ClusterSizeInfo(i,2);
    RadiusFluctuation=ClusterSizeInfo(i,3);
    r(1:ncluster,1)=ClusterRadius+(2.*RadiusFluctuation.*rand(ncluster,1))-RadiusFluctuation;
    rSave=[rSave;r];
end

dmax=max(rSave(:,1));
TotalNumberOfClusters=size(rSave,1);

end