%Generate a new dataset from a list of selected cluster IDs.
function PP3_MakeNewDataSetFromSpecificClusterID(CLusterIDs,DatasetName)
TempName=['FinalResults\' DatasetName '_DatasetForClusterAnalysis.txt']
X=importdata(TempName);
AxisLimits=[min(X(:,1)) max(X(:,1));...
            min(X(:,2)) max(X(:,2));...
            min(X(:,3)) max(X(:,3))];

tempFileName=['FinalResults\' DatasetName '_CuAtomsInClusterandSolidSolution.txt'];
gnrtdDataset=importdata(tempFileName);%x,y,z,mass,ID
row=[];
for i=1:size(CLusterIDs,2)
    ID=CLusterIDs(1,i);
    [rowTemp col]=find(gnrtdDataset(:,5)==ID);
    row=[row;rowTemp];
end
X=gnrtdDataset(row,1:3);

figure(520)
plot3(X(:,1),X(:,2),X(:,3),'k.','MarkerSize',2)
title('The new dataset generated in post-process step')
xlim([AxisLimits(1,1) AxisLimits(1,2)])
ylim([AxisLimits(2,1) AxisLimits(2,2)])
zlim([AxisLimits(3,1) AxisLimits(3,2)])
xlabel('X (nm)')
ylabel('Y (nm)')
zlabel('Z (nm)')


tempFileNamePPP=['PPP_' DatasetName '_DatasetForClusterAnalysis.txt'];
fid4 = fopen(tempFileNamePPP,'wt');%PPP stand for Post Process Porduced
for i=1:size(X,1)
    PRINT=[X(i,1),X(i,2),X(i,3)];
    fprintf(fid4, '%10.5f\t %10.5f\t %10.5f\n', PRINT);
end
fclose(fid4);

end