function disappearAddedPair(gcbo, EventData, app)
pairNum = get(gcbo, 'UserData');

buttonNum = EventData.Button;
if buttonNum == 3
    set(app.preSyn(pairNum), 'Visible', 'off');
    set(app.postSyn(pairNum), 'Visible', 'off');
    app.synCentroids(pairNum,end) = 0;
end
end