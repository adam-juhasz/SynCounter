function centroids = OHCcount(~, ~, data, Xdist, ~)


% Determining the OHC ROI
% blueSum: summation by the 2nd dimension of the maximum projection of the 
% blue channel
% redSum: same as blueSum for the red channel
% magentaSum : same as blueSum and redSum for the magenta channel
blueSum = sum(reshape(max(reshape(data(1,1,:,:,:), [size(data,3) size(data,4) size(data,5)]),[],1), [size(data,4) size(data,5)]),2);
redSum = sum(reshape(max(reshape(data(1,3,:,:,:), [size(data,3) size(data,4) size(data,5)]),[],1), [size(data,4) size(data,5)]),2);
magentaSum = sum(reshape(max(reshape(data(1,4,:,:,:), [size(data,3) size(data,4) size(data,5)]),[],1), [size(data,4) size(data,5)]),2);

% presyn: maximum position of resSum (y axis value of the maximum projection)
[~,presyn] = max(redSum);
blueNorm = (blueSum/max(blueSum));
magentaNorm = (magentaSum/max(magentaSum));

blueMagenta = ((-1.3)*blueNorm)+1.3 + magentaNorm;
if presyn < 301
    presyn = 301;
end

[~, maxLine]=max(blueMagenta(presyn-300:presyn));
maxLine = maxLine + presyn - 301;

blue = data(1,1,:,:,:);
blue = reshape(blue, [size(data,3) size(data,4) size(data,5)]);

% Noise canceling using dilation and erosion on the blue channel
se = strel('disk', 5);
for i = 1:size(blue,1)
    thPic = reshape(blue(i,:,:), [size(blue,2) size(blue,3)]);
    thPic = imdilate(thPic, se);
    thPic = imerode(thPic, se);
    blue(i,:,:) = thPic;
end
OHC = double(reshape(max(blue,[],1), [size(blue,2) size(blue,3)]));

% Finding separating curvature for OHC
curve = followSeparationCurve(OHC,maxLine);
[yVal,~] = max(curve);

% In further analyses, only the OHC layer data are loaded with the help of
% the curve.
% noise canceling using dilation and erosion on  pink channel
blue = blue(:,1:yVal,:);
magenta = data(1,4,:,1:yVal,:);
magenta = reshape(magenta, [size(data,3) yVal size(data,5)]);

for i = 1:size(magenta,1)
    thPic = reshape(magenta(i,:,:), [size(magenta,2) size(magenta,3)]);
    thPic = imdilate(thPic, se);
    thPic = imerode(thPic, se);
    magenta(i,:,:) = thPic;
end

% Background noise thresholding with an arbitrary 20% value 
magentaPics = double(magenta);
bluePics = double(blue);

% Calculating the mean of the actual layer and the two neighbouring
% layers for each layer.
movAvgPics = nan(size(bluePics));
movAvgPics2 = nan(size(bluePics));
for lay = 1:(size(bluePics,1))
    if lay == 1
        movAvgPics(lay,:,:) = mean(bluePics(1:2,:,:),1);
        movAvgPics2(lay,:,:) = mean(magentaPics(1:2,:,:),1);
    elseif lay == size(bluePics,1)
        movAvgPics(lay,:,:) = mean(bluePics((lay-1):lay,:,:),1);
        movAvgPics2(lay,:,:) = mean(magentaPics((lay-1):lay,:,:),1);
    else
        movAvgPics(lay,:,:) = mean(bluePics((lay-1):(lay+1),:,:),1);
        movAvgPics2(lay,:,:) = mean(magentaPics((lay-1):(lay+1),:,:),1);
    end    
end
% Pixel-wise multiplication of the blue and pink channel then summation of
% the values in the z-axis. (similarly as in maximum projection)
movAvgPics = movAvgPics.*movAvgPics2;
multipliedPic = reshape(sum(movAvgPics,1), [yVal size(movAvgPics,3)]);
for i = 1:size(multipliedPic,2)
    sepPixel = curve(i);
    for j = size(multipliedPic,1):(-1):1
        if j>sepPixel
            multipliedPic(j,i) = 0;
        end
    end
end

% Moving average with a round windowsize of radius 'circleSize'
circleSize = round(5/Xdist/2);
densityPic = nan(size(multipliedPic));
parfor i = 1:size(multipliedPic,1)
    summaVector = [];
    for j = 1:size(multipliedPic,2)
        pixNum = 0;
        summa = 0;
        for k = (i-circleSize):(i+circleSize)
            for l = (j-circleSize):(j+circleSize)
                dist = sqrt((i-k)^2+(j-l)^2);
                if dist > circleSize
                    continue;
                elseif k < 1 || l < 1 || k > size(multipliedPic,1) || l > size(multipliedPic,2)
                    pixNum = pixNum + 1;
                    continue;
                else
                    summa = summa + multipliedPic(k,l);
                    pixNum = pixNum + 1;
                end
            end
        end
        summa = summa / pixNum;
        summaVector =[summaVector summa];
    end
    densityPic(i,:) = summaVector;
end

