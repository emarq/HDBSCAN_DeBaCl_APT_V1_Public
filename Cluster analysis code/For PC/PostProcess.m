%PostProcess code for Main_ClusterAnalysis.m

%Three plots are made
%plot 500: disntance between gnrtd clusters with 1)itself, 2)nearest All
%HDBSCAN 3) Selected HDBSCAN 4)DeBaCl 
%plot 501)CLuster size
%plot502) Distribution in space
%The output of the function
%DistGnrtdWOthers: Distance between generated clusters with )itself, 2)nearest All
%HDBSCAN 3) Selected HDBSCAN 4)DeBaCl . The final column is gnrtdCLusterID
DatasetName='ExampleOne';%The first part of the name of the dataset (before _)
VideoFrameRate=30;
VideoDuration=20;
CaptureVideo=false;
iHaveNonPersisResults=false;

%parameters for PP2_...
gnrtdClusterID=75;

%parameters for PP3_...
CLusterIDs=[8 17 31 -1];
%------------------------------------
%%
%DistGnrtdWOthers if iHaveNonPersisResults is TRUE: distgnrtd, distHDB, distHDBsel, distDBC, distDBCwPersis, gnrtedClusID
%DistGnrtdWOthers if iHaveNonPersisResults is FALSE: distgnrtd, distHDB, distHDBsel, distDBCwPersis, gnrtedClusID
DistGnrtdWOthers=PP1_PlotClusterCenterSize(DatasetName,VideoFrameRate,VideoDuration,CaptureVideo,iHaveNonPersisResults);


%%
PP2_HighlightOneGNRTDcluster(gnrtdClusterID,DatasetName,iHaveNonPersisResults)

%%
%CLusterIDs   is one row with multiple columns. If you want to add noise to
%the dataset, noise ID is -1.
%A file with the name PPP_Iman_DatasetForClusterAnalysis is made in the currect directory. PPP stand for Post Process Porduced
PP3_MakeNewDataSetFromSpecificClusterID(CLusterIDs,DatasetName) 

