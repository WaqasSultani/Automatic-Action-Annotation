clc
clear all
close all

%% 3. This code is to compute smoothed motion saliency in each frame of the video. This code assume that Saliency and optical flow derivatives are already computed


 Sal_Path= '../Data/DatasetName/DatasetName/Dataset_Saliency';
 Mot_Path='../Data/DatasetName/DatasetName/Motion_Mask';
 MRF_Path='../Data/DatasetName/DatasetName/Dataset3DMRF';

if ~exist(MRF_Path,'dir')

    mkdir(MRF_Path)
end
    
 Fra_Path= '../Data/DatasetName/DatasetName/Dataset_frames';

All_Actions=dir(Sal_Path);
All_Actions=All_Actions(3:end);

rows=240;cols=320;
        
for iAction =1 
    sprintf('iAction%d',iAction)
    
    MotActionPath  =  Mot_Path ;
    SalActionPath  =  Sal_Path;
    MRFActionResult = MRF_Path; 
 

    ImageActionPath = Fra_Path; 
    
    All_files=dir(SalActionPath);
    All_files=All_files(3:end);

    for iFile =1:length(All_files)
             
 
 
        
       sprintf('iFile%d',iFile)
       All_image_Path=[ImageActionPath,'/',All_files(iFile).name(1:end-4)];
       All_images=dir(All_image_Path);
       
       
       Mot_File_Path=[MotActionPath,'/',All_files(iFile).name];
       Sal_File_Path=[SalActionPath,'/',All_files(iFile).name];
       MRF_File_Result=[MRFActionResult,'/',All_files(iFile).name];
            
       if exist(MRF_File_Result,'file')
           
           continue;
           disp('File Exist..............')
       else
           
       end
     
       
       load(Sal_File_Path);
       load(Mot_File_Path);
 
      
   
       Saliency_Matrix_SSCM=zeros(rows,cols,size(SM_Mask,3));
 
      tic
         for i=1:1:size(SM_Mask,3)
         
         Scaled_SS_Mask=imresize(Saliency_Map{i},[rows,cols]);
        
         MIN_SS=min(min(Scaled_SS_Mask));
         MAX_SS=max(max(Scaled_SS_Mask));
        
         if MIN_SS==MAX_SS
           Scaled_SS_Mask=SS_Mask(:,:,i); 
         else
           Scaled_SS_Mask=(Scaled_SS_Mask-MIN_SS)/(MAX_SS-MIN_SS);
            
         end

         SM=SM_Mask(:,:,i);
        
       
         MIN_SM=min(min(SM));
         MAX_SM=max(max(SM));
         
        if MIN_SM==MAX_SM
           Scaled_SM_Mask=SM; 
        else
           Scaled_SM_Mask=(SM-MIN_SM)/(MAX_SM-MIN_SM);
            
        end
         
   
           Combine_mask=Scaled_SM_Mask+Scaled_SS_Mask;%.*(Scaled_SC_Mask_b+Scaled_SS_Mask_b);
           loged_Combine_mask=Combine_mask;
           loged_Combine_mask_min=min(min((loged_Combine_mask)));
           loged_Combine_mask_max=max(max((loged_Combine_mask)));
           
           if loged_Combine_mask_min==loged_Combine_mask_max
                 loged_Combine_mask_scaled=zeros(size(loged_Combine_mask)); 
           else
                 loged_Combine_mask_scaled=(loged_Combine_mask-loged_Combine_mask_min)./(loged_Combine_mask_max-loged_Combine_mask_min);
           end
           
            Saliency_Matrix_SSCM(:,:,i)=loged_Combine_mask_scaled*50;
          end
         
          Saliency_Matrix_SSCM=uint16(Saliency_Matrix_SSCM);
          Saliency_Matrix_SSCM_3D=zeros(size(Saliency_Matrix_SSCM));
         
          Total_clips=floor(size(SM_Mask,3)/50);
          Remaining_frames=size(SM_Mask,3)-Total_clips*50;
         
         if Total_clips>0
         
         for iclip=1:1:Total_clips
         iclip
             if iclip==1
                index=(iclip-1)*50+1;
             else
                index=(iclip-1)*50-1;
             end

               if length(find(isnan(Saliency_Matrix_SSCM(:))))>0

			error('NaN')
               end

              
             Saliency_Matrix_SSCM_1=Saliency_Matrix_SSCM(:,:,index:iclip*50);
