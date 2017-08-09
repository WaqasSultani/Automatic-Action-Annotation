clc
clear all
close all

AllTraj_Path='../Data/DatasetName/DatasetName_Hist_Traj_2000';
AllMBH_Path='../Data/DatasetName/DatasetName_Hist_MBH_2000';
AllHOF_Path='../Data/DatasetName/DatasetName_Hist_HOF_2000';
AllHOG_Path='../Data/DatasetName/DatasetName_Hist_HOG_2000';

DisMat_Path='../Data/DatasetName/Distance_Matrices_Chi_zero_idx';

if ~exist(DisMat_Path,'dir')
    mkdir(DisMat_Path)
 
end

All_Actions=dir(AllTraj_Path);
All_Actions=All_Actions(3:end);
 
for iAction=1:length(All_Actions)
  
    Traj_Path=[AllTraj_Path,'/',All_Actions(iAction).name];
    MBH_Path=[AllMBH_Path,'/',All_Actions(iAction).name];
    HOF_Path=[AllHOF_Path,'/',All_Actions(iAction).name];
    HOG_Path=[AllHOG_Path,'/',All_Actions(iAction).name];
    Result_path=[DisMat_Path,'/',All_Actions(iAction).name];
    
   
All_Files=dir(Traj_Path);
All_Files=All_Files(3:end);

Num_Top_Prop=50; 


Traj_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);
HOG_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);    
HOF_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);
MBH_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);


Zero_Idx_Traj=[];
Zero_Idx_HOG=[];
Zero_Idx_HOF=[];
Zero_Idx_MBH=[];


cc=0;
for iFile=1:length(All_Files)

         iFile
         
         HistPath_Traj=[Traj_Path,'/',All_Files(iFile).name];
         HistPath_HOG=[HOG_Path,'/',All_Files(iFile).name];
         HistPath_HOF=[HOF_Path,'/',All_Files(iFile).name];
         HistPath_MBH=[MBH_Path,'/',All_Files(iFile).name];
       
         Traj=load(HistPath_Traj);
         HOG=load(HistPath_HOG);
         HOF=load(HistPath_HOF);
         MBH=load(HistPath_MBH);
          
         nBBX=size(Traj.All_Histograms_Tublet,1);
         
         for ic=1:nBBX
        
              cc=cc+1;
              
             if sum(Traj.All_Histograms_Tublet(ic,:))==0
                   Zero_Idx_Traj=[Zero_Idx_Traj;cc];
              end
         
          
             if sum(HOG.All_Histograms_Tublet(ic,:))==0
                  Zero_Idx_HOG=[Zero_Idx_HOG;cc];
             end
             
             
             if sum(HOF.All_Histograms_Tublet(ic,:))==0
             
               Zero_Idx_HOF=[Zero_Idx_HOF;cc];
             
             end
             
             
             if sum(MBH.All_Histograms_Tublet(ic,:))==0
             
              Zero_Idx_MBH=[Zero_Idx_MBH;cc];
             end
         
         
          end
           
          if nBBX<Num_Top_Prop
             for mm=1:(Num_Top_Prop-nBBX)
             
               cc=cc+1;
                
               
               if sum(Traj.All_Histograms_Tublet(1,:))==0
                      Zero_Idx_Traj=[Zero_Idx_Traj;cc];
              end
               
                
               if sum(HOG.All_Histograms_Tublet(1,:))==0
                      Zero_Idx_HOG=[Zero_Idx_HOG;cc];
               end
               
               
         
                if sum(HOF.All_Histograms_Tublet(1,:))==0
                   Zero_Idx_HOF=[Zero_Idx_HOF;cc];
                end
                
                 if sum(MBH.All_Histograms_Tublet(1,:))==0
                   Zero_Idx_MBH=[Zero_Idx_MBH;cc];
                 end
                 
             end
          
          end
           
          clear Tublets_raw_cluster
  end
       
 % Video_ResultBBX=[DisMat_Path,'/',All_Files(iFile).name(1:end-8)];
save(Result_path,'Zero_Idx_MBH','Zero_Idx_HOG','Zero_Idx_HOF','Zero_Idx_Traj')


end
       
  
       
       
       
       
       