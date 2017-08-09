clc
clear all
close all

%% 1. This code is to compute Saliency in each frame of the video. This code assume that videos are already been saved as images.
%% To directly compute over the videos, use video reader to read video frames. 


%%

All_Videos_Path = '../Data/DatasetName/Dataset_frames';
Result_Saliency_Path = '../Data/DatasetName/Dataset_Saliency';
    if ~exist(Result_Saliency_Path,'dir')
        mkdir(Result_Saliency_Path);
    end
   
All_Videos=dir(All_Videos_Path);
All_Videos=All_Videos(3:end);

for ivideo =1:length(All_Videos)

       
    Video_Path = [All_Videos_Path,'/',All_Videos(ivideo).name];
    Result_Path = [Result_Saliency_Path,'/',All_Videos(ivideo).name];
    ivideo 
    
     if exist( [Result_Path,'.mat'],'file')
        continue;
     
     end
% %     


         All_images=dir(Video_Path);
         All_images=All_images(3:end);
         %All_frames=min(length(All_images),150);
         All_frames=length(All_images);
                  
    fname=cell(1,All_frames);
    
        for iImage=1:1:All_frames

            fname{iImage}=([Video_Path,'/',All_images(iImage).name]);
        end
   
          N = length(fname);

% compute the saliency maps for this sequence

% param = makeGBVSParams; % get default GBVS params
% param.channels = 'IF';  % but compute only 'I' instensity and 'F' flicker channels
% param.levels = 3;       % reduce # of levels for speedup
% 
% motinfo = [];           % previous frame information, initialized to empty
Saliency_Map=cell(1,N);
for i = 1 : N
i
  
    out = gbvs( fname{i});
    
    Saliency_Map{i}=single(out.master_map_resized);
    
end
        tic
      save(Result_Path,'Saliency_Map');
      toc
end
        
