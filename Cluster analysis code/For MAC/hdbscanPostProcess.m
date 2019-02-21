%Post processing HDBSCAN analysis results
function hdbscanCluster=hdbscanPostProcess(DatasetName)

    hdbscanLabels=importdata('HDBSCANoutputs/Labels.txt');
    hdbscanPersistence=importdata('HDBSCANoutputs/Persistence.txt');
    hdbscanProbabilities=importdata('HDBSCANoutputs/Probabilities.txt');
    PositionDataset=importdata(DatasetName);
    SiZePositionDatasetCol=size(PositionDataset,2); %Determines whether dataset is 2D or 3D

    %Labels==-1 means NOISE
    %Since real cluster labels start from 0, 
    %the counter i starts from 0.
    NoiseLabel=-1;
    UniqueLabels=unique(hdbscanLabels);
    
    if ismember(NoiseLabel,UniqueLabels)
        for i=0:(size(UniqueLabels,1)-2)                                    
            hdbscanCluster(i+1).labels=i;
            [row col]=find(hdbscanLabels==i);
            hdbscanCluster(i+1).probabilities=hdbscanProbabilities(row,1);
            hdbscanCluster(i+1).persistence=hdbscanPersistence(i+1,1);
            hdbscanCluster(i+1).atomPositions=PositionDataset(row,1:SiZePositionDatasetCol);
        end
    else
        for i=0:(size(UniqueLabels,1)-1)                                    
            hdbscanCluster(i+1).labels=i;
            [row col]=find(hdbscanLabels==i);
            hdbscanCluster(i+1).probabilities=hdbscanProbabilities(row,1);
            hdbscanCluster(i+1).persistence=hdbscanPersistence(i+1,1);
            hdbscanCluster(i+1).atomPositions=PositionDataset(row,1:SiZePositionDatasetCol);
        end
    end
    
end