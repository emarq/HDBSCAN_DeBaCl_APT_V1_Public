clear all
clc
close all
%This code generates clusters. Version 3

%Make sure that the pos file is a rectangular cube and not a cone shape,
%otherwise some clusters cannot get any atoms in their clusters.

PosFileName='crystal-fcc-50-50-100.pos';%pos file name
NameOfTheOutputFiles='ExampleNine';
ShrinkPosFile=false; %logical variable used to shrink the pos file
CuCencentrationInSS=0.1;%General Cu concentration in the entire dataset
CuMatrixCompGradient=[100 100]; %for a case that we have Cu in Matrix (i.e., MassID=65), we can have a gradient
                                %of Cu concentration in the matrix. The
                                %values are in percent. It makes gradient
                                %along x axis. [70 100] means keeping 70%
                                %of the Cu atoms in the matrix on one side
                                %and 100% of Cu atoms in another side of
                                %the matrix
                                %if you do not want to apply Gradient for
                                %the Cu in matrix, put the two values exactly the
                                %same (e.g., [100 100]
CuConcentrationInCluster=0.3;%Cu concentration in the clusters (i.e., precipitates)
ClusterSizeInfo=[100 1.1 0.1;...
                69 1.5 0.1]; %Number of clusters, Cluster radius in nm, ClusterRadius+/-RadiusFluctuation (nm) 
dseparation =6;  %a multiplication factor which is used to 
                  %determine the distance between two 
                  %cluster centers (dseparation*ClusterRadius)
eff=[0.37 0.37];% APT detection efficiency range [MinEfficiency MaxEfficiency]
    %The value is NOT in percent.
    %It is better either make a gradient in detection efficiency or a gradient
    %in the Cu composition of the matrix.
    
a = 0.3515;%Lattice constant
m = 1.0*a;% It is used for delocalization of atoms
b = 0;% It is used for delocalization of atoms
      %for Fe atoms in matrix, delocalization is dX = m.*randn(NFe,3) + b
      %for Cu atoms in matrix, delocalization is dX=m.*randn(NCuSS,3)+b
      %for Cu atoms in clusters, delocalization is dX=2.*m.*randn(NCuPrecip,3)+b
%----------------------
pos=open_pos(PosFileName);
if ShrinkPosFile
    pos=ShrinkingPosFile(pos);
end

atomvolume = a^3/2;
density=1/atomvolume;%for now I do not know where this density is going to be used

X=pos(:,1);
Y=pos(:,2);
Z=pos(:,3);
mass=pos(:,4);
clear pos

MinX=min(X);
MaxX=max(X);
MinY=min(Y);
MaxY=max(Y);
MinZ=min(Z);
MaxZ=max(Z);

[r,TotalNumberOfClusters,dmax]=ClusterSizeMaker(ClusterSizeInfo);
[ClusterCenters, MinDistBtwnClusters]=findClusterCenters(MinX,MaxX,MinY,MaxY,MinZ,MaxZ,TotalNumberOfClusters,dseparation,dmax,ClusterSizeInfo);
ColorsForPlots=distinguishable_colors(TotalNumberOfClusters);

X=[X;ClusterCenters(:,1)];%The cluster centers are added to the dataset. This does not at all change anything special in the dataset
Y=[Y;ClusterCenters(:,2)];
Z=[Z;ClusterCenters(:,3)];
mass=[mass;zeros(size(ClusterCenters,1),1)];

%position of the center of the clusters
Xcluster=ClusterCenters(:,1);
Ycluster=ClusterCenters(:,2);
Zcluster=ClusterCenters(:,3);

%concentration of Cu in clusters
N=length(X); %Number of atoms in the entire dataset (size of the dataset)

mass(1:N,1)=27;%I assume initially all atoms are Fe
clusterID(1:N,1)=0;%Cluster ID of zero is for noise
FigTwo=figure(2);
for i=1:TotalNumberOfClusters
    tempDist=sqrt(((X(:,1)-Xcluster(i,1)).^2)+((Y(:,1)-Ycluster(i,1)).^2)+((Z(:,1)-Zcluster(i,1)).^2));
    [row, ~]=find(tempDist(:,1)<r(i,1));
    rowRandPerm=randperm(length(row),floor((length(row))*CuConcentrationInCluster));
    mass(row(rowRandPerm,1),1)=63;%The massID for Cu atoms in the clusters is 63
    clusterID(row(rowRandPerm,1),1)=i;
    plot3(X(row(rowRandPerm,1),1),Y(row(rowRandPerm,1),1),Z(row(rowRandPerm,1),1),'.','MarkerSize',4,'color',ColorsForPlots(i,1:3))
    hold on
end
plot3(Xcluster,Ycluster,Zcluster,'k.','MarkerSize',12)
hold off
title('Clusters before delocalization')
xlim([MinX MaxX])
ylim([MinY MaxY])
zlim([MinZ MaxZ])
xlabel('X (nm)')
ylabel('Y (nm)')
zlabel('Z (nm)')
saveas(FigTwo,'0_GeneratedDatasetBeforeDelocalization.tiff')
saveas(FigTwo,'0_GeneratedDatasetBeforeDelocalization.fig')
%close(FigTwo)

NCuTemp=floor(N*CuCencentrationInSS); %A general estimate of Cu atoms in the entire dataset based on Cu Concentration in Solid Solution
if NCuTemp<=(sum(mass(:,1)==63))
    disp('The total number of atoms in the clusters (mass ID==63) is more than the entire Cu atoms considered for the sample.')
    temp=['This difference is ' num2str(((sum(mass(:,1)==63))-NCuTemp)) ' Cu atoms'];
    disp(temp)
    disp('So no more Cu with massID=65 is added to the solid solution.')
else
    [rowFeTemp, ~]=find(mass(:,1)==27);
    randPermNumbers=randperm(length(rowFeTemp),NCuTemp-(sum(mass(:,1)==63)));
    mass(rowFeTemp(randPermNumbers,1),1)=65; %The massID for precipiates in the Solid solution is 65
    clusterID(rowFeTemp(randPermNumbers,1),1)=-1;%The clusterID for precipiates in the Solid solution is -1
    if CuMatrixCompGradient(1,2)-CuMatrixCompGradient(1,1)>0
        [X,Y,Z,mass,clusterID]=VaryingCuMatrixComp(X,Y,Z,mass,clusterID,CuMatrixCompGradient);
    end
end

% apply delocalization in x, y, z (not radial along radius of curvature)
[rowFe, ~]=find(mass(:,1)==27);
NFe=size(rowFe,1);
dX = m.*randn(NFe,3) + b;
X(rowFe,1)=X(rowFe,1)+dX(:,1);
Y(rowFe,1)=Y(rowFe,1)+dX(:,2);
Z(rowFe,1)=Z(rowFe,1)+(0.5*dX(:,3));

% Cu in solid solution
[rowCuSS, ~]=find(mass(:,1)==65);
if size(rowCuSS,1)>0
    NCuSS=length(rowCuSS);
    dX=m.*randn(NCuSS,3)+b;
    X(rowCuSS,1)=X(rowCuSS,1)+dX(:,1);
    Y(rowCuSS,1)=Y(rowCuSS,1)+dX(:,2);
    Z(rowCuSS,1)=Z(rowCuSS,1)+0.5.*dX(:,3);
end

%Cu in clusters (Precipitates)
[rowCuPrecip, ~]=find(mass(:,1)==63);
NCuPrecip=size(rowCuPrecip,1);
dX=2.*m.*randn(NCuPrecip,3)+b; %Pay attention that the delocalization is 2 times more than Cu in matrix
X(rowCuPrecip,1)=X(rowCuPrecip,1)+dX(:,1);
Y(rowCuPrecip,1)=Y(rowCuPrecip,1)+dX(:,2);
Z(rowCuPrecip,1)=Z(rowCuPrecip,1)+0.5.*dX(:,3);

% apply detection efficiency randomly
[X,Y,Z,mass,clusterID]=ApplyDetectionEfficiency(X,Y,Z,mass,clusterID,eff);

[FinalCuRows, ~]=find((mass(:,1)==63) | (mass(:,1)==65));
X2=X(FinalCuRows,1);
Y2=Y(FinalCuRows,1);
Z2=Z(FinalCuRows,1);
mass2=mass(FinalCuRows,1);
clusterID2=clusterID(FinalCuRows,1);
tempPos=[NameOfTheOutputFiles '_DatasetForClusterAnalysis.pos'];
savepos(X2,Y2,Z2,mass2,tempPos)

temp=[NameOfTheOutputFiles '_CuAtomsInClusterandSolidSolution.txt']; 
fid2 = fopen(temp,'wt');
for i=1:size(X2,1)
    PRINT=[X2(i,1),Y2(i,1),Z2(i,1),mass2(i,1),clusterID2(i,1)];
    fprintf(fid2, '%10.5f\t %10.5f\t %10.5f\t %6i\t %6i\n', PRINT);
end
fclose(fid2);
temp=[NameOfTheOutputFiles '_DatasetForClusterAnalysis.txt'];
fid4 = fopen(temp,'wt');
for i=1:size(X2,1)
    PRINT=[X2(i,1),Y2(i,1),Z2(i,1)];
    fprintf(fid4, '%10.5f\t %10.5f\t %10.5f\n', PRINT);
end
fclose(fid4);
temp=[NameOfTheOutputFiles '_ParamtersUsedForDatasetGeneration.txt'];
fid1 = fopen(temp,'wt');
fprintf(fid1, '%s\t', '    DatasetName:');
fprintf(fid1, '%s\n', 'Iman_DatasetForClusterAnalysis.txt'); 
if ShrinkPosFile
    fprintf(fid1, '%s\n', '                ShrinkPosFile=true');
else
    fprintf(fid1, '%s\n', '                ShrinkPosFile=false');
end
fprintf(fid1, '%s', '          CuCencentrationInSS=');
fprintf(fid1, '%f\n', CuCencentrationInSS);
if CuMatrixCompGradient(1,2)-CuMatrixCompGradient(1,1)==0
    temp='There is no gradient in the composition of Cu in matrix';
    fprintf(fid1, '%s\n', temp);
else
    temp=['The gradient of Cu in matrix changes from ' num2str(CuMatrixCompGradient(1,1)) '% to ' num2str(CuMatrixCompGradient(1,2)) '%'];
    fprintf(fid1, '%s\n', temp);
end
fprintf(fid1, '%s', '     CuConcentrationInCluster=');
fprintf(fid1, '%f\n', CuConcentrationInCluster);
for i=1:size(ClusterSizeInfo,1)
    temp=[num2str(ClusterSizeInfo(i,1)) ' of the atoms have the radius of ' num2str(ClusterSizeInfo(i,2)) ' (nm) and the radius uncertainity of ' num2str(ClusterSizeInfo(i,3)) ' (nm)'];   
    fprintf(fid1, '%s\n',temp);
end
fprintf(fid1, '%s', '                  dseparation=');
fprintf(fid1, '%f\n', dseparation);
if eff(1,1)-eff(1,2)==0
    fprintf(fid1, '%s', '          Detection fficiency=');
    fprintf(fid1, '%f\n', eff(1,1));
else
    temp=['Detection efficiency changes from ' num2str(eff(1,1)) ' to ' num2str(eff(1,2))]; 
    fprintf(fid1, '%s\n',temp);
end
fprintf(fid1, '%s', '             Lattice constant=');
fprintf(fid1, '%f\n', a);
fprintf(fid1, '%s', '  Delocalization parameter, m=');
fprintf(fid1, '%f\n', m);
fprintf(fid1, '%s', '  Delocalization parameter, b=');
fprintf(fid1, '%f\n', b);
fclose(fid1);

hfig=figure(3);
ClusterSizeSaver(1:TotalNumberOfClusters,1)=0;
for i=1:TotalNumberOfClusters
    [tempRow,~]=find(clusterID(:,1)==i);
    plot3(X(tempRow,1),Y(tempRow,1),Z(tempRow,1),'.','MarkerSize',4,'color',ColorsForPlots(i,1:3))
    hold on
    ClusterSizeSaver(i,1)=length(tempRow);
end
[tempRow,~]=find(mass(:,1)==65);
plot3(X(tempRow(:,1)),Y(tempRow(:,1)),Z(tempRow(:,1)),'k.','MarkerSize',2)
hold on
plot3(Xcluster,Ycluster,Zcluster,'k.','MarkerSize',12)
hold off
xlim([MinX MaxX])
ylim([MinY MaxY])
zlim([MinZ MaxZ])
xlabel('X (nm)')
ylabel('Y (nm)')
zlabel('Z (nm)')
TITLE1=['Cu in clusters and solid solution after delocalization'];
TITLE2=['Cu con. in Solid solution is ' num2str(100*CuCencentrationInSS) '%, and Cu con. in clusters is ' num2str(100*CuConcentrationInCluster) '%']; 
title({TITLE1;TITLE2})
saveas(hfig,'0_FinalGeneratedDataset.tiff')
saveas(hfig,'0_FinalGeneratedDataset.fig')
%close(hfig)

xMean=(MinX+MaxX)/2; 
yMean=(MinY+MaxY)/2;
zMean=(MinZ+MaxZ)/2;


guidata(hfig,struct('Resolution',2,'xlimLL',MinX,'xlimUL',MaxX,'ylimLL',MinY,'ylimUL',MaxY,'zlimLL',MinZ,'zlimUL',MaxZ,...
        'xlimLLs',MinX,'xlimULs',MaxX,'ylimLLs',MinY,'ylimULs',MaxY,'zlimLLs',MinZ,'zlimULs',MaxZ));

Xslider=uicontrol('Parent', hfig,'Style', 'slider','Units','normalized',... 
                  'Min',MinX,'Max',MaxX,'Value',xMean, ...
                  'Position', [0.2 0.01 0.2 0.05],...
                  'Tag','Xslider',...
                  'Callback',@X_slider_callback);

Yslider=uicontrol('Parent', hfig,'Style', 'slider','Units','normalized',... 
                  'Min',MinY,'Max',MaxY,'Value',yMean, ...
                  'Position', [0.45 0.01 0.2 0.05],...
                  'Tag','Yslider',...
                  'Callback',@Y_slider_callback);

Zslider=uicontrol('Parent', hfig,'Style', 'slider','Units','normalized',... 
                  'Min',MinZ,'Max',MaxZ,'Value',zMean, ...
                  'Position', [0.7 0.01 0.2 0.05],...
                  'Tag','Zslider',...
                  'Callback',@Z_slider_callback);
                  
EditBox=uicontrol('Parent', hfig,'Style', 'edit','Units','normalized',...
                  'Position',[0.05 0.01 .1 .05],...
                  'String','2',...
                  'FontWeight','bold',...
                  'FontSize',15,...
                  'Tag','EditBox1',...
                  'Callback',@EditBox_callback);    
              
PushButton=uicontrol('Parent',hfig,'Style','push','String','Reset','Units','normalized',...
                     'Position',[0.03 0.1 .14 0.06],'FontWeight','bold','FontSize',15,...
                     'Tag','PushButton','Callback',@PushButton_callback); 
                 
FigFour=figure(4);
boxplot(ClusterSizeSaver,'Labels',{'Generated clusters'});
ylabel('Number of Cu atoms')
TITLE1=['Total number of clusters is ' num2str(TotalNumberOfClusters)];
TITLE2=['MinClusSize=' num2str(min(ClusterSizeSaver)) '  AvgClusSize= ' num2str(mean(ClusterSizeSaver)) '  MaxClusSize= ' num2str(max(ClusterSizeSaver))];
TITLE4=['Min. distance between cluster centers before delocalization=' num2str(MinDistBtwnClusters) ' (nm)'];
TITLE5=['Cu con. in Solid solution is ' num2str(100*CuCencentrationInSS) '%, and Cu con. in clusters is ' num2str(100*CuConcentrationInCluster) '%']; 

title({TITLE1;TITLE2;TITLE4;TITLE5})
saveas(FigFour,'0_GeneratedClusterSizeDistribution.tiff')
%close(FigFour)
temp=[NameOfTheOutputFiles '_GnrtdClstrCntrAndSize.txt'];
fid0 = fopen(temp,'wt');
for i=1:size(Xcluster,1)
    PRINT=[Xcluster(i,1),Ycluster(i,1),Zcluster(i,1),ClusterSizeSaver(i,1)];
    fprintf(fid0, '%10.5f\t %10.5f\t %10.5f\t %6i\n', PRINT);
end
fclose(fid0);

if exist('GeneratedDatasetResults','dir')==7
    rmdir GeneratedDatasetResults s
end
mkdir GeneratedDatasetResults
movefile *.tiff GeneratedDatasetResults
movefile *.fig GeneratedDatasetResults
%movefile Iman_AllatomsInDatSet.txt GeneratedDatasetResults
movefile *.txt GeneratedDatasetResults
movefile(tempPos, 'GeneratedDatasetResults')
%Only functions must be below this line, otherwise the code crashes.

function []=PushButton_callback(hObject, eventdata)
    data=guidata(hObject);
    guidata(hObject,data);
    xlim([data.xlimLLs data.xlimULs])
    ylim([data.ylimLLs data.ylimULs])
    zlim([data.zlimLLs data.zlimULs])
    pbaspect([1 1 1])
end

function []=EditBox_callback(hObject, eventdata)
    data=guidata(hObject);
    data.Resolution=str2double(get(hObject,'String'));
    guidata(hObject,data);
end

function []=X_slider_callback(hObject, eventdata)
    data=guidata(hObject);
    data.xlimLL=hObject.Value;
    guidata(hObject,data);
    xlim([data.xlimLL data.xlimLL+data.Resolution])
    ylim([data.ylimLLs data.ylimULs])
    zlim([data.zlimLLs data.zlimULs])
    pbaspect([data.Resolution/(data.xlimULs-data.xlimLLs) 1 1])
end

function []=Y_slider_callback(hObject, eventdata)
    data=guidata(hObject);
    data.ylimLL=hObject.Value;
    guidata(hObject,data);
    xlim([data.xlimLLs data.xlimULs])
    ylim([data.ylimLL data.ylimLL+data.Resolution])
    zlim([data.zlimLLs data.zlimULs])
    pbaspect([1 (data.Resolution/(data.ylimULs-data.ylimLLs)) 1])
end

function []=Z_slider_callback(hObject, eventdata)
    data=guidata(hObject);
    data.zlimLL=hObject.Value;
    guidata(hObject,data);
    xlim([data.xlimLLs data.xlimULs])
    ylim([data.ylimLLs data.ylimULs])
    zlim([data.zlimLL data.zlimLL+data.Resolution])
    pbaspect([1 1 (data.Resolution/(data.zlimULs-data.zlimLLs))])
end


