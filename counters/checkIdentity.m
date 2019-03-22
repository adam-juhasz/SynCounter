function identity = checkIdentity(maxPro, centI, centJ, intTH)
    identity = 0;
    intI = mean(maxPro(centI(2)-4:centI(2)+4,centI(1)-4:centI(1)+4), 'all');
    intJ = mean(maxPro(centJ(2)-4:centJ(2)+4,centJ(1)-4:centJ(1)+4), 'all');
    
    dist = floor(sqrt((centI(1)-centJ(1))^2 + (centI(2)-centJ(2))^2));
    minIntensity = min([intJ intI]);
            
    for i = 1:dist
        x = centI(1) + round((centJ(1)-centI(1))/dist*i);
        y = centI(2) + round((centJ(2)-centI(2))/dist*i);
        
        intN = mean(maxPro(y-4:y+4,x-4:x+4), 'all');
        if intN < minIntensity
            minIntensity = intN;
        end
    end
    
    if minIntensity > intTH*min([intJ intI])
        identity = 1;
    end