%DeBaCl cluster centers are presented in the dataset
function PlottingDeBaClClusterCentersInAllatoms(Original,DetectedPositionCenterSaver,ColorsForPlot,AxisLimits,IgnorePersistency,hdbscanPersistencyThreshold)
   if IgnorePersistency
        FigNumber=100;%No Need to make the persistancy threshold zero because it is done before calling this function
   else
        FigNumber=0;
    end
hfigo=figure(33+FigNumber);
if size(Original,2)==2
    plot(Original(:,1),Original(:,2),'k.','MarkerSize',2)
    for i=1:size(DetectedPositionCenterSaver,1)
        hold on
        plot(DetectedPositionCenterSaver(i,1),DetectedPositionCenterSaver(i,2),'.','color',ColorsForPlot(i,1:3),'MarkerSize',12)
    end
else
    plot3(Original(:,1),Original(:,2),Original(:,3),'k.','MarkerSize',2)
    for i=1:size(DetectedPositionCenterSaver,1)
        hold on
        plot3(DetectedPositionCenterSaver(i,1),DetectedPositionCenterSaver(i,2),DetectedPositionCenterSaver(i,3),'.','color',ColorsForPlot(i,1:3),'MarkerSize',12)
    end
end
hold off
Title={['Distribution of ' num2str(size(DetectedPositionCenterSaver,1)) ' DeBaCl detected cluster centers in'];...
['the original dataset containing ' num2str(size(Original,1)) ' atoms'];...
['Persistancy threshold is ' num2str(hdbscanPersistencyThreshold)]};
title(Title)

if size(Original,2)==3
    dataset3D=true(1);
end

xlabel('X (nm)')
ylabel('Y (nm)')
xlim([AxisLimits(1,1) AxisLimits(1,2)])
ylim([AxisLimits(2,1) AxisLimits(2,2)])
    
if dataset3D
    zlabel('Z (nm)')
    zlim([AxisLimits(3,1) AxisLimits(3,2)])
end

xlimLL=floor(min(Original(:,1)));
xlimUL=ceil(max(Original(:,1)));
xMean=(xlimLL+xlimUL)/2;

ylimLL=floor(min(Original(:,2)));
ylimUL=ceil(max(Original(:,2)));
yMean=(ylimLL+ylimUL)/2;

if dataset3D
    zlimLL=floor(min(Original(:,3)));
    zlimUL=ceil(max(Original(:,3)));
    zMean=(zlimLL+zlimUL)/2;
end

if dataset3D
    guidata(hfigo,struct('Resolution',2,'xlimLL',xlimLL,'xlimUL',xlimUL,'ylimLL',ylimLL,'ylimUL',ylimUL,'zlimLL',zlimLL,'zlimUL',zlimUL,...
        'xlimLLs',xlimLL,'xlimULs',xlimUL,'ylimLLs',ylimLL,'ylimULs',ylimUL,'zlimLLs',zlimLL,'zlimULs',zlimUL));
else
    guidata(hfigo,struct('Resolution',2,'xlimLL',xlimLL,'xlimUL',xlimUL,'ylimLL',ylimLL,'ylimUL',ylimUL,...
        'xlimLLs',xlimLL,'xlimULs',xlimUL,'ylimLLs',ylimLL,'ylimULs',ylimUL));
end

Xslider=uicontrol('Parent', hfigo,'Style', 'slider','Units','normalized',... 
                  'Min',xlimLL,'Max',xlimUL,'Value',xMean, ...
                  'Position', [0.2 0.01 0.2 0.05],...
                  'Tag','Xslider',...
                  'Callback',@X_slider_callback);

Yslider=uicontrol('Parent', hfigo,'Style', 'slider','Units','normalized',... 
                  'Min',ylimLL,'Max',ylimUL,'Value',yMean, ...
                  'Position', [0.45 0.01 0.2 0.05],...
                  'Tag','Yslider',...
                  'Callback',@Y_slider_callback);
     
if dataset3D
    Zslider=uicontrol('Parent', hfigo,'Style', 'slider','Units','normalized',... 
                      'Min',zlimLL,'Max',zlimUL,'Value',zMean, ...
                      'Position', [0.7 0.01 0.2 0.05],...
                      'Tag','Zslider',...
                      'Callback',@Z_slider_callback);
end
     
     
EditBox=uicontrol('Parent', hfigo,'Style', 'edit','Units','normalized',...
                  'Position',[0.05 0.01 .1 .05],...
                  'String','2',...
                  'FontWeight','bold',...
                  'FontSize',15,...
                  'Tag','EditBox1',...
                  'Callback',@EditBox_callback);    

PushButton=uicontrol('Parent',hfigo,'Style','push','String','Reset','Units','normalized',...
                     'Position',[0.03 0.1 .14 0.06],'FontWeight','bold','FontSize',15,...
                     'Tag','PushButton','Callback',@PushButton_callback);      
                 
set(gcf,'Units','Normalized','OuterPosition',[0.25, 0.07, .65, .92])              
if IgnorePersistency
    saveas(hfigo,'3_DeBaClClusterCentersInAllatoms_NOTconsideringPersistancy.tiff')
%    saveas(hfigo,'3_DeBaClClusterCentersInAllatoms_NOTconsideringPersistancy.fig')
else
    saveas(hfigo,'3_DeBaClClusterCentersInAllatoms_ConsideringPersistancy.tiff')
 %   saveas(hfigo,'3_DeBaClClusterCentersInAllatoms_ConsideringPersistancy.fig')
end

%close(hfigo)
    

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



end