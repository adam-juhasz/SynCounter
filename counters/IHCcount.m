function centroids = IHCcount(~, ~, valRed, data, Xdist, ~)

%parameters
nucleiRadius = 7; % nucleus size (um)
avgVal = 0.3135; % 0.31 - 0.37
steepness = 14; % 7 - 20 / Steepness of the sigmoid function
p3 = 0.25; % 0.1 - 0.9 / Shift of the sigmoid function
th = 0.6; % Arbitrary threshold of the pixel intensity
circleSize = round(nucleiRadius/Xdist/2);
circleSizeCentroid = round(circleSize/2);

width = round(nucleiRadius/Xdist); % width of the ROI of the IHC layer

picErosionDilation = data(1,3,:,:,:);
picErosionDilation = reshape(picErosionDilation, [size(data,3) size(data,4) size(data,5)]);
picDilationErosion = nan(size(picErosionDilation));


% Nullifying synapse values, and noise canceling with dilation and erosion
se = strel('disk', 5);
for i = 1:size(picErosionDilation,1)
    thPic = reshape(picErosionDilation(i,:,:), [size(picErosionDilation,2) size(picErosionDilation,3)]);
    if exist('valRed', 'var')
        synsLay = valRed(valRed(:,1) >= i-2 & valRed(:,1) <= i+2,:);
        for j = 1:size(synsLay,1)
            limits = [valRed(j,2)-2 valRed(j,2)+2 valRed(j,3)-2 valRed(j,3)+2];
            limits(limits > size(picErosionDilation,2)) = size(picErosionDilation,2);
            limits(limits < 1) = 1;
            thPic(limits(1):limits(2), limits(3):limits(4)) = zeros(limits(2)-limits(1) + 1,limits(4)-limits(3) + 1);
        end
    else
        warning('Synapses are not loaded');
    end
    thPicTemp = imerode(thPic, se);
    thPicTemp = imdilate(thPicTemp, se);
    
    
    picErosionDilation(i,:,:) = thPicTemp;
    
    thPicTemp = imdilate(thPic, se);
    thPicTemp = imerode(thPicTemp, se);
    picDilationErosion(i,:,:) = thPicTemp;
end

brightPic = im2double(reshape(max(picErosionDilation,[],1), [size(picErosionDilation,2) size(picErosionDilation,3)]));

% Finding the position of the IHC layer on the image based of the maximum
% projection by summing the pixel values of each row and finding the
% maximum
sumgraph = sum(brightPic,2);

[~,b] = max(sumgraph(101:end-100));
b=b+100;

% Normalising the pixel intensity values, and applying a sigmoid function
IHCsigmoid = brightPic* 1/max(brightPic,[],'all');
curve = followCurve(IHCsigmoid,b);
top = min(curve);
bottom = max(curve);
if b+width > size(IHCsigmoid,1)
    b = size(IHCsigmoid,1)-width;
end

brightPic = im2double(reshape(max(picDilationErosion,[],1), [size(picDilationErosion,2) size(picDilationErosion,3)]));
IHCsigmoid = brightPic* 1/max(brightPic,[],'all');
IHCsigmoid = IHCsigmoid * (avgVal/mean(mean(IHCsigmoid(b-width:b+width,:))));
sigmoidPic = 256.* (1./(1+exp(steepness*(-1).*(IHCsigmoid-p3))));

% Applying a 2D moving average in a round window with 'circleSize' pixel radius

densityPic = nan(size(sigmoidPic));
parfor i = 1:size(sigmoidPic,1)
    summaVector = [];
    for j = 1:size(sigmoidPic,2)
        pixNum = 0;
        summa = 0;
        for k = (i-circleSize):(i+circleSize)
            for l = (j-circleSize):(j+circleSize)
                dist = sqrt((i-k)^2+(j-l)^2);
                if dist > circleSize
                    continue;
                elseif k < 1 || l < 1 || k > size(sigmoidPic,1) || l > size(sigmoidPic,2)
                    pixNum = pixNum + 1;
                    continue;
                else
                    summa = summa + sigmoidPic(k,l);
                    pixNum = pixNum + 1;
                end
            end
        end
        summa = summa / pixNum;
        summaVector =[summaVector summa];
    end
    densityPic(i,:) = summaVector;
