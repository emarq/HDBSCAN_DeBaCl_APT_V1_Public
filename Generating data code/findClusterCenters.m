%Locating the cluster centers
function [ClusterCenters, MinDistBtwnClusters]=findClusterCenters(Xmin,Xmax,Ymin,Ymax,Zmin,Zmax,TotalNumberOfClusters,dseparation,dmax,ClusterSizeInfo)

InitalRandomPointsInSpace=1000000;
%---------------
nXmin=Xmin+dmax;
nYmin=Ymin+dmax;
nZmin=Zmin+dmax;

nXmax=Xmax-dmax;
nYmax=Ymax-dmax;
nZmax=Zmax-dmax;

x=(nXmax-nXmin).*rand(InitalRandomPointsInSpace,1)-(0-nXmin);
y=(nYmax-nYmin).*rand(InitalRandomPointsInSpace,1)-(0-nYmin);
z=(nZmax-nZmin).*rand(InitalRandomPointsInSpace,1)-(0-nZmin);

keeperX=x(1,1);
keeperY=y(1,1);
keeperZ=z(1,1);
counter=2;
minAllowableDistance=dseparation*dmax;
for k=2:InitalRandomPointsInSpace
    thisX=x(k,1);
    thisY=y(k,1);
    thisZ=z(k,1);
    distances = sqrt((thisX-keeperX).^2 + (thisY - keeperY).^2+ (thisZ - keeperZ).^2);
    minDistance = min(distances);
    if minDistance(1,1) >= minAllowableDistance
        keeperX(counter,1) = thisX;
		keeperY(counter,1) = thisY;
        keeperZ(counter,1) = thisZ;
		counter = counter + 1;
    end
end

if size(keeperX,1)<TotalNumberOfClusters
    error('IMAN: Either the volume is not large to make these many cluster centers, or you need to increase "InitalRandomPointsInSpace" in the first line of "findClusterCenters"')  
elseif size(keeperX,1)>TotalNumberOfClusters
    rows=randperm(size(keeperX,1),TotalNumberOfClusters);
    NKx=keeperX(rows,1);
    keeperX=NKx;
    NKy=keeperY(rows,1);
    keeperY=NKy;
    NKz=keeperZ(rows,1);
    keeperZ=NKz;
end
FigOne=figure(1);
plot3(keeperX(:,1), keeperY(:,1),keeperZ(:,1), 'b*');
grid on; 
xlim([Xmin Xmax])
ylim([Ymin Ymax])
zlim([Zmin Zmax])

ClusterCenters=[keeperX(:,1) keeperY(:,1) keeperZ(:,1)];

A=ClusterCenters;
Save=[];
for i=1:(size(A,1)-1)
    for j=(i+1):size(A,1)
        temp=sqrt(((A(i,1)-A(j,1)).^2)+((A(i,2)-A(j,2)).^2)+((A(i,3)-A(j,3)).^2));
        Save=[Save;temp];
    end
end
AA=min(Save(:,1));
MinDistBtwnClusters=AA(1,1);

if size(ClusterSizeInfo,1)==1
    TiTle=cell(1,3);    
    TITLE1=['Total number of generated cluster centers is ' num2str(size(keeperX,1))];
    TiTle{1,1}=TITLE1;
    TITLE3=['Initial Cluster radius=' num2str(ClusterSizeInfo(1,2)) ' (nm), Radius fluctuation=' num2str(ClusterSizeInfo(1,3)) ' (nm), dseparation=' num2str(dseparation)];
    TiTle{1,3}=TITLE3;
    TITLE2=['Min. distance between cluster centers before delocalization=' num2str(MinDistBtwnClusters) ' (nm)'];
    TiTle{1,2}=TITLE2;
else
    TiTle=cell(1,2+size(ClusterSizeInfo,1));
    TITLE1=['Total number of generated cluster centers is ' num2str(size(keeperX,1)) ', dseparation=' num2str(dseparation)];
    TiTle{1,1}=TITLE1;
    TITLE2=['Min. distance between cluster centers before delocalization=' num2str(MinDistBtwnClusters) ' (nm)'];
    TiTle{1,2}=TITLE2;
    for i=1:size(ClusterSizeInfo,1)
        temp=[num2str(ClusterSizeInfo(i,1)) ' clusters with initial Cluster radius of ' num2str(ClusterSizeInfo(i,2)) ' (nm) and Radius fluctuation of ' num2str(ClusterSizeInfo(i,3)) ' (nm)'];
        TiTle{1,i+2}=temp;
    end
end

title(TiTle)
xlabel('X (nm)')
ylabel('Y (nm)')
zlabel('Z (nm)')

if size(ClusterSizeInfo,1)>1
    set(gcf,'Units','Normalized','OuterPosition',[0.05, 0.05, 0.70, 0.95])
end

saveas(FigOne,'0_GeneratedClusterCenters.tiff')
saveas(FigOne,'0_GeneratedClusterCenters.fig')
%close(FigOne)

end
