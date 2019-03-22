function [centI, centJ, maxPro] = createMaxPro(coordsJ, coordsI, blue, h, w, d)
    centI = zeros(3,1);
    centJ = zeros(3,1);
    if coordsJ(1) < coordsI(1)
        centJ(1) = w;
        centI(1) = abs(coordsI(1)-coordsJ(1)) +w;
        
        begX = coordsJ(1);
        endX = coordsI(2);
    else
        centI(1) = w;
        centJ(1) = abs(coordsJ(1)-coordsI(1)) + w;
        
        begX = coordsI(1);
        endX = coordsJ(2);
    end
    %
    if coordsJ(3) < coordsI(3)
        centJ(2) = h;
        centI(2) = abs(coordsI(3)-coordsJ(3)) +h;
        
        begY = coordsJ(3);
        endY = coordsI(4);
    else
        centI(2) = h;
        centJ(2) = abs(coordsJ(3)-coordsI(3)) + h;
        
        begY = coordsI(3);
        endY = coordsJ(4);
    end
    %
    if coordsJ(5) < coordsI(5)
        centJ(3) = d;
        centI(3) = abs(coordsI(5)-coordsJ(5)) + d;
        
        begZ = coordsJ(5);
        endZ = coordsI(6);
    else
        centI(3) = d;
        centJ(3) = abs(coordsJ(5)-coordsI(5)) + d;
        
        begZ = coordsI(5);
        endZ = coordsJ(6);
    end
    %
%     disp(size(blue(begZ:endZ, begY:endY, begX:endX)))
%     disp(size(max(blue(begZ:endZ, begY:endY, begX:endX),[],1)))
%     disp([num2str(endY-begY) ' ' num2str(endX-begX)])

    maxPro = reshape(max(blue(begZ:endZ, begY:endY, begX:endX),[],1),[(endY-begY+1) (endX-begX+1)]);