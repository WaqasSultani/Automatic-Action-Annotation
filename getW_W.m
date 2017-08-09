%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Precompute all w_{ij}
% Xp is the likelihood of the optimal assignments given 
% the current output set 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [W, Xp] = getW_W(B, S)

P = zeros(size(B,3));
C=permute(B,[1 3 2]);
C=reshape(C,[],size(B,2),1);
sz=size(B(:,:,1),1);

C=zero2one(C);
B=zero2one(B);


    for i = 1:size(B,3)
    i
        M =bboxOverlapRatio(zero2one(B(:,:,i)),C);
        ti=1;
       for j=1:1:size(B,3)

            P(i,j)=sum(diag(M(:,ti:ti+sz-1)))/sz;
            ti=ti+sz;
       end
    end


param.lambda=0.075;
P = bsxfun(@times, P, S(:));
P = [P param.lambda*ones(size(B,3),1)];
P = bsxfun(@times, P, 1./sum(P,2));
W = log(P);
Xp = W(:,end);
W = W(:,1:end-1);