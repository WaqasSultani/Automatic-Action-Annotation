function [stat] = doMAPForward_W(B, S,stat)

if isempty(B)
    fprintf('Empty proposal set.\n');
    stat = [];
    return;
end
nB = size(B,3);
if nargin == 2 || isempty(stat)
    % initialization
    stat.W = [];
    stat.Xp = []; % optimal w_{ij} given the output set
    stat.X = zeros(nB,1); % assignment
    % construct W
    [stat.W, stat.Xp] = getW_W(B, S);
    stat.BGp = stat.Xp;
    stat.nms = zeros(size(B,3),1);
    stat.f = sum(stat.Xp);
    stat.O = [];
end

%% loop

param.maxnum=nB;
while numel(stat.O) < min(param.maxnum, nB)
    V = max(stat.W - repmat(stat.Xp, [1 nB]),0);
    [score, vote] = max(sum(V) + stat.nms(:)');
    if score == 0 % no supporters
        break
    end
    
     param.phi=log(0.3);
     param.gamma=0.001;
    tmpf = stat.f + score + param.phi;
    
    if (tmpf > stat.f) 
        mask = V(:,vote) > 0;
        stat.X(mask) = vote;
        stat.O(end + 1) = vote;
        stat.Xp(mask) = stat.W(mask,vote);
        stat.f = tmpf;

        stat.nms = stat.nms + ...
             param.gamma*getNMSPenalty_W(B, B(:,:,vote));
    else
        break
    end
end








