%DeBaCl python code is called in this function
function TotoalNumberOfClusters=debaclAnalysis(hdbscanCluster,hdbscanPersistencyThreshold,MassLengthDeBaClThreshold,pDeBaCl,kDeBaCl,gammaDeBaCl,IgnorePersistency)

    if IgnorePersistency
        hdbscanPersistencyThreshold=0;
        AllDeBaClResultsFolderPath='AllDeBaClResultsWithOUTPersistancy';
        if exist(AllDeBaClResultsFolderPath,'dir')==7
            rmdir AllDeBaClResultsWithOUTPersistancy s
        end        
    else  
        AllDeBaClResultsFolderPath='AllDeBaClResultsWithPersistancy';
        if exist(AllDeBaClResultsFolderPath,'dir')==7
            rmdir AllDeBaClResultsWithPersistancy s
        end
    end
    
    mkdir(AllDeBaClResultsFolderPath)
    DeBaClTempOutputsFolderName='DeBaClTempOutputs';
    DeBaClTempFOlderPath=fullfile(DeBaClTempOutputsFolderName);
    
    if exist(DeBaClTempOutputsFolderName,'dir')==7
        rmdir(DeBaClTempOutputsFolderName,'s')
    end
    
    fid0 = fopen('tempDeBaClparameters.txt','wt');
    fprintf(fid0,'%d\n',pDeBaCl);
    fprintf(fid0,'%d\n',kDeBaCl);
    fprintf(fid0,'%d',gammaDeBaCl);
    fclose(fid0);
    for i=1:size(hdbscanCluster,2)
        if hdbscanCluster(i).persistence>=hdbscanPersistencyThreshold
            TempPosition=hdbscanCluster(i).atomPositions;
            fid1 = fopen('HDBSCANdClusterForDeBaCl_position.txt','wt');
            if size(TempPosition,2)==2  %for 2D dataset
              for j=1:size(TempPosition,1)
                  PRINT=[TempPosition(j,1) TempPosition(j,2)];
                  fprintf(fid1, '%f %f\n', PRINT);
              end
            else
              for j=1:size(TempPosition,1)
                  PRINT=[TempPosition(j,1) TempPosition(j,2) TempPosition(j,3)];
                  fprintf(fid1, '%f %f %f\n', PRINT);
              end
            end
            fclose(fid1);

            mkdir(DeBaClTempOutputsFolderName)
            !C:\Python27\python.exe debaclImanSecond.py
            
            TempProbability=hdbscanCluster(i).probabilities;
            fid2 = fopen('HDBSCANdClusterForDeBaCl_probabilities.txt','wt');
            for j=1:size(TempProbability,1)
                fprintf(fid2,'%f\n',TempProbability(j,1));
            end
            fclose(fid2);
            movefile('HDBSCANdClusterForDeBaCl_probabilities.txt',DeBaClTempFOlderPath)
            movefile('HDBSCANdClusterForDeBaCl_position.txt',DeBaClTempFOlderPath)
            newName = sprintf('%s_%d', 'hdbscanCluster',i);
            movefile(DeBaClTempFOlderPath, fullfile(AllDeBaClResultsFolderPath, newName));
           
        end
    end
    
    delete 'tempDeBaClparameters.txt'
    if IgnorePersistency
        fid3 = fopen('31_WithOUTpersistancyThreshold_HDBSCANdClustersWithMoreThanOneDeBaClClusters.txt','wt');%I may add header to this file.
    else
        fid3 = fopen('31_WithPersistancyThreshold_HDBSCANdClustersWithMoreThanOneDeBaClClusters.txt','wt');
    end
    
    PRINTheader=sprintf('%s\t\t %s\t %s\t', 'FolderName', 'InitialNumberOfLeafs', 'NumberOfClusters');
    fprintf(fid3, '%s\n', PRINTheader); 
    
    TotoalNumberOfClusters=0;
    for i=1:size(hdbscanCluster,2)
         newName = sprintf('%s_%d', 'hdbscanCluster',i);
         FolderAddress=fullfile(AllDeBaClResultsFolderPath, newName);
         if exist(FolderAddress,'dir')==7
             [InitialNumberOfLeafs, NumberOfClusters]=DeBaClPostProcess(FolderAddress,MassLengthDeBaClThreshold,gammaDeBaCl);
             if InitialNumberOfLeafs>1
                 fprintf(fid3, '%s\t\t\t', newName);
                 PRINT=[InitialNumberOfLeafs, NumberOfClusters];
                 fprintf(fid3, '%i\t\t\t\t\t %i\n', PRINT);
             end
             TotoalNumberOfClusters=TotoalNumberOfClusters+NumberOfClusters;
         end
    end
    fclose(fid3);

end