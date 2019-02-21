%HDBSCAN python is called in this function
function hdbscanCluster=hdbscanAnalysis(DatasetName,hdbscanPersistencyThreshold,hdbscanProbabilityThreshold,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,AxisLimits)
    if exist('HDBSCANoutputs','dir')==7 %It is used to make hdbscanCluster in hdbscanPostProcess function
        rmdir HDBSCANoutputs s
    end
    mkdir HDBSCANoutputs
    copyfile(DatasetName, 'TempHDBSCANfile.txt')

    fid1 = fopen('TempHDBSCANparameters.txt','wt');
    fprintf(fid1, '%d\n', MinClusterSizeHDBSCAN);
    fprintf(fid1, '%d', MinSamplesHDBSCAN);
    fclose(fid1);
    
    !C:\Python27\python.exe hdbscanImanSecond.py
    
    delete 'TempHDBSCANparameters.txt'
    delete 'TempHDBSCANfile.txt'
    hdbscanCluster=hdbscanPostProcess(DatasetName);

end