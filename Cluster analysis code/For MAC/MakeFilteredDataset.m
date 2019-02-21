%It prepares a new dataset for the second round of cluster analysis
function NewDatasetName=MakeFilteredDataset(DatasetName,FirstScanOutput)

OriginalData=importdata(DatasetName);
for i=1:size(FirstScanOutput,2)
    TempPosition=FirstScanOutput(i).atomPositions;
    OriginalData(ismember(OriginalData,TempPosition,'rows'),:)=[];
end

NewDatasetName='FLTRDforSCNDhdbscan.txt';

fid4 = fopen(NewDatasetName,'wt');
for i=1:size(OriginalData,1)
    PRINT=[OriginalData(i,1),OriginalData(i,2),OriginalData(i,3)];
    fprintf(fid4, '%10.5f\t %10.5f\t %10.5f\n', PRINT);
end
fclose(fid4);


end