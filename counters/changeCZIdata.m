function [pics, Xdist, Zdist, errEv] = changeCZIdata(path)

% Reads and tranforms the data, if all 4 of the channels are recorded.
% Otherwise returns empty and prompts error.
errEv = 0;
data = bfopen(path);
metadata = data{1,2};
chNum = metadata.get('Global Information|Image|SizeC #1');

if ~isempty(chNum)
    chNum = str2num(chNum);
else
    chNum = 1;
end

if chNum == 4
    assignin('base','data',data)
    pics = nan(1,4,size(data{1,1},1)/4,size(data{1,1}{1,1},1),size(data{1,1}{1,1},2));
    
    for i = 4:4:size(data{1,1},1)
        pics(1,1,i/4,:,:) = data{1,1}{i,1};
    end
    for i = 1:4:size(data{1,1},1)
        pics(1,4,(i+3)/4,:,:) = data{1,1}{i,1};
    end
    for i = 2:4:size(data{1,1},1)
        pics(1,3,(i+2)/4,:,:) = data{1,1}{i,1};
    end
    for i = 3:4:size(data{1,1},1)
        pics(1,2,(i+1)/4,:,:) = data{1,1}{i,1};
    end
    
    distZ = metadata.get('Global Scaling|Distance|Value #3');
    distX = metadata.get('Global Scaling|Distance|Value #1');
    Zdist = str2double(distZ)*1e6;
    Xdist = str2double(distX)*1e6;
else
    errEv = 1;
    pics = [];
    Zdist = [];
    Xdist = [];
    return
end

