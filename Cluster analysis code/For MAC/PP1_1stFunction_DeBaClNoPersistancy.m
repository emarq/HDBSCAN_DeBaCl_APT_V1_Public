%Post processing DeBaCl results without considering persistancy threshold. 
function PP1_1stFunction_DeBaClNoPersistancy(gnrtdClusCenters,hdbAllClusCenters,hdbSelClusCenters,DaBaClClusCntrNoPersis,AxisLimits,VideoFrameRate,VideoDuration,KNNClusCntrNoPersis,CaptureVideo)
hfigONE=figure(503);
plot3(gnrtdClusCenters(:,1),gnrtdClusCenters(:,2),gnrtdClusCenters(:,3),'rh','MarkerSize',7)
hold on
plot3(hdbAllClusCenters(:,6),hdbAllClusCenters(:,7),hdbAllClusCenters(:,8),'bO','MarkerSize',5)
hold on

plot3(hdbSelClusCenters(:,6),hdbSelClusCenters(:,7),hdbSelClusCenters(:,8),'Og','MarkerSize',7)
hold on

plot3(DaBaClClusCntrNoPersis(:,1),DaBaClClusCntrNoPersis(:,2),DaBaClClusCntrNoPersis(:,3),'.','MarkerSize',8,'color',[0,0,0.1724])
hold on

plot3(KNNClusCntrNoPersis(:,1),KNNClusCntrNoPersis(:,2),KNNClusCntrNoPersis(:,3),'+','MarkerSize',6,'color',[0.5 0.5 0.5])

legend({'Generated','HDBSCAN_-All','HDBSCAN_-Selected','DeBaCl_-NoPersistancy','KNN_-NoPersistancy'},'location','best')

xlabel('X (nm)')
ylabel('Y (nm)')
zlabel('Z (nm)')
title('Generated and detected cluster centers (Not considering persistancy for DeBaCl analysis)')
xlimLL=AxisLimits(1,1);
xlimUL=AxisLimits(1,2);
ylimLL=AxisLimits(2,1);
ylimUL=AxisLimits(2,2);
zlimLL=AxisLimits(3,1);
zlimUL=AxisLimits(3,2);
xMean=(AxisLimits(1,1)+AxisLimits(1,2))/2;
yMean=(AxisLimits(2,1)+AxisLimits(2,2))/2;
zMean=(AxisLimits(3,1)+AxisLimits(3,2))/2;

guidata(hfigONE,struct('Resolution',2,'xlimLL',xlimLL,'xlimUL',xlimUL,'ylimLL',ylimLL,'ylimUL',ylimUL,'zlimLL',zlimLL,'zlimUL',zlimUL,...
        'xlimLLs',xlimLL,'xlimULs',xlimUL,'ylimLLs',ylimLL,'ylimULs',ylimUL,'zlimLLs',zlimLL,'zlimULs',zlimUL));

Xslider=uicontrol('Parent', hfigONE,'Style', 'slider','Units','normalized',... 
                  'Min',xlimLL,'Max',xlimUL,'Value',xMean, ...
                  'Position', [0.2 0.01 0.2 0.05],...
                  'Tag','Xslider',...
                  'Callback',@X_slider_callback);

Yslider=uicontrol('Parent', hfigONE,'Style', 'slider','Units','normalized',... 
                  'Min',ylimLL,'Max',ylimUL,'Value',yMean, ...
                  'Position', [0.45 0.01 0.2 0.05],...
                  'Tag','Yslider',...
                  'Callback',@Y_slider_callback);
     

Zslider=uicontrol('Parent', hfigONE,'Style', 'slider','Units','normalized',... 
                  'Min',zlimLL,'Max',zlimUL,'Value',zMean, ...
                  'Position', [0.7 0.01 0.2 0.05],...
                  'Tag','Zslider',...
                  'Callback',@Z_slider_callback);

EditBox=uicontrol('Parent', hfigONE,'Style', 'edit','Units','normalized',...
                  'Position',[0.05 0.01 .1 .05],...
                  'String','2',...
                  'FontWeight','bold',...
                  'FontSize',15,...
                  'Tag','EditBox1',...
                  'Callback',@EditBox_callback);    
              
PushButton=uicontrol('Parent',hfigONE,'Style','push','String','Reset','Units','normalized',...
                     'Position',[0.03 0.1 .14 0.06],'FontWeight','bold','FontSize',15,...
                     'Tag','PushButton','Callback',@PushButton_callback);  

set(gcf,'Units','Normalized','OuterPosition',[0.25, 0.07, .65, .92])

if CaptureVideo
    OptionZ.FrameRate=VideoFrameRate;
    OptionZ.Duration=VideoDuration;
    OptionZ.Periodic=true;
    CaptureFigVid([-20,10;-110,10;-190,80;-290,10;-380,10], 'PP_1_ClusterCenter_NoDeBaClPersistancy',OptionZ)
end
saveas(hfigONE,'PP_1_ClusterCenter_NoDeBaClPersistancy.tiff')
saveas(hfigONE,'PP_1_ClusterCenter_NoDeBaClPersistancy.fig')
%close(hfigONE)
    
end
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
    pbaspect([(data.Resolution/(data.xlimULs-data.xlimLLs)) 1 1])
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