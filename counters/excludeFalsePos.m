function [red, green, dist1, dist2] = excludeFalsePos(red, green)

dist1 = [];
dist2 = [];
for i = 1:size(red,1)
    vicinity = green(green(:,1) >= (red(i,1)-1) & green(:,1) <= (red(i,1)+1),:);
    dist = (vicinity(:,2)-red(i,2)).^2 + (vicinity(:,3)-red(i,3)).^2;
    if ~isempty(dist)
        if min(dist) > 10 || isempty(dist)
            red(i,:) = zeros(1,4);
        else
            dist1 = [dist1; min(dist)];
        end
    else
        red(i,:) = zeros(1,4);
    end
end

red = unique(red,'rows');

for i = 1:size(red,1)
    if sum(red(i,:)) == 0
        red(i,:) = [];
        break;
    end
end

for i = 1:size(green,1)
    vicinity = red(red(:,1) >= (green(i,1)-1) & red(:,1) <= (green(i,1)+1),:);
    dist = (vicinity(:,2)-green(i,2)).^2 + (vicinity(:,3)-green(i,3)).^2; 
    if ~isempty(dist)
        if min(dist) > 10
            green(i,:) = zeros(1,4);
        else
            dist2= [dist2; min(dist)];
        end
    else
        green(i,:) = zeros(1,4);
    end
end

green = unique(green,'rows');

for i = 1:size(green,1)
    if sum(green(i,:)) == 0
        green(i,:) = [];
        break;
    end
end