function keep = findDuplicateCells(centroids, blue, intTH)

w = 5;
h = 5;
d = 1;

keep = ones(size(centroids,1),1);
for i = 1:size(centroids,1)-1
   for j = (i+1):size(centroids,1)
       if sqrt((centroids(i,1)-centroids(j,1))^2 + (centroids(i,2)-centroids(j,2))^2) < 150
           cent = centroids(i,:);
           coordsI = calcEnding(cent, size(blue,3), size(blue,2), size(blue,1), h, w, d);
           intI = mean(blue(coordsI(5):coordsI(6), coordsI(3):coordsI(4), coordsI(1):coordsI(2)));
           
           cent = centroids(j,:);
           coordsJ = calcEnding(cent, size(blue,3), size(blue,2), size(blue,1), h, w, d);
           intJ = mean(blue(coordsJ(5):coordsJ(6), coordsJ(3):coordsJ(4), coordsJ(1):coordsJ(2)));
           
           [centI, centJ, maxPro] = createMaxPro(coordsJ, coordsI, blue, h, w, d);
           
           identical = checkIdentity(maxPro, centI, centJ, intTH);
           if identical
               if intI < intJ
                   keep(i) = 0;
               else
                   keep(j) = 0;
               end
           end
       end
   end
end