tic
             Saliency_Matrix_SSCM_1_3D_temp=MRF_3D_restore_Linux(int16(Saliency_Matrix_SSCM_1));
toc   
            Saliency_Matrix_SSCM_1_3D_temp2=zeros(rows,cols,size(Saliency_Matrix_SSCM_1_3D_temp,2));
             for k=1:1:size(Saliency_Matrix_SSCM_1_3D_temp,2)
                  Saliency_Matrix_SSCM_1_3D_temp2(:,:,k)=reshape(Saliency_Matrix_SSCM_1_3D_temp(:,k),[rows, cols]);
             end
              
             Saliency_Matrix_SSCM_3D(:,:,index+1:iclip*50-1) =Saliency_Matrix_SSCM_1_3D_temp2(:,:,2:end-1);
                    
         end
         
         if Remaining_frames>4
            
             iclip=iclip+1;
             index=(iclip-1)*50-1;
             
             Saliency_Matrix_SSCM_1=Saliency_Matrix_SSCM(:,:,index:end);
             Saliency_Matrix_SSCM_1_3D_temp=MRF_3D_restore_Linux(Saliency_Matrix_SSCM_1); 
             
              Saliency_Matrix_SSCM_1_3D_temp2=zeros(rows,cols,size(Saliency_Matrix_SSCM_1_3D_temp,2));
             for k=1:1:size(Saliency_Matrix_SSCM_1_3D_temp,2)
             
             Saliency_Matrix_SSCM_1_3D_temp2(:,:,k)=reshape(Saliency_Matrix_SSCM_1_3D_temp(:,k),[rows, cols]);
             end
             
             
             
             Saliency_Matrix_SSCM_3D(:,:,index+1:size(SM_Mask,3)-1) =Saliency_Matrix_SSCM_1_3D_temp2(:,:,2:end-1);
             Saliency_Matrix_SSCM_3D(:,:,1)=Saliency_Matrix_SSCM(:,:,1);
             Saliency_Matrix_SSCM_3D(:,:,end)=Saliency_Matrix_SSCM(:,:,end);
             
             
         else
             iclip=iclip+1;
             index=(iclip-1)*50;
             Saliency_Matrix_SSCM_3D(:,:,index)= Saliency_Matrix_SSCM(:,:,index);
             Saliency_Matrix_SSCM_3D(:,:,1)=Saliency_Matrix_SSCM(:,:,1);
             Saliency_Matrix_SSCM_3D=Saliency_Matrix_SSCM_3D(:,:,1:index);
             
         end
         end
         
         if Total_clips==0
        
                  
             Saliency_Matrix_SSCM_1_3D_temp=MRF_3D_restore_Linux(Saliency_Matrix_SSCM); 
             Saliency_Matrix_SSCM_1_3D_temp2=zeros(rows,cols,size(Saliency_Matrix_SSCM_1_3D_temp,2));
             for k=1:1:size(Saliency_Matrix_SSCM_1_3D_temp,2)
             
             Saliency_Matrix_SSCM_1_3D_temp2(:,:,k)=reshape(Saliency_Matrix_SSCM_1_3D_temp(:,k),[rows, cols]);
             end
             
                        
             Saliency_Matrix_SSCM_3D(:,:,2:size(SM_Mask,3)-1) =Saliency_Matrix_SSCM_1_3D_temp2(:,:,2:end-1);
             Saliency_Matrix_SSCM_3D(:,:,1)=Saliency_Matrix_SSCM(:,:,1);
             Saliency_Matrix_SSCM_3D(:,:,end)=Saliency_Matrix_SSCM(:,:,end);
            
         
         
         end
         
             Saliency_Matrix_SSCM_3D=single(Saliency_Matrix_SSCM_3D);
             save(MRF_File_Result,'Saliency_Matrix_SSCM_3D');
         
         toc
         
         clear Saliency_Matrix_SSCM_3D Saliency_Matrix_SSCM_3D_temp Saliency_Matrix_SSCM_3D_1

    
    end
end
