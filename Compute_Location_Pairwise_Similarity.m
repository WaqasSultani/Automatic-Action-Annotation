clc
clear all
close all
 
BBX50MS_Path='../Data/DatasetName/BBX50MS_DatasetName';
Location_Similarity_Path='../Data/DatasetName/LocationSimilarity';
 
if ~exist(Location_Similarity_Path,'dir')
    
    mkdir(Location_Similarity_Path)
end

 
All_Actions=dir(BBX50MS_Path);
All_Actions=All_Actions(3:end);
       
g_L= location_Prior_Prob;      

for iAction=1:length(All_Actions)
     
 
    ActionPath=[BBX50MS_Path,'/',All_Actions(iAction).name];
    All_Files=dir([ActionPath,'/*.mat']);
 
    nFiles=length(All_Files);
    
     
     File_Clus=cell(1,nFiles);
     % Num_Top_Prop is the number of top ranked propsoals after MAP based optimization. 
     Num_Top_Prop=100;
     All_BBX=cell(1,Num_Top_Prop*nFiles);
         
   cc=0;
     for iFile=1:nFiles

         iFile
         
         BBX50=[ActionPath,'/',All_Files(iFile).name];
         All_Files(iFile).name
         load(BBX50)
        
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
     
     
      if cc<   Num_Top_Prop*nFiles

         error('????') 
      end
     
  
       Gauss_BBX=zeros(cc,cc);

       Loc_Info=zeros(1,cc);
       Length_Info=zeros(1,cc);
       
    for itub1=1:1:cc
itub1
            Prop1=All_BBX{itub1};
            nfr=find(Prop1(:,1))';
            Loc_prior1=zeros(1,length(nfr));
            kk=0;
            for ii=nfr
                c1=Prop1(ii,1);
                c2=Prop1(ii,1)+Prop1(ii,3);
                r1=Prop1(ii,2);
                r2=Prop1(ii,2)+Prop1(ii,4);
                Loc_row=round(mean(r1:r2));
                Loc_col=round(mean(c1:c2));
                kk=kk+1;
                Loc_prior1(kk)=g_L(Loc_row,Loc_col);

            end
            
            n1=length(Prop1(:,1));
            n2=length(nfr);
            length_Prior1=exp(-10*(n1-n2)/n1);
            
             Length_Info(itub1)=length_Prior1;
             Loc_Info(itub1)=mean(Loc_prior1);
             
    end
      
    Length_Info=Length_Info';
    Loc_Info=Loc_Info';
     
    Length_Prior=single(Length_Info*Length_Info');
    Loc_Prior=single(Loc_Info*Loc_Info');
    
     
Video_ResultBBX=[Location_Similarity_Path,'/',All_Actions(iAction).name];

save(Video_ResultBBX,'Loc_Prior','Length_Prior');
clear Loc_Prior Length_Prior
end