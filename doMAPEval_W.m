%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function evaluate the target function
% given a output window set.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stat = doMAPEval_W(B, S, O, W, BGp)

stat.W = [];
stat.Xp = []; % optimal w_{ij} given the output set
stat.X = zeros(size(B,3),1); % assignment
%if nargin < 6
    % construct W
 %   [stat.W, stat.BGp] = getW_W(B, S);
%else
    stat.W = W;
    stat.BGp = BGp;
%end
stat.nms = zeros(size(B,3),1);
stat.O = O;
param.phi=log(0.3);
param.gamma=1;
stat.f = numel(O)*param.phi;
for i = 1:numel(O)
    stat.f = stat.f + stat.nms(O(i));
    stat.nms = stat.nms + ...
            param.gamma*getNMSPenalty_W(B,B(:,:,O(i)));
end
if isempty(O)
    stat.f = stat.f + sum(BGp);
    return;
end
[Xp,ass] = max(stat.W(:,O),[],2);
mask = Xp > BGp;
stat.X(mask) = ass(mask);
stat.Xp = max(Xp, BGp);
stat.f = stat.f + sum(stat.Xp);





