clc
clear all
close all


BBX50MS_Path='../Data/DatasetName/BBX50MS_DatasetName';
Shape_Similarity_Path='../Data/DatasetName/ShapeSimilarity';
if ~exist(Shape_Similarity_Path,'dir')
    
    mkdir(Shape_Similarity_Path)
end

All_Actions=dir(BBX50MS_Path);
All_Actions=All_Actions(3:end);
     
 
for iAction=1:length(All_Actions)
     
    Action_Path=[BBX50MS_Path,'/',All_Actions(iAction).name];
    ActionResult=[Shape_Similarity_Path,'/',All_Actions(iAction).name];
     
    if exist( ActionResult)
       continue; 
    end
    
    All_Files=dir(Action_Path);
    All_Files=All_Files(3:end);
    Num_Top_Prop=100;
    
    All_BBX=cell(1,Num_Top_Prop*length(All_Files));
    cc=0;
 
    for iFile=1:length(All_Files)

         iFile
         
         BBX50=[ Action_Path,'/',All_Files(iFile).name];
         load(BBX50)
       
         %Num_Top_Prop is the number of top ranked propsoals after MAP based optimization. 
         Num_Top_Prop=100;
         
         [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
         t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
         Top_BBX=Top_BBX(:,:,t_b_idx1);
         nBBX=length(t_b_idx1);
         
          for ic=1:nBBX
              cc=cc+1;
             All_BBX{cc}=  Top_BBX(:,:,ic);
          end
         
         if nBBX<Num_Top_Prop
             for mm=1:(Num_Top_Prop-nBBX)
               cc=cc+1;
               All_BBX{cc}= Top_BBX(:,:,1);
              end
          end
          
          clear Tublets_raw_cluster
         end
     
     
      if cc<   Num_Top_Prop*length(All_Files)

         error('????') 
      end
     
  
    Dist_BBX=zeros(cc,cc);

    for itub1=1:1:cc
        tic
itub1
            Prop1=All_BBX{itub1};
            Prop1=Prop1(:,3:4);
            Prop1=zero2one(Prop1);
            Tub1=Prop1(:,1)./Prop1(:,2);
         
        for itub2=itub1:1:cc

            if isempty(All_BBX{itub1})|| isempty(All_BBX{itub2})
            
                Dist_BBX(itub1,itub2)=Inf;
         else
                
            Prop2=All_BBX{itub2};
            Prop2=Prop2(:,3:4);
            Prop2=zero2one(Prop2);
            
            Tub2=Prop2(:,1)./Prop2(:,2);
            w=round(min(length(Tub1),length(Tub2))/10);
            cost=dtw_c(Tub1,Tub2,w);
            Dist_BBX(itub1,itub2)=cost;
            end
         end
        toc
    end
 
save(ActionResult,'Dist_BBX');
clear Dist_BBX
end
