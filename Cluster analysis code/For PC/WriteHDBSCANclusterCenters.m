%Writing HDBSCAN cluster centers
function WriteHDBSCANclusterCenters(hdbscanCluster,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold)
%Two files will be generated in which we have approximate X,Y and Z of
%HDBSCAN detected cluster centers, 
%The first one considers hdbscanPersistencyThreshold 
%The second file does NOT consider hdbscanPersistencyThreshold 
%and writes all the detected clusters by HDBSCAN
fid0 = fopen('11_HDBSCAN_ClusterCentersConsideringPersistancyThreshold.txt','wt');
for i=1:size(hdbscanCluster,2)
    p1=hdbscanCluster(i).labels;
    p2=hdbscanCluster(i).persistence;
    tempProb=hdbscanCluster(i).probabilities;
    p31=min(tempProb) ;
    if p2>=hdbscanPersistencyThreshold 
        p32=mean(tempProb); 
        p33=max(tempProb);
        tempAtomPos=hdbscanCluster(i).atomPositions;
        p41=mean(tempAtomPos(:,1)); 
        p42=mean(tempAtomPos(:,2)); 
        p43=mean(tempAtomPos(:,3));
        p5=size(tempAtomPos,1);
    
        PRINT=[p1 p2 p31 p32 p33 p41 p42 p43 p5];%label persistancy MinProb MeanProb MaxProb XClusCenter YClusCenter ZClusCenter ClusterSize 
        fprintf(fid0, '%6i\t %10.3f\t %10.2f\t %10.2f\t %10.2f\t %10.5f\t %10.5f\t %10.5f\t %6i\n', PRINT);
    end  
end
fclose(fid0);

pSave=[];
fid1 = fopen('11_HDBSCAN_ClusterCentersNOTconsideringPersistancyThreshold.txt','wt');
for i=1:size(hdbscanCluster,2)
    p1=hdbscanCluster(i).labels;
    p2=hdbscanCluster(i).persistence;
    tempProb=hdbscanCluster(i).probabilities;
    p31=min(tempProb);
    p32=mean(tempProb); 
    p33=max(tempProb);
    tempAtomPos=hdbscanCluster(i).atomPositions;
    p41=mean(tempAtomPos(:,1)); 
    p42=mean(tempAtomPos(:,2)); 
    p43=mean(tempAtomPos(:,3));
    p5=size(tempAtomPos,1);
    
    PRINT=[p1 p2 p31 p32 p33 p41 p42 p43 p5];%label persistancy MinProb MeanProb MaxProb XClusCenter YClusCenter ZClusCenter ClusterSize 
    fprintf(fid1, '%6i\t %10.3f\t %10.2f\t %10.2f\t %10.2f\t %10.5f\t %10.5f\t %10.5f\t %6i\n', PRINT);
    pSave=[pSave;PRINT];  
end
fclose(fid1);

PlotNumberofClusterVsHDBSCANpersistencyThreshold(pSave,hdbscanPersistencyThreshold)

end