% Finding maximum of the moving averaged image.
centroids = [];
iValues = 1:10:size(densityPic,1);
circleSizeAvg = 15;
parfor idx = 1:numel(iValues)
    i = iValues(idx);
    centers = [];
    for j = 1:10:size(densityPic,2)
        [c1, c2, check, val] = findMaxCentr(i,j,densityPic,circleSizeAvg);
        if c2 > circleSizeAvg && c2 < (size(densityPic,2)-circleSizeAvg) && check
            if isempty(centers)
                centers = [c1 c2 val];
            else
                centers = [centers; [c1 c2 val]];
            end
        end
    end
    centroids = [centroids; centers];
end
centroids = unique(centroids,'rows');

% Excluding centroids with closer centres than 30 pixels keeping the
% brighter ones
for i = 1:(size(centroids,1)-1)
    for j = (i+1):size(centroids,1)
        dist = sqrt((centroids(i,1)-centroids(j,1))^2 + (centroids(i,2)-centroids(j,2))^2);
        if dist < 30
            if centroids(j,3) < centroids(i,3)
                centroids(j,:) = centroids(i,:);
            else
                centroids(i,:) = centroids(j,:);
            end
        end
    end
end
centroids = unique(centroids,'rows');

val = centroids(:,3);
centroids = centroids(:,1:2);
temp = centroids(:,1);
centroids(:,1) = centroids(:,2);
centroids(:,2) = temp;

% Thresholding of possible false positives with a threshold value of 0.5% of
% the maximum intensity value of the found centroids.
th = 0.005;
centroids(val< th*max(val),:) = [];

% Determining Z location centres of the found centroids
layer = [];
for c = 1:size(centroids,1)
    if centroids(c,2)-30 < 1
        begY = 1;
    else
        begY = centroids(c,2)-30;
    end
    if centroids(c,2)+30 > size(movAvgPics,2)
        endY = size(movAvgPics,2);
    else
        endY = centroids(c,2) +30;
    end
    
    if centroids(c,1)-30 < 1
        begX = 1;
    else
        begX = centroids(c,1)-30;
    end
    if centroids(c,1)+30 > size(movAvgPics,3)
        endX = size(movAvgPics,3);
    else
        endX = centroids(c,1) +30;
    end
    lay = 0;
    valLayer = 0;
    for i = 1:size(movAvgPics,1)
        if i-2 < 1
            begL = 1;
        else
            begL = i-2;
        end
        if i+2 > size(movAvgPics,1)
            endL = size(movAvgPics,1);
        else
            endL = i+2;
        end
               
        tempVal = sum(movAvgPics(begL:endL,begY:endY,begX:endX), 'all');
        if tempVal > valLayer
            valLayer = tempVal;
            lay = i;
        end
    end
    layer = [layer; lay];
end
centroids = [centroids layer];


% Calculating summed pixel intensities in a certain (x,y,z) vicinity of each
% centroid
w = 20;
h = 20;
d = 2;
intensities = [];
for i = 1:size(centroids,1)
    if centroids(i,2)-h < 1
        begY = 1;
    else
        begY = centroids(i,2)-h;
    end
    if centroids(i,2)+h > size(movAvgPics,2)
        endY = size(movAvgPics,2);
    else
        endY = centroids(i,2) +h;
    end
    
    if centroids(i,1)-w < 1
        begX = 1;
    else
        begX = centroids(i,1)-w;
    end
    if centroids(i,1)+w > size(movAvgPics,3)
        endX = size(movAvgPics,3);
    else
        endX = centroids(i,1) +w;
    end
    if centroids(i,3)-d < 1
        begL = 1;
    else
        begL = centroids(i,3)-d;
    end
    if centroids(i,3)+d > size(movAvgPics,1)
        endL = size(movAvgPics,1);
    else
        endL = centroids(i,3)+d;
    end
    multipliedPic = mean(movAvgPics(begL:endL, begY:endY, begX:endX), 'all');
    blueVal = mean(blue(begL:endL, begY:endY, begX:endX), 'all');
    magentaVal = mean(magenta(begL:endL, begY:endY, begX:endX),'all');
    
    intensities = [intensities; [multipliedPic blueVal magentaVal]];
end

% Normalising the calculated dintensities
for i = 1:size(intensities,2)
    intensities(:,i) = intensities(:,i)/max(intensities(:,i));
end
% Arbitrary 40 % threshold based on the blue channel intensities
for i = size(intensities,1):(-1):1
    if intensities(i,2) <0.4
        centroids(i,:) = [];
    end
end

%In case, a single OHC is counted multiple times due to non-horizontal alignment of
%the cells, only one should be kept
numCell = [];
for intTH = 0.5:0.01:0.9
    keep = findDuplicateCells(centroids, blue, intTH);
    numCell = [numCell; sum(keep)];
end

thArray = 0.5:0.01:0.9;

% Finding the intensity threshold adaptively
tempTh = thArray(1);
finalTh = thArray(1);
horizontalLen = 1;
newLen = 0;
for i = 2:length(numCell)
    if numCell(i) == numCell(i-1)
        newLen = newLen + 1;
    else
        newLen = 1;
        tempTh = thArray(i);
    end
    
    if newLen > horizontalLen
        horizontalLen = newLen;
        finalTh = tempTh;
    end
end

% Using the calculated threshold to eliminate duplicate cell counts
keep = findDuplicateCells(centroids, blue, finalTh);     

for i = length(keep):(-1):1
    if ~keep(i)
        centroids(i,:) = [];
    end
end