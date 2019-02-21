%Removing points from the dataset based on the DeBaCl analysis
function Data=RemovePointsBasedonDeBeClDensity(tempLabels,tempProbabilities,tempPositions,tempDensity,PrefactorDeBaClDensityThreshold)

A=[tempLabels,tempProbabilities,tempDensity,tempPositions];

[rowCluster col]=find(A(:,1)>-1);
ClusterData=A(rowCluster,:);
MinClusterDensity=min(ClusterData(:,3));
DeBaClDensityThreshold=MinClusterDensity(1,1)*PrefactorDeBaClDensityThreshold;

A(any(A(:,3)<DeBaClDensityThreshold,2),:)=[];
Data=[A(:,1:2) A(:,4:end)];


end