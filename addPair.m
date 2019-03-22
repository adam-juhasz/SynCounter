function addPair(~, EventData, val, app)

buttonNum = EventData.Button;
X = round(EventData.IntersectionPoint(1));
Y = round(EventData.IntersectionPoint(2));
if buttonNum == 1
    app.preSyn(size(app.synCentroids,1) + 1) = line(app.UIAxes, X, Y, 'Marker', 'o', 'Color', 'k','MarkerSize', 5, 'LineWidth', 1, 'UserData', size(app.synCentroids,1) + 1 , 'ButtonDownFcn', @disappearAddedPair);
    app.postSyn(size(app.synCentroids,1) + 1) = line(app.UIAxes2, X, Y, 'Marker', 'o', 'Color', 'k','MarkerSize', 5, 'LineWidth', 1, 'UserData', size(app.synCentroids,1) + 1 , 'ButtonDownFcn', @disappearAddedPair);
    app.synCentroids = [app.synCentroids; [val Y X 1]];
end
end