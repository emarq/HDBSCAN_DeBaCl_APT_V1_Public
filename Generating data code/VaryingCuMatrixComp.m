%Changing the concentration of Cu in the matrix
function [XSave,YSave,ZSave,massSave,clusterIDsave]=VaryingCuMatrixComp(X,Y,Z,mass,clusterID,CuMatrixCompGradient)

NumberOfIntervals=200;
%--------------------------
xMin=min(X(:,1));
xMax=max(X(:,1));

Xsections = linspace(xMin,xMax,NumberOfIntervals);
MatrixCompSections=linspace(CuMatrixCompGradient(1,1),CuMatrixCompGradient(1,2),NumberOfIntervals);
XSave=[];
YSave=[];
ZSave=[];
massSave=[];
clusterIDsave=[];
for i=1:size(Xsections,2)-1
    if i==(size(Xsections,2)-1)
        [row,~]=find(X(:,1)>=Xsections(1,i) & X(:,1)<=Xsections(1,i+1) & mass(:,1)==65);
    else
        [row,~]=find(X(:,1)>=Xsections(1,i) & X(:,1)<Xsections(1,i+1) & mass(:,1)==65);
    end
    AveMatrixSecComp=(MatrixCompSections(1,i)+MatrixCompSections(1,i+1))/2;
    nSel=round(0.01*AveMatrixSecComp*size(row,1));
    tempSel=randperm(size(row,1),nSel);
    SelID=row(tempSel,1);
    XSave=[XSave;X(SelID,1)];
    YSave=[YSave;Y(SelID,1)];
    ZSave=[ZSave;Z(SelID,1)];
    massSave=[massSave;mass(SelID,1)];
    clusterIDsave=[clusterIDsave;clusterID(SelID,1)];
end
[row,~]=find(mass(:,1)==63 | mass(:,1)==27); %Adding all the Cu in the cluster and Fe in the matrix to the dataset
XSave=[XSave;X(row(:,1),1)];
YSave=[YSave;Y(row(:,1),1)];
ZSave=[ZSave;Z(row(:,1),1)];
massSave=[massSave;mass(row(:,1),1)];
clusterIDsave=[clusterIDsave;clusterID(row(:,1),1)];


end