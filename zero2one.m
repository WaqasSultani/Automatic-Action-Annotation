function [out] = zero2one(im)
% Converts matrices with NaNs to Zeros

if(size(im,3) == 1)
    
    temp = im(:);
    pts = find(temp==0);
    temp(pts) =1;
    out = reshape(temp, size(im,1), size(im,2));
    
else
    
    temp = im(:);
    pts = isnan(temp);
    temp(pts) =10000;
    out = reshape(temp, size(im,1), size(im,2), size(im,3));
end

