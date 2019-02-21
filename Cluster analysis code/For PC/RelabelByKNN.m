%Relabeling atoms based on the KNN analysis
function Data=RelabelByKNN(tempLabels,tempProbabilities,tempPositions,tempDensity,NNNforKNN,PrefactorDeBaClDensityThreshold)

    A=RemovePointsBasedonDeBeClDensity(tempLabels,tempProbabilities,tempPositions,tempDensity,PrefactorDeBaClDensityThreshold);
    
    [rowNoise col]=find(A(:,1)==-1);
    NoisePosition=A(rowNoise,3:end);

    [rowClusters col]=find(A(:,1)>-1);
    Clusters=A(rowClusters,:);

    Mdl = fitcknn(Clusters(:,3:end),Clusters(:,1),'NumNeighbors',NNNforKNN,'Standardize',1);
    NoiseLabels=Mdl.predict(NoisePosition);

    UpdatedNoise=[NoiseLabels A(rowNoise,2) NoisePosition];
    Data=[Clusters;UpdatedNoise];

end