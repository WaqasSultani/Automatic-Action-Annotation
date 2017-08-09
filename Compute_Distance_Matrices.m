clc
clear all
close all

AllTraj_Path='../Data/DatasetName/DatasetName_Hist_Traj_2000';
AllMBH_Path='../Data/DatasetName/DatasetName_Hist_MBH_2000';
AllHOF_Path='../Data/DatasetName/DatasetName_Hist_HOF_2000';
AllHOG_Path='../Data/DatasetName/DatasetName_Hist_HOG_2000';

DisMat_Path='../Data/DatasetName/Distance_Matrices_Chi';

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
   
% Num_Top_Prop is the number of top ranked propsoals after MAP based optimization. 
Num_Top_Prop=100; 


Traj_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);
HOG_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);    
HOF_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);
MBH_Hist_All=zeros(length(All_Files)*Num_Top_Prop,10000);

cc=0; for iFile=1:length(All_Files)
      
         iFile
         
         HistPath_Traj=[Traj_Path,'/',All_Files(iFile).name];
         HistPath_HOG=[HOG_Path,'/',All_Files(iFile).name];
         HistPath_HOF=[HOF_Path,'/',All_Files(iFile).name];
         HistPath_MBH=[MBH_Path,'/',All_Files(iFile).name];
       
         Traj=load(HistPath_Traj);
         HOG=load(HistPath_HOG);
         HOF=load(HistPath_HOF);
         MBH=load(HistPath_MBH);
         
         
         % All_Histograms_Tublet contain top ranked histograms
       
         nBBX=size(Traj.All_Histograms_Tublet,1);
        
         for ic=1:nBBX
        
              cc=cc+1;
              
             if sum(Traj.All_Histograms_Tublet(ic,:))~=0
                      % Normalize histogram by L1 norm    
                      Traj_Hist_All(cc,:)=  Traj.All_Histograms_Tublet(ic,:)/sum(Traj.All_Histograms_Tublet(ic,:));
             else
                      % For proposal which are very small or static and does not contain any IDFT features, we are currently
                      % putting 1000 in each bin (so that we can penalize this histogram latter on).
                      Traj_Hist_All(cc,:)=1000*ones(1,10000);

             end
         
         
         
         
             if sum(HOG.All_Histograms_Tublet(ic,:))~=0
         
         
                HOG_Hist_All(cc,:)=  HOG.All_Histograms_Tublet(ic,:)/sum(HOG.All_Histograms_Tublet(ic,:));
             else
                 
                 HOG_Hist_All(cc,:)=1000*ones(1,10000);
             end
             
             
             if sum(HOF.All_Histograms_Tublet(ic,:))~=0
             
               HOF_Hist_All(cc,:)=  HOF.All_Histograms_Tublet(ic,:)/sum(HOF.All_Histograms_Tublet(ic,:));
             
             else
                 
                HOF_Hist_All(cc,:)=1000*ones(1,10000);  
                 
             end
             
             
             if sum(MBH.All_Histograms_Tublet(ic,:))~=0
             
               MBH_Hist_All(cc,:)=  MBH.All_Histograms_Tublet(ic,:)/sum(MBH.All_Histograms_Tublet(ic,:));
    
             else
                 
                 MBH_Hist_All(cc,:)=1000*ones(1,10000);
             end
         
          
         end
            
          
          if nBBX<Num_Top_Prop
             for mm=1:(Num_Top_Prop-nBBX)
             
               cc=cc+1;
                
               
               if sum(Traj.All_Histograms_Tublet(1,:))~=0

                      Traj_Hist_All(cc,:)=  Traj.All_Histograms_Tublet(1,:)/sum(Traj.All_Histograms_Tublet(1,:));
               else
                      Traj_Hist_All(cc,:)=1000*ones(1,10000);

               end
               
               
               
               if sum(HOG.All_Histograms_Tublet(1,:))~=0
         
         
                HOG_Hist_All(cc,:)=  HOG.All_Histograms_Tublet(1,:)/sum(HOG.All_Histograms_Tublet(1,:));
               else
                 
                 HOG_Hist_All(cc,:)=1000*ones(1,10000);
               end
               
               
         
                if sum(HOF.All_Histograms_Tublet(1,:))~=0
             
                 HOF_Hist_All(cc,:)=  HOF.All_Histograms_Tublet(1,:)/sum(HOF.All_Histograms_Tublet(1,:));
             
                else
                 
                 HOF_Hist_All(cc,:)=1000*ones(1,10000);  
                 
                end
                
                 if sum(MBH.All_Histograms_Tublet(1,:))~=0
             
                 MBH_Hist_All(cc,:)=  MBH.All_Histograms_Tublet(1,:)/sum(MBH.All_Histograms_Tublet(1,:));
             
                else
                 
                 MBH_Hist_All(cc,:)=1000*ones(1,10000);  
                 
                 end
                 
                
              end
          
          end
          
          clear Tublets_raw_cluster
               
       end
       
       
Traj_XCHI=zeros(cc,cc);
HOG_XCHI=zeros(cc,cc);
HOF_XCHI=zeros(cc,cc);
MBH_XCHI=zeros(cc,cc);


for xx=1:cc
    xx
    tic
    for yy=xx:cc
      
        
        % Ki-Square Distance.
        hist1=Traj_Hist_All(xx,:);
        hist2=Traj_Hist_All(yy,:);
        result1 = (hist1-hist2).^2;
        result2 = (hist1+hist2)+0.000000001;
        Traj_XCHI(xx,yy) = sum( result1 ./ result2 );
        

        
        hist1=HOG_Hist_All(xx,:);
        hist2=HOG_Hist_All(yy,:);
        result1 = (hist1-hist2).^2;
        result2 = (hist1+hist2)+0.000000001;
        HOG_XCHI(xx,yy) = sum( result1 ./ result2 );
        

        hist1=HOF_Hist_All(xx,:);
        hist2=HOF_Hist_All(yy,:);
        result1 = (hist1-hist2).^2;
        result2 = (hist1+hist2)+0.000000001;
        HOF_XCHI(xx,yy) = sum( result1 ./ result2 );
        

        hist1=MBH_Hist_All(xx,:);
        hist2=MBH_Hist_All(yy,:);
        result1 = (hist1-hist2).^2;
        result2 = (hist1+hist2)+0.000000001;
        MBH_XCHI(xx,yy) = sum( result1 ./ result2 );
         
    end
    toc
end
save(Result_path,'HOF_XCHI','HOG_XCHI','MBH_XCHI','Traj_XCHI')
end
      