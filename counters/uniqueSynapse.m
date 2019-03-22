function vals = uniqueSynapse(centroids, lays,dist)

for i = 1:length(lays)-dist
    for j = (i+dist):length(lays)
        if abs(lays(i)-lays(j)) <= dist && ((centroids(i,1)-centroids(j,1))^2 + (centroids(i,2) - centroids(j,2))^2) <= 5
            if centroids(i,3)>centroids(j,3)
                centroids(j,:) = zeros(1,3);
                lays(j) = 0;
            else
                centroids(i,:) = zeros(1,3);
                lays(i) = 0;
            end
%         elseif abs(lays(i)-lays(j)) == 0 && ((centroids(i,1)-centroids(j,1))^2 + (centroids(i,2) - centroids(j,2))^2) <= 5
%             if centroids(i,3)>centroids(j,3)
%                 centroids(j,:) = zeros(1,3);
%                 lays(j) = 0;
%             else
%                 centroids(i,:) = zeros(1,3);
%                 lays(i) = 0;
%             end
        end
    end
end

vals = [lays centroids];
vals = unique(vals,'rows');

for i = 1:size(vals,1)
    if sum(vals(i,:)) == 0
        vals(i,:) = [];
        break;
    end
end