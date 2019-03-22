function curve = followCurve(IHCsigmoid,m)
    maxVal = max(IHCsigmoid,[],'all');
    curve = zeros(size(IHCsigmoid,2),1);
    [~,sp] = max(sum(IHCsigmoid(m-20:m+20,:),1));
    curve(sp)=m;
    p = 50;
    if sp < size(IHCsigmoid,2)-10
        for i = (sp+1):10:size(IHCsigmoid,2)-50
            above = mean(IHCsigmoid(curve(i-1)-20:curve(i-1),i:i+49),'all');
            below = mean(IHCsigmoid(curve(i-1):curve(i-1)+20,i:i+49),'all');
            change = round((below-above)/maxVal*p);
            if change > 10
                change = 10;
            elseif change < -10
                change = -10;
            end
            curve(i:i+9) = repmat(curve(i-1)+change,10,1);
        end
    end
    if sp > 10
        for i = (sp-1):(-10):50
            above = mean(IHCsigmoid(curve(i+1)-20:curve(i+1),i-49:i),'all');
            below = mean(IHCsigmoid(curve(i+1):curve(i+1)+20,i-49:i),'all');
            change = round((below-above)/maxVal*p);
            if change > 10
                change = 10;
            elseif change < -10
                change = -10;
            end
            curve(i-9:i) = repmat(curve(i+1)+change,10,1);
        end
    end
    curve(1:50) = repmat(curve(51),50,1);
    curve(end-49:end) = repmat(curve(end-50),50,1);
    
%     figure;
%     imagesc(IHCsigmoid)
%     hold on;
%     plot(1:size(IHCsigmoid,1),curve,'k')
%     plot(1:size(IHCsigmoid,1),curve-50, 'g')
%     plot(1:size(IHCsigmoid,1),curve+50, 'g')
    