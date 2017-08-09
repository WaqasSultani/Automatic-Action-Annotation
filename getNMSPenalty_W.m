function p = getNMSPenalty_W(B,b)

% p = -0.5*(getMaxIncFloat(B',b)+getIOUFloat(B',b));

    p=zeros(size(B,3),1);
    sz=size(B(:,:,1),1);
    
    C=permute(B,[1 3 2]);
    C=reshape(C,[],size(B,2),1);
    
     M1 =bboxOverlapRatio(zero2one(b),zero2one(C));
     M2 =bboxOverlapRatio(zero2one(b),zero2one(C),'min'); 
     ti=1;
       for j=1:1:size(B,3)
j
            p(j)=-0.5*(sum(diag(M1(:,ti:ti+sz-1)))/sz+sum(diag(M2(:,ti:ti+sz-1)))/sz);
            ti=ti+sz;
       end
    
%     for j=1:1:size(B,3)
%         j
%         try
%      p(j) = -0.5*(compute_overlap(B(:,:,j),b)+compute_overlapMaxInc(B(:,:,j),b));
%      
%         catch
%            keyboard 
%         end
%     end
