function disappearAddedCell(gcbo, EventData, app)
cellNum = get(gcbo, 'UserData');

buttonNum = EventData.Button;
if buttonNum == 3
    set(app.maxPro(cellNum), 'Visible', 'off');
    set(app.singleLay(cellNum), 'Visible', 'off');
    app.cellCentroids(cellNum, end) = 0;
end
end