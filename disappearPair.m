function disappearPair(gcbo, EventData, app)
pairNum = get(gcbo, 'UserData');

buttonNum = EventData.Button;
if isequal(get(gcbo, 'Color'), [0 1 0]) && buttonNum == 3
    set(app.preSyn(pairNum), 'Color', 'r');
    set(app.postSyn(pairNum), 'Color', 'r');
    app.synCentroids(pairNum, end) = 0;
elseif isequal(get(gcbo, 'Color'), [1 0 0]) && buttonNum == 1
    set(app.preSyn(pairNum), 'Color', 'g');
    set(app.postSyn(pairNum), 'Color', 'g');
    app.synCentroids(pairNum, end) = 1;
end