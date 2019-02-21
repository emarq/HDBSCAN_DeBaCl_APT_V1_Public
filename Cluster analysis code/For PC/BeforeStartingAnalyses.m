%This function provides some preliminary information about the cluster analysis paramters and the dataset
function [AxisLimits,pDeBaCl]=BeforeStartingAnalyses(DatasetName,MinClusterSizeHDBSCAN,MinSamplesHDBSCAN,hdbscanPersistencyThreshold,...
                       hdbscanProbabilityThreshold,kDeBaCl,gammaDeBaCl,MassLengthDeBaClThreshold,...
                       NNNforKNN,PrefactorDeBaClDensityThreshold,hdbscanAnalysisTwoTimes,PrefactForPersistancy,IgnorePersisInDeBaClanalysis,...
                       IgnorehdbscanProbabilityThresholdAfterKNNrelabeling)
                              
    X=importdata(DatasetName);
    g=figure(1);
    if size(X,2)==2
        plot(X(:,1),X(:,2),'k.','MarkerSize',2);
        pDeBaCl=2;%Dataset is 2D
    else
        plot3(X(:,1),X(:,2),X(:,3),'k.','MarkerSize',2);
        pDeBaCl=3;%Dataset is 3D
    end
    xlabel('X (nm)')
    ylabel('Y (nm)')
    zlabel('Z (nm)')
    AxisLimits=[min(X(:,1)) max(X(:,1));...
        min(X(:,2)) max(X(:,2));...
        min(X(:,3)) max(X(:,3))];
    xlim([AxisLimits(1,1) AxisLimits(1,2)])
    ylim([AxisLimits(2,1) AxisLimits(2,2)])
    zlim([AxisLimits(3,1) AxisLimits(3,2)])
    Title=({'Original Dataset';['Number of atoms in the dataset is ' num2str(size(X,1))]});
    title(Title)
    set(gcf,'Units','Normalized','OuterPosition',[0.25, 0.07, .65, .92])
    saveas(g,'1_OriginalDatat.tiff')
    %saveas(g,'1_OriginalDatat.fig')
    %close(g)                  
    
    fid1 = fopen('0_ParamtersUsedForClusterAnalyses.txt','wt');
    
    fprintf(fid1, '%s\t', '       DatasetName:');
    fprintf(fid1, '%s\n', DatasetName);
    
    fprintf(fid1, '%s', '          MinClusterSizeHDBSCAN=');
    fprintf(fid1, '%i\n', MinClusterSizeHDBSCAN);
    
    fprintf(fid1, '%s', '              MinSamplesHDBSCAN=');
    fprintf(fid1, '%i\n', MinSamplesHDBSCAN);
	
	fprintf(fid1, '%s', '        hdbscanAnalysisTwoTimes=');
	if hdbscanAnalysisTwoTimes
		fprintf(fid1, '%s\n', 'true');
	else
		fprintf(fid1, '%s\n', 'false');
	end
	
	fprintf(fid1, '%s', '          PrefactForPersistancy=');
	fprintf(fid1, '%i\n', PrefactForPersistancy);
		
    fprintf(fid1, '%s', '    hdbscanPersistencyThreshold=');
    fprintf(fid1, '%f\n', hdbscanPersistencyThreshold);                    
                   
    fprintf(fid1, '%s', '    hdbscanProbabilityThreshold=');
    fprintf(fid1, '%f\n', hdbscanProbabilityThreshold);                   
                   
%    fprintf(fid1, '%s', '                        pDeBaCl=');
%   fprintf(fid1, '%i\n', pDeBaCl);                   
                   
    fprintf(fid1, '%s', '                        kDeBaCl=');
    fprintf(fid1, '%i\n', kDeBaCl);  
    
    fprintf(fid1, '%s', '                    gammaDeBaCl=');
    fprintf(fid1, '%i\n', gammaDeBaCl);
                                
    fprintf(fid1, '%s', '   IgnorePersisInDeBaClanalysis=');
    if IgnorePersisInDeBaClanalysis
        fprintf(fid1, '%s\n', 'true');
    else
        fprintf(fid1, '%s\n', 'false');
    end
    
    fprintf(fid1, '%s', '      MassLengthDeBaClThreshold=');
    fprintf(fid1, '%f\n', MassLengthDeBaClThreshold);
    
    fprintf(fid1, '%s', '                      NNNforKNN=');
    fprintf(fid1, '%i\n', NNNforKNN);
    
    fprintf(fid1, '%s', 'PrefactorDeBaClDensityThreshold=');
    fprintf(fid1, '%f', PrefactorDeBaClDensityThreshold);
    
    if IgnorehdbscanProbabilityThresholdAfterKNNrelabeling
        fprintf(fid1, '%s','IgnorehdbscanProbabilityThresholdAfterKNNrelabeling=true');
    else
        fprintf(fid1, '%s','IgnorehdbscanProbabilityThresholdAfterKNNrelabeling=false');
    end
    fclose(fid1);
  
end