clc
clear all
close all

%%  4. Before using this code, compute action proposals in each video 
%%  5. This code is to compute motion score for each proposal in the video.
%%    This code assume that smoothed motion mask and action proposals are already computed.
%%    In our experiments, we have used the following action proposal:
%     J. van Gemert,  M. Jain,  G. Ella,  C. Snoek,  Apt:  Action localization proposals from dense trajectories, in: BMVC, 2015, 
%      
%%    This following code use MAP based optimization from
% J. Zhang, S. Sclaroff, Z. Lin, X. Shen, B. Price, R. Mech, Unconstrained salient
% object detection via proposal subset optimization, in: CVPR 2016
% We slightly changed the orignal code. The changed code is included  in
% this folder.


Videos_frame_Path='../Data/DatasetName/DatasetName_frames';
MRF_MS_Path='../Data/DatasetName/DatasetName/Dataset3DMRF';
Video_Proposal_Path='../Data/DatasetName/tube_formated';
BBX50_Path='../Data/DatasetName/BBX50MS_DatasetName';

if ~exist(BBX50_Path,'dir')
   mkdir(BBX50_Path)
end

 
All_Files=dir([Videos_frame_Path]);
All_Files=All_Files(3:end);
    
for ifile=1:length(All_Files)
 
        FilePath_BBX=[Video_Proposal_Path,'/',All_Files(ifile).name]
        FilePath_Mask=[MRF_MS_Path,'/',All_Files(ifile).name];
        FilePath_Result=[BBX50_Path,'/',All_Files(ifile).name];
        FramePath=[Videos_frame_Path,'/',All_Files(ifile).name];
        
        if exist([FilePath_Result,'.mat'],'file')
             disp('FileExistDatasetNameDatasetName')
		
	           continue;
        end
        
        % Num_Top_Prop is the number of top ranked propsoals after MAP based optimization. 
        Num_Top_Prop=100;
             
        
        
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
         
        load(FilePath_BBX);
        
        BBX_Array=zeros(nFr,4,length(BBX));
        
        for ibbx=1:length(BBX)
            ibbx;
            A1=round(BBX{ibbx})';
            A1=A1+1;
            BBX_Frames=A1(:,1)';
            
         for ii=1:nFr
                     In_w=find(A1(:,1)==ii);
                     A=A1(In_w,2:end);
                    
                     if length(A)==0
                        continue; 
                     end
                     
                     A=[A(1) A(2) A(3)-A(1)+1,A(4)-A(2)+1];
                     A(1)=A(1)/col_factor;
                     A(2)=A(2)/row_factor;
                     A(3)=A(3)/col_factor;
                     A(4)=A(4)/row_factor;
                     A=round(A);
            
                     BBX_Array(ii,:,ibbx)=zero2one(A);
        end
        end
        
        load(FilePath_Mask);
        Score=zeros(size(BBX_Array,3),1);
       
        for ibbx=1:size(BBX_Array,3)
            ibbx
            B=BBX_Array(:,:,ibbx);
            C=find(B(:,1));
            mm=C';
            Average_of_Mask=zeros(1,length(mm));
            cc=0;
            
        for kk= mm
              cc=cc+1;
              D=round(B(kk,:));
              final_frame=min(kk,size(Saliency_Matrix_SSCM_3D,3));

              x1=D(1);
              x2=min(D(1)+D(3),320);
              y1=D(2);
              y2=min(D(2)+D(4),240);

              MM=Saliency_Matrix_SSCM_3D(y1:y2,x1:x2,final_frame);
              Area_xy=length(y1:y2)*length(x1:x2);
              Average_of_Mask(cc)=sum(sum(MM))/Area_xy;%*Loc_prior*Size_prior;
        end
        
         Score(ibbx,1)=sum(Average_of_Mask);
         end
        
         [val,idx]=sort(Score(:,1),'descend');
         Pboxes=BBX_Array(:,:,idx);
         Pboxscores=val;
         stat = doMAPForward_W(Pboxes, double(Pboxscores));  
    
         Top_BBX= Pboxes(:,:, stat.O);  
	     Top_BBX_Scores=val(stat.O); 
    
        
	if length(stat.O)<Num_Top_Prop

               AA=setdiff(1:length(idx),stat.O);
               AA1=AA(1:min(100,length(AA)))'; 
               Top_BBX=cat(3,Top_BBX,Pboxes(:,:, AA1));
               Top_BBX_Scores= [Top_BBX_Scores;val(AA1)];
    end 
         save(FilePath_Result,'Top_BBX','Top_BBX_Scores'); 
  end
