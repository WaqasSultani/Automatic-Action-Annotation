function g= location_Prior_Prob

sigma=120;
Col=320;
Row=240;
g=zeros(Row,Col); % initialize the kernel with zeros
cent=[Row/2,Col/2]; % compute where the mean of gaussian should be

for i=1:size(g,1)
    for j=1:size(g,2)
       
        arg= -((i-cent(1))^2+(j-cent(2))^2 )/(2*sigma^2);
        g(i,j)=exp(arg); % gaussian formula
        arg1=(i-cent(1))^2/(2*80^2);
        arg2=(j-cent(2))^2/(2*106^2);
        
        g(i,j)=exp(-1*(arg1+arg2));
        
    end
end
 