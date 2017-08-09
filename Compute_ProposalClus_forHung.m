clc
clear all
close all

Videos_frame_Path='../Data/DatasetName/DatasetName';
Raw_IDTF_Features='../Data/DatasetName/DatasetName_IDTF';
BBX50MS_Path='../Data/DatasetName/BBX50MS';
Proposal_ClustersforHung='../DatasetName/DatasetName_ProposalsClusters';


All_Files=dir([BBX50MS_Path,'/*.mat']);


if ~exist(Proposal_ClustersforHung,'dir')
    
    mkdir(Proposal_ClustersforHung)
end
 

nFiles=length(All_Files);
     cc=0;
  for iFile=1:nFiles
 
         iFile
         
         Prop_Clus=[Proposal_ClustersforHung,'/',All_Files(iFile).name];
   
          if exist(Prop_Clus,'file')
              disp('FileExist...........')
            
            continue;
          else
              
          end
       
           
         FramePath=[Videos_frame_Path,'/',All_Files(iFile).name(1:end-4)];
        
         All_images=dir([FramePath,'/*.jpg']);
         if length(All_images)==0
         
              All_images=dir([FramePath,'/*.png']);
         end
  
         if length(All_images)==0
         
              All_images=dir([FramePath,'/*.ppm']);
         end
        nFr=length(All_images);
        Image_Path=[FramePath,'/',All_images(10).name];
        I=imread(Image_Path);
       
        col_factor=size(I,2)/320;
        row_factor=size(I,1)/240;
          
       
       filePath_50BBX=[BBX50MS_Path,'/',All_Files(iFile).name];
       load(filePath_50BBX);
       
       filePath_raw=[Raw_IDTF_Features,'/',All_Files(iFile).name];
       load(filePath_raw);
       
      

       raw_Info_Orignal= zeros(length(descFeat),3);
       Traj_Orignal=zeros(length(descFeat),30);
       HOG_Orignal=zeros(length(descFeat),96);
       HOF_Orignal=zeros(length(descFeat),108);
       MBH_Orignal=zeros(length(descFeat),192);
      
       for iDESC = 1:length(descFeat)
           
               mbhXX=descFeat(iDESC).mbh_x;
               mbhYY=descFeat(iDESC).mbh_y;
               
               mbhXX=mbhXX/norm(mbhXX);
               mbhYY=mbhYY/norm(mbhYY);
               
               
               MBH_Orignal(iDESC,:)=[mbhXX,mbhYY];
              
               HOF_Orignal(iDESC,:)=descFeat(iDESC).hof/norm(descFeat(iDESC).hof);
               
               HOG_Orignal(iDESC,:)=descFeat(iDESC).hog/norm(descFeat(iDESC).hog);
               
               Traj_Orignal(iDESC,:)=descFeat(iDESC).trajectory_norm/norm(descFeat(iDESC).trajectory_norm);
               
               raw_Info_Orignal(iDESC,:)= [descFeat(iDESC).frameNum,descFeat(iDESC).mean_x, descFeat(iDESC).mean_y];  
             
               
       end
       
       
       if length(find(isnan(MBH_Orignal(:))))>0
           error('???')
       end
       
       if length(find(isnan(HOF_Orignal(:))))>0
           error('???')
       end
       
       if length(find(isnan(HOG_Orignal(:))))>0
           error('???')
       end
       
       if length(find(isnan(Traj_Orignal(:))))>0
           error('???')
       end
       
       % Num_Top_Prop is the number of top ranked propsoals after MAP based optimization. 
        Num_Top_Prop=100;  
       
       
       Temporal_Info=raw_Info_Orignal(:,1);
       Max_Frames=max(raw_Info_Orignal(:,1));
       
       
        [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
             
        t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
        Top_BBX=Top_BBX(:,:,t_b_idx1);
        nBBX=length(t_b_idx1);
       
       
       Tublets_raw_cluster_6=struct;
 
        
        for itub=1:1:nBBX
            itub
            
            Tublet_MBH=[];
            Tublet_Traj=[];
            Tublet_HOF=[];
            Tublet_HOG=[];
            
            A1=round(Top_BBX(:,:,itub));
            S1=zeros(length(Top_BBX(:,:,itub)),1);
            [BBX_Frames,~]=find(A1(:,1));
              
            D=diff(BBX_Frames);
            f=find(D>5);
            
            min_Tublet_Frames=BBX_Frames(1);
            max_Tublet_Frames=BBX_Frames(end);
            
            
           if length(f)>0
            
                max_Tublet_Frames=BBX_Frames(f(1));  
                
            end
            
            
            
            
            t1=Temporal_Info-14>=min_Tublet_Frames;
            t2=Temporal_Info<=max_Tublet_Frames;
            
            t=logical(t1.*t2);
            if length(find(t))==0
            
            t1=Temporal_Info>=min_Tublet_Frames;
            t2=Temporal_Info<=max_Tublet_Frames;
                
                
                a=0;  
              
              
              
            end
            t=logical(t1.*t2); 
            raw_Info_Tub=raw_Info_Orignal(t,:);
          
            Time_Index=round(raw_Info_Tub(:,1));
            Traj_Tub=Traj_Orignal(t,:);
            HOG_Tub=HOG_Orignal(t,:);
            HOF_Tub=HOF_Orignal(t,:);
            MBH_Tub=MBH_Orignal(t,:);
%             Traj_Frames=[0; unique(Time_Index)];
             clear Traj_Frames
            Traj_Frames=[min_Tublet_Frames:15:max_Tublet_Frames];
            if Traj_Frames(end)~=max_Tublet_Frames
               
                Traj_Frames=[Traj_Frames max_Tublet_Frames];
               
            end
            
            
          
            for it=2:1:length(Traj_Frames)
                
                a=BBX_Frames>=(Traj_Frames(it-1));
                b=BBX_Frames<(Traj_Frames(it));
                
                if it==length(Traj_Frames)
                b=BBX_Frames<=(Traj_Frames(it));
                    
                
                end
                
                c=logical(a.*b);
                
                
                if min_Tublet_Frames>1
                    
                c=logical([zeros(min_Tublet_Frames-1,1);c]);    
                end
                B1=A1(c,1:end);
                B1=zero2one(B1);
               
                col1=max(1,mean(B1(:,1)));
                col2=min(320,mean(B1(:,1))+mean(B1(:,3)));
                row1=max(1,mean(B1(:,2)));
                row2=min(240,mean(B1(:,2))+mean(B1(:,4)));

                
                if col2>320
                   
                    error('??')
                    
                end

                if row2>240
                     keyboard
                    error('??')
                    
                end

                
                
                
                K1=Time_Index<Traj_Frames(it);
                 if it==length(Traj_Frames)
                   K1=Time_Index<=Traj_Frames(it);
                 end
                
                
                K2=(Time_Index)>=Traj_Frames(it-1);
                K=logical(K1.*K2);
     
                Traj_sub_tub=Traj_Tub(K,:);
                HOG_sub_tub=HOG_Tub(K,:);
                HOF_sub_tub=HOF_Tub(K,:);
                MBH2_sub_tub=MBH_Tub(K,:);

        
                Col_Index=round(raw_Info_Tub(K,2));
                Row_Index=round(raw_Info_Tub(K,3));
            
                Col_Index=round(Col_Index/col_factor);
                Row_Index=round(Row_Index/row_factor);
            
                if Col_Index>320
                   error('??') 

                end

                if Row_Index>240

                   error('??') 
                end
                   
               c1=Col_Index>=col1;
               c2=Col_Index<=col2;
               r1=Row_Index>=row1;
               r2=Row_Index<=row2;
               
               cr=logical(c1.*c2.*r1.*r2);
               
               Tub_col=Col_Index(cr);
               Tub_row=Row_Index(cr);
               Tub_time=floor((Traj_Frames(it)-Traj_Frames(it-1))/2);
               Tub_time=Tub_time/max_Tublet_Frames;
               Tub_time=repmat(Tub_time,[length(find(cr)),1]);
               
              Tublet_MBH=[Tublet_MBH;[MBH2_sub_tub(cr,:), Tub_col ,Tub_row,Tub_time]];
              Tublet_Traj=[Tublet_Traj;[Traj_sub_tub(cr,:), Tub_col ,Tub_row,Tub_time]];
              Tublet_HOF=[ Tublet_HOF;[HOF_sub_tub(cr,:), Tub_col ,Tub_row,Tub_time]];
              Tublet_HOG=[Tublet_HOG;[HOG_sub_tub(cr,:), Tub_col ,Tub_row,Tub_time]];
               
              
                clear cr K K1 K2 c1 c2 r1 r2 MBH2 Traj2 HOF2 HOG2 Col_Index Row_Index B1 col1 col2 row1 row2 t t1 t2
            end
 
         
%% 6

   if  size(Tublet_Traj,1)>6
                Num_Clusters=6;
              [idx,Traj_Clus] = kmeans(Tublet_Traj, Num_Clusters);
              Tublets_raw_cluster_6(itub).Traj = Traj_Clus ;
              [idx,HOG_Clus] = kmeans(Tublet_HOG, Num_Clusters);
              Tublets_raw_cluster_6(itub).HOG  = HOG_Clus;
              [idx,HOF_Clus] = kmeans(Tublet_HOF, Num_Clusters);
              Tublets_raw_cluster_6(itub).HOF  = HOF_Clus;
              [idx,MBH_Clus] = kmeans(Tublet_MBH, Num_Clusters);
              Tublets_raw_cluster_6(itub).MBH  = MBH_Clus;
         else
               Tublets_raw_cluster_6(itub).Traj = [];
               Tublets_raw_cluster_6(itub).HOG  = [];
               Tublets_raw_cluster_6(itub).HOF  = [];
               Tublets_raw_cluster_6(itub).MBH  = [];
                   
   end
 

            clear   MBH_Clus HOF_Clus HOG_Clus  Traj_Clus  Tublet_Traj  Tublet_HOG  Tublet_HOF  Tublet_MBH
        end
       
        save(Prop_Clus,'Tublets_raw_cluster_6'); 
        clear  Tublets_raw_cluster_6  
        clear  raw_Info Traj HOG  HOF  MBH desc
       
  end


  
