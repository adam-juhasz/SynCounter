function addCell(~, EventData, val, app)

buttonNum = EventData.Button;
X = round(EventData.IntersectionPoint(1));
Y = round(EventData.IntersectionPoint(2));
if buttonNum == 1
    app.maxPro(size(app.cellCentroids,1) + 1) = line(app.UIAxes, X, Y, 'Marker', 'o', 'Color', 'k','MarkerSize', 10, 'LineWidth', 2, 'UserData', size(app.cellCentroids,1) + 1);
    app.singleLay(size(app.cellCentroids,1) + 1) = line(app.UIAxes2, X, Y, 'Marker', 'o', 'Color', 'k','MarkerSize', 10, 'LineWidth', 2, 'UserData', size(app.cellCentroids,1) + 1 , 'ButtonDownFcn', {@disappearAddedCell, app});
    app.cellCentroids = [app.cellCentroids; [X Y val 1]];
end
end