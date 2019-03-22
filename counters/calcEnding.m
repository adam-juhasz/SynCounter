function coords = calcEnding(centroid, pixNumH, pixNumW, layNum, h, w, d)
    if centroid(2)-h < 1
        begY = 1;
    else
        begY = centroid(2)-h;
    end
    if centroid(2)+h > pixNumW
        endY = pixNumW;
    else
        endY = centroid(2) +h;
    end
    %
    if centroid(1)-w < 1
        begX = 1;
    else
        begX = centroid(1)-w;
    end
    if centroid(1)+w > pixNumH
        endX = pixNumH;
    else
        endX = centroid(1) +w;
    end
    %
    if centroid(3)-d < 1
        begL = 1;
    else
        begL = centroid(3)-d;
    end
    if centroid(3)+d > layNum
        endL = layNum;
    else
        endL = centroid(3)+d;
    end
    
    coords = [begX endX begY endY begL endL];
    