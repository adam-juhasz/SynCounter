function disappearCell( gcbo, EventData, app)
cellNum = get(gcbo, 'UserData');
buttonNum = EventData.Button;

if isequal(get(gcbo, 'Color'), [0 1 0]) && buttonNum == 3
    set(app.maxPro(cellNum), 'Color', 'r');
    set(app.singleLay(cellNum), 'Color', 'r');
    app.cellCentroids(cellNum,end) = 0;
elseif isequal(get(gcbo, 'Color'), [1 0 0]) && buttonNum == 1
    set(app.maxPro(cellNum), 'Color', 'g');
    set(app.singleLay(cellNum), 'Color', 'g');
    app.cellCentroids(cellNum,end) = 1;
end
end