end

% Cutting out the section containing the IHC layer, and normalising the
% pixel intensity values after applying the sigmoid function
curveLayer = densityPic(top-width:bottom+width,:);

for x = 1:length(curve)
    for y= 1:size(curveLayer,1)
        if (curve(x)-(top-width)) > y+width || (curve(x)-(top-width)) < y-width
            curveLayer(y,x) = 0;
        end
    end
end

IHClayer = curveLayer*(1/max(curveLayer,[],'all'));

% Threshold for nullifying to low intensity values
thIHClayer = IHClayer > th;

% Finding local maximums on the moving averaged IHC layer image
centroids = [];
iValues = 1:5:size(thIHClayer,1);

parfor idx = 1:numel(iValues)
    i = iValues(idx);
    centers = [];
    for j = 1:5:size(thIHClayer,2)
        summa = 0;
        pixNum = 0;
        for k = (i-circleSizeCentroid):(i+circleSizeCentroid)
            for l = (j-circleSizeCentroid):(j+circleSizeCentroid)
                dist = sqrt((i-k)^2+(j-l)^2);
                if dist > circleSizeCentroid*2
                    continue;
                elseif k < 1 || l < 1 || k > size(thIHClayer,1) || l > size(thIHClayer,2)
                    pixNum = pixNum + 1;
                    continue;
                else
                    summa = summa + thIHClayer(k,l);
                    pixNum = pixNum + 1;
                end
            end
        end
        summa = summa / pixNum;
        if summa > 0.6
            [c1, c2] = findMaxCentr(i,j,IHClayer,circleSizeCentroid);
            if isempty(centers)
                if c2 > circleSizeCentroid && c2 < (size(IHClayer,2)-circleSizeCentroid)
                    centers = [c1 c2];
                end
            else
                if c2 > 10 && c2 < (size(IHClayer,2)-10) && c1 > 5 && c1 < (size(IHClayer,1)-5)
                    if mean(IHClayer(c1-5:c1+5,c2-5:c2+5),'all') > max(IHClayer,[],'all')*0.7
                        centers = [centers; [c1 c2]];
                    end
                end
                
            end
        end
    end
    centroids = [centroids; centers];
end
centroids = unique(centroids,'rows');
temp = centroids(:,1);
centroids(:,1) = centroids(:,2);
centroids(:,2) = temp+top-width;

% Determining Z location centres of the found centroids
layer = [];
for c = 1:size(centroids,1)
    if centroids(c,2)-30 < 1
        begY = 1;
    else
        begY = centroids(c,2)-30;
    end
    if centroids(c,2)+30 > size(picErosionDilation,2)
        endY = size(picErosionDilation,2);
    else
        endY = centroids(c,2) +30;
    end
    
    if centroids(c,1)-30 < 1
        begX = 1;
    else
        begX = centroids(c,1)-30;
    end
    if centroids(c,1)+30 > size(picErosionDilation,3)
        endX = size(picErosionDilation,3);
    else
        endX = centroids(c,1) +30;
    end
    lay = 0;
    valLayer = 0;
    for i = 1:size(picErosionDilation,1)
        if i-2 < 1
            begL = 1;
        else
            begL = i-2;
        end
        if i+2 > size(picErosionDilation,1)
            endL = size(picErosionDilation,1);
        else
            endL = i+2;
        end
               
        tempVal = sum(picErosionDilation(begL:endL,begY:endY,begX:endX),'all');
        if tempVal > valLayer
            valLayer = tempVal;
            lay = i;
        end
    end
    layer = [layer; lay];
end
centroids = [centroids layer];