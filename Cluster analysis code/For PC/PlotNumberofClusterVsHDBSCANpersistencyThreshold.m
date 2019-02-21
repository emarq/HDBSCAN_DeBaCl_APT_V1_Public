%Plots number of cluster vs HDBSCAN persistency threshold
function PlotNumberofClusterVsHDBSCANpersistencyThreshold(pSave,hdbscanPersistencyThreshold)

B = sortrows(pSave,-2);
Unique=unique(B(:,2));
Save(1:size(Unique,1),1:2)=0;
for i=1:size(Unique,1)
    [row, ~]=find(B(:,2)>=Unique(i,1));
    Save(i,1:2)=[Unique(i,1) size(row,1)];
end

Fig1hndl=figure(15);
plot(Save(:,1),Save(:,2),'k.')
%-------
xlswrite('AccumulativePlot.xlsx',Save)
%-------
hold on
[rowTemp, ~]=find(Save(:,1)==hdbscanPersistencyThreshold);
if size(rowTemp,1)>0
    plot(Save(rowTemp,1),Save(rowTemp,2),'r.','MarkerSize',18)
end
hold off

xlabel('HDBSCAN persistency threshold')
ylabel('Number of clusters detected by HDBSCAN')
ylim([0 inf])
if size(rowTemp,1)>0
    title({'Cumulative plot of the number of clusters with respect to HDBSCAN persistency threshold';....
        'Red spot represents the selected HDBSCAN persistency threshold value'})
else
    title({'Cumulative plot of the number of clusters with respect to HDBSCAN persistency threshold';....
        ['HDBSCAN persistency threshold value is ' num2str(hdbscanPersistencyThreshold)]})
end
set(gcf,'Units','Normalized','OuterPosition',[0.01, 0.1, .97, .8])
grid on
grid minor
set(gca,'XMinorTick','on')

saveas(Fig1hndl,'2_AccumulativePlot_NumberOfCLustersVSHDBSCANPersistencyThreshold.tiff')
%close(Fig1hndl)


end