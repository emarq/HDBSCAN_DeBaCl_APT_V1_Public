%APT detection efficiency is applied to the dataset
%  1-eff atoms are removed randomly

function [XSave,YSave,ZSave,massSave,clusterIDSave]=ApplyDetectionEfficiency(X,Y,Z,mass,clusterID,eff)

NumberOfIntervals=200;
%---------------------------
if eff(1,2)-eff(1,1)==0
    N=size(X,1);
    Neff=randperm(N,floor(eff(1,1)*N));
    XSave=X(Neff,1);
    YSave=Y(Neff,1);
    ZSave=Z(Neff,1);
    massSave=mass(Neff,1);
    clusterIDSave=clusterID(Neff,1);
    return
end

xMin=min(X(:,1));
xMax=max(X(:,1));
Xsections=linspace(xMin,xMax,NumberOfIntervals);
EffiSections=linspace(eff(1,1),eff(1,2),NumberOfIntervals);

XSave=[];
YSave=[];
ZSave=[];
massSave=[];
clusterIDSave=[];

for i=1:size(Xsections,2)-1
    if i==(size(Xsections,2)-1)
        [row,~]=find(X(:,1)>=Xsections(1,i) & X(:,1)<=Xsections(1,i+1));
    else
        [row,~]=find(X(:,1)>=Xsections(1,i) & X(:,1)<Xsections(1,i+1));
    end
    
    AveEffi=(EffiSections(1,i)+EffiSections(1,i+1))/2;
    nSel=round(AveEffi*size(row,1));
    tempSel=randperm(size(row,1),nSel);
    SelID=row(tempSel,1);
    XSave=[XSave;X(SelID,1)];
    YSave=[YSave;Y(SelID,1)];
    ZSave=[ZSave;Z(SelID,1)];
    massSave=[massSave;mass(SelID,1)];
    clusterIDSave=[clusterIDSave;clusterID(SelID,1)];
    
end