clc
clear all
close all

 
Proposal_ClustersforHung='../DatasetName/DatasetName_ProposalsClusters';
Similarity_Hung_Path='../DatasetName/DatasetName_Similarity_Hung_6';


if ~exist(Similarity_Hung_Path,'dir')
    mkdir(Similarity_Hung_Path)
end


All_Actions=dir(Proposal_ClustersforHung);
All_Actions=All_Actions(3:end);
 

for iAction=1:length(All_Actions)


    ActionPath=[Proposal_ClustersforHung,'/',All_Actions(iAction).name];
    All_Files=dir([ActionPath,'/*.mat']);
 
    nFiles=length(All_Files);
    
     
     File_Clus=cell(1,nFiles);
     
     
     All_Traj=cell(1,50*nFiles);
     All_MBH=cell(1,50*nFiles);
     All_HOG=cell(1,50*nFiles);
     All_HOF=cell(1,50*nFiles);
     
     Num_clus=6;
     
   cc=0;
     for iFile=1:nFiles

         iFile
         
         Prop_Clus=[ActionPath,'/',All_Files(iFile).name];
         All_Files(iFile).name
         load(Prop_Clus)
        
         
          for ic=1:size(Tublets_raw_cluster_6,2)
        
              cc=cc+1;
              
             All_Traj{cc}= Tublets_raw_cluster_6(ic).Traj;
             All_HOG{cc}=  Tublets_raw_cluster_6(ic).HOG;
             All_HOF{cc}=  Tublets_raw_cluster_6(ic).HOF;
             All_MBH{cc}=  Tublets_raw_cluster_6(ic).MBH;
              
          
          end
            
          
          if size(Tublets_raw_cluster_6,2)<50
              
              for mm=1:(50-size(Tublets_raw_cluster_6,2))
              
             
               cc=cc+1;
              
             All_Traj{cc}= Tublets_raw_cluster_6(1).Traj;
             All_HOG{cc}=  Tublets_raw_cluster_6(1).HOG;
             All_HOF{cc}=  Tublets_raw_cluster_6(1).HOF;
             All_MBH{cc}=  Tublets_raw_cluster_6(1).MBH;
              
              
              
              end
          
          end
          
          
          
          clear Tublets_raw_cluster_6
          
         
              
          end
     
     
      if cc<   50*nFiles

         error('????') 
      end
     
  
Dist_Mat_Traj=zeros(cc,cc);
Dist_Mat_HOG=zeros(cc,cc);
Dist_Mat_HOF=zeros(cc,cc);
Dist_Mat_MBH=zeros(cc,cc);


    for itub1=1:1:cc
        tic
itub1
            Tublet1_Traj=All_Traj{itub1}';
            Tublet1_Traj=Tublet1_Traj(1:end-3,:);
            

            Tublet1_HOG=All_HOG{itub1}';
            Tublet1_HOG=Tublet1_HOG(1:end-3,:);
            
            Tublet1_HOF=All_HOF{itub1}';
            Tublet1_HOF=Tublet1_HOF(1:end-3,:);
            
            
            
            Tublet1_MBH=All_MBH{itub1}';
            Tublet1_MBH=Tublet1_MBH(1:end-3,:);
            
                       
            
        
        for itub2=itub1:1:cc


            if isempty(All_Traj{itub1})|| isempty(All_Traj{itub2})
            
                Dist_Mat_Traj(itub1,itub2)=Inf;
                Dist_Mat_HOG(itub1,itub2)=Inf;
                Dist_Mat_HOF(itub1,itub2)=Inf;
                Dist_Mat_MBH(itub1,itub2)=Inf;
                
                
            else
                
            Tublet2_Traj=All_Traj{itub2}';
            Tublet2_Traj=Tublet2_Traj(1:end-3,:);
            
            Tublet2_HOG=All_HOG{itub2}';
            Tublet2_HOG=Tublet2_HOG(1:end-3,:);
            
            Tublet2_HOF=All_HOF{itub2}';
            Tublet2_HOF=Tublet2_HOF(1:end-3,:);
            
            Tublet2_MBH=All_MBH{itub2}';
            Tublet2_MBH=Tublet2_MBH(1:end-3,:);

            
            Traj_dist=distance(Tublet1_Traj,Tublet2_Traj);

            [assignment,cost] = munkres(Traj_dist);
            Dist_Mat_Traj(itub1,itub2)=cost/Num_clus;

            clear assignment cost
            
            MBH_dist=distance(Tublet1_MBH,Tublet2_MBH);
            [assignment,cost] = munkres(MBH_dist);
            Dist_Mat_MBH(itub1,itub2)=cost/Num_clus;
            clear assignment cost
            
            HOG_dist=distance(Tublet1_HOG,Tublet2_HOG);
            [assignment,cost] = munkres(HOG_dist);
            Dist_Mat_HOG(itub1,itub2)=cost/Num_clus;
            clear assignment cost
            
            
            HOF_dist=distance(Tublet1_HOF,Tublet2_HOF);
            [assignment,cost] = munkres(HOF_dist);
            Dist_Mat_HOF(itub1,itub2)=cost/Num_clus;
            clear assignment cost
            
            end


        end
        toc
    end

    
    
    Dist_Mat_Traj=single(Dist_Mat_Traj);  
    Dist_Mat_MBH=single(Dist_Mat_MBH);
    Dist_Mat_HOG=single(Dist_Mat_HOG); 
    Dist_Mat_HOF=single(Dist_Mat_HOF);
    
    
    
    
Action_ResultBBX=[Similarity_Hung_Path,'/',All_Actions(iAction).name];

save(Action_ResultBBX,'Dist_Mat_HOF','Dist_Mat_HOG','Dist_Mat_MBH','Dist_Mat_Traj'); 
clear Dist_Mat_HOF Dist_Mat_HOG Dist_Mat_MBH Dist_Mat_Traj 
end