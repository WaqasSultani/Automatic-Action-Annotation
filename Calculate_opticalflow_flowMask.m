clc
clear all
close all

%% 2. This code is to compute optical_flow Mask in each frame of the video. This code assume that videos are already been saved as images.
%% To directly compute over the videos, use video reader to read video frames. 


All_Videos_Path =  '../Data/DatasetName/Dataset_frames';
All_Optical_Path='../Data/DatasetName/Motion_Mask';

if ~exist(All_Optical_Path)

	mkdir(All_Optical_Path);
end

All_Videos_files=dir(All_Videos_Path);
All_Videos_files=All_Videos_files(3:end);


for ivideo= 1:ength(All_Videos_files)
     ivideo
    Video_Path=[All_Videos_Path,'/',All_Videos_files(ivideo).name]
    Op_file_Path=[All_Optical_Path,'/',All_Videos_files(ivideo).name];
    
    if exist(Op_file_Path)
       
        continue
    else
       
        mkdir(Op_file_Path)
        
    end
  
    
    
    All_images=dir(Video_Path);
    All_images=All_images(3:end);
    SM_Mask=zeros(240,320,length(All_images)-1);
    for Im=1:length(All_images)-1
        Im
        I1=imread([Video_Path,'/',All_images(Im).name]);
        I2=imread([Video_Path,'/',All_images(Im+1).name]);
        
        im1 = double(imresize(I1,[240,320]));
        im2 = double(imresize(I2,[240,320]));
        tic
        flow = mex_LDOF(im1,im2);
        u=flow(:,:,1);
        v=flow(:,:,2);
        toc
        [xFX, xFY]=gradient(u,1);
        [yFX, yFY]=gradient(v,1);
        SM  =sqrt(xFX.*xFX+xFY.*xFY+yFX.*yFX+yFY.*yFY);
        SM_Mask(:,:,Im)=SM;
   end
        
        SM_Mask=single(SM_Mask);
        save(Op_file_Path,'SM_Mask');
      
      clear flow u v  SM_Mask
end
    
    
    
  
 
