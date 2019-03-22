function [pairs, valRed]= testSynapse(~,~,data, Zdist)

sep = 1;
dim2 = size(data,4)-sep+1;
greenCh = reshape(data(1,2,:,sep:end,:), [size(data,3) dim2 size(data,5)]);
redCh = reshape(data(1,3,:,sep:end,:), [size(data,3) dim2 size(data,5)]);
blueCh = reshape(data(1,1,:,sep:end,:), [size(data,3) dim2 size(data,5)]);

movGall = zeros(size(greenCh));
movRall = zeros(size(redCh));

centroidsRed = [];
centroidsGreen = [];
layRed = [];
layGreen = [];

% 1 pixel noise canceling with erosion
pics = zeros(size(redCh));
se = strel('line', 2, 90);
for i = 1:size(redCh,1)
    im = reshape(redCh(i,:,:), [size(redCh,2) size(redCh,3)]);
    im = imerode(im, se);
    pics(i,:,:) = im;
end
maxR = max(max(max(pics)));

for i = 1:size(greenCh,1)
    im = reshape(greenCh(i,:,:), [size(greenCh,2) size(greenCh,3)]);
    im = imerode(im, se);
    pics(i,:,:) = im;
end
maxG = max(max(max(pics)));

for i = 1:size(data,3)
    % r: 2D- array. Image of 1 layer of the red channel (pre-synaptic)
    r = reshape(redCh(i,:,:), [dim2 size(data,5)]);
    % Creates a binary 2D-image with values 1 where r is higher than the
    % 20 % of the maximum value and the area of the object is between 3 and
    % 200 pixels, and 0 otherwise. In r, the original pixel values are kept
    % if the binary image has a value 1 otherwise, changed to 0.
    r(bwareafilt(r > maxR*0.2,[3 200]) == 0) = 0;
    r = double(r);
    
    % 2D moving average with the windowsize of 3-by-3.

    if size(r,1) == 712
        movR = meanImgFiltLSM_mex(r);
    elseif size(r,1) == 1024
        movR = meanImgFiltCZI_mex(r);
    else
        movR = zeros(size(r));
        
        parfor k = 2:size(r,1)-1
            row= [0];
            for l = 2:size(r,2)-1
                row = [row mean(mean(r(k-1:k+1,l-1:l+1)))];
            end
            movR(k,:)= [row 0];
        end
    end
    movRall(i,:,:) = movR;
    
    % Finding local maximas on the moving averaged image.
    centroids = [];
    parfor k = 2:size(r,1)-1
        centers = [];
        for l = 2:size(r,2)-1
            if mean(mean(movR(k-1:k+1,l-1:l+1)))==0
                continue;
            else
                [c1, c2, val] = findMaxSynapse(movR,k,l);
                centers = [centers; [c1 c2 val]];
            end
        end
        centroids = [centroids; centers];
    end
    centroids = unique(centroids,'rows');

    layRed = [layRed; repmat(i, size(centroids,1),1)];
    centroidsRed = [centroidsRed; centroids];
    
    
    % The same for the green channel (post-synaptic)
    g = reshape(greenCh(i,:,:), [dim2 size(data,5)]);

    g(bwareafilt(g > maxG*0.2,[3 200]) == 0) = 0;
    g = double(g);

    if size(g,1) == 712
        movG = meanImgFiltLSM_mex(g);
    elseif size(g,1) == 1024
        movG = meanImgFiltCZI_mex(g);
    else
        movG = zeros(size(g));
        
        parfor k = 2:size(g,1)-1
            row= [0];
            for l = 2:size(g,2)-1
                row = [row mean(mean(g(k-1:k+1,l-1:l+1)))];
            end
            movG(k,:)= [row 0];
        end
    end
    movGall(i,:,:) = movG;
    
    centroids = [];
    parfor k = 2:size(g,1)-1
        centers = [];
        for l = 2:size(g,2)-1
            if mean(mean(movG(k-1:k+1,l-1:l+1)))==0
                continue;
            else
                [c1, c2, val] = findMaxSynapse(movG,k,l);
                centers = [centers; [c1 c2 val]];
            end
        end
        centroids = [centroids; centers];
    end
    centroids = unique(centroids,'rows');
    layGreen = [layGreen; repmat(i, size(centroids,1),1)];
    centroidsGreen = [centroidsGreen; centroids];

end

se = strel('disk', 5);
for i = 1:size(blueCh,1)
    im = reshape(blueCh(i,:,:), [size(blueCh,2) size(blueCh,3)]);
    im = imerode(im, se);
    pics(i,:,:) = im;
end

% Excluding false positive based on vicinity on one channel. If a synaptic
% part is visible on multiple layers, keep the one with the highest
% intensity vlue
compChNum = round(0.7/Zdist);
valRed = uniqueSynapse(centroidsRed, layRed, compChNum);
valGreen = uniqueSynapse(centroidsGreen, layGreen, compChNum);

% Excluding false positive based on vicinity between channels. If a
% synaptic part does not have any synaptic part in a certain vicinity on
% the other channel, then it is excluded.
[valRed, valGreen, ~, ~] = excludeFalsePos(valRed,valGreen);
for n = size(valRed,1):(-1):1
    if valRed(n,2) < 1 || valRed(n,3) < 1
        valRed(n,:) = [];
    end
end

for n = size(valGreen,1):(-1):1
    if valGreen(n,2) < 1 || valGreen(n,3) < 1
        valGreen(n,:) = [];
    end
end

% Pairing synaptic parts based on vicinity
[pairs, valRed] = pairingSynapse(valRed, valGreen);