clc
clear all;
close all;

%% 7. CodeBook and Indexing of Improved Dense Trajectroy Features

SampleRate =20;

nDESC=1000000;
DESC_DB_Traj =zeros(nDESC,30);
DESC_DB_HOG = zeros(nDESC,96);
DESC_DB_HOF = zeros(nDESC,108);
DESC_DB_MBH = zeros(nDESC,192);


iDESC0 = 0;
Action_PATH='.../Data/DatasetName/DatasetName_iDTF_mat';
All_Action=dir(Action_PATH);
All_Action=All_Action(3:end);

missing=0;
for iAction =1:length(All_Action)
 
    ActionPath = [Action_PATH,'/',All_Action(iAction).name];
    All_files=dir(ActionPath);

    All_files=All_files(1: end);
    
    for iFile =1: length(All_files)
 
     
        [kk,mm,nn]=fileparts([ActionPath,'/',All_files(iFile).name]);
        if(length(mm)==0 || length(mm)==1)
        
            continue;
        end
        
          
          
       File_Path=[ActionPath,'/',All_files(iFile).name];
       

       try
       load( File_Path);
  
       catch
       
       error('????')
           
       end
       
 
       for iDESC = 1:SampleRate:length(descFeat)
            iDESC0 = iDESC0 + 1
             
           if norm(descFeat(iDESC).hog)>0
               mbhXX=descFeat(iDESC).mbh_x;
               mbhYY=descFeat(iDESC).mbh_y;
               
               mbhXX=mbhXX/norm(mbhXX);
               mbhYY=mbhYY/norm(mbhYY);

               DESC_DB_Traj(iDESC0,:) =  [descFeat(iDESC).trajectory_norm/norm(descFeat(iDESC).trajectory_norm)];
               DESC_DB_HOG(iDESC0,:) =  [descFeat(iDESC).hog/norm(descFeat(iDESC).hog)];
               DESC_DB_HOF(iDESC0,:) =  [descFeat(iDESC).hof/norm(descFeat(iDESC).hof)];
               DESC_DB_MBH(iDESC0,:) =  [mbhXX,mbhYY];
           end
        
        
       end
        
       end
end

k =2000;

DESC_DB = DESC_DB_Traj(1:iDESC0,:);

vq_max_iterations = 10;
vq_verbosity = 0;
cluster_options.maxiters = vq_max_iterations;
cluster_options.verbose  = vq_verbosity;
[CX,sse] = vgg_kmeans_MT(DESC_DB', k, cluster_options);
save('CodeBook_2000_DatasetName_Traj','CX')


DESC_DB = DESC_DB_HOG(1:iDESC0,:);
vq_max_iterations = 10;
vq_verbosity = 0;
cluster_options.maxiters = vq_max_iterations;
cluster_options.verbose  = vq_verbosity;
[CX,sse] = vgg_kmeans_MT(DESC_DB', k, cluster_options);
save('CodeBook_2000_DatasetName_HOG','CX')




DESC_DB = DESC_DB_HOF(1:iDESC0,:);
vq_max_iterations = 10;
vq_verbosity = 0;
cluster_options.maxiters = vq_max_iterations;
cluster_options.verbose  = vq_verbosity;
[CX,sse] = vgg_kmeans_MT(DESC_DB', k, cluster_options);
save('CodeBook_2000_DatasetName_HOF','CX')


DESC_DB = DESC_DB_MBH(1:iDESC0,:);
vq_max_iterations = 10;
vq_verbosity = 0;
cluster_options.maxiters = vq_max_iterations;
cluster_options.verbose  = vq_verbosity;
[CX,sse] = vgg_kmeans_MT(DESC_DB', k, cluster_options);
save('CodeBook_2000_DatasetName_MBH','CX')
% 



% 
% % Traj

clear all;close all;clc;

addpath(genpath('.../Code/flann-1.6.11-src'));

load CodeBook_2000_DatasetName_Traj

nCode = size(CX,2);
MaxIndexVal = 0.2;

if length(find(isnan(CX)))>0
    
   error('Error') 
end
build_params = struct ...
    ( ...
    'algorithm', 'kmeans', ...
    'target_precision', .99 ...
    );

dataset = double(CX);

[index, parameters, speedup] = flann_build_index(dataset, build_params);





DIVMATRootPath ='.../Data/DatasetName/DatasetName_iDTF_mat';
IndexRootPath = sprintf('.../Data/DatasetName/DatasetName_Index_Traj_2000');
 if ~exist(IndexRootPath,'dir')
       mkdir(IndexRootPath);
 end
    
  All_Actions=dir(DIVMATRootPath);
  All_Actions=All_Actions(3:end);
  missing=0
for iAction =1:length(All_Actions)
 
    
    MBHActionPath = [DIVMATRootPath,'/',All_Actions(iAction).name];
    IndexActionPath = [IndexRootPath,'/',All_Actions(iAction).name];
    
    if ~exist(IndexActionPath,'dir')
        mkdir(IndexActionPath);
    end
    
    All_files=dir(MBHActionPath);
    All_files=All_files(1:1:end);
    
    for iFile = 1:length(All_files)
     
        [kk,mm,nn]=fileparts([MBHActionPath,'/',All_files(iFile).name]);
        if(length(mm)==0 || length(mm)==1)
        
            continue;
        end
          iFile         
      
       File_Path=[MBHActionPath,'/',All_files(iFile).name];
       IndexFile_Path=[IndexActionPath,'/',All_files(iFile).name];
         
 
       
      
       try
       load( File_Path);
  
       catch
       
     error('????')
           
       end
    
       raw_Info_Orignal= zeros(length(descFeat),3);
       Traj_Orignal=zeros(length(descFeat),30);

     for iDESC = 1:length(descFeat)
              
               Traj_Orignal(iDESC,:)=descFeat(iDESC).trajectory_norm/norm(descFeat(iDESC).trajectory_norm);
               
               raw_Info_Orignal(iDESC,:)= [descFeat(iDESC).frameNum,descFeat(iDESC).mean_x, descFeat(iDESC).mean_y];  
             
               
     end

  
 
%%
Norm_DESC=double(Traj_Orignal');
[MBHIndex, dists] = flann_search(index, Norm_DESC, 1, parameters);
Indexes=[MBHIndex', raw_Info_Orignal];

   
save(IndexFile_Path,'Indexes');
        
        clear Norm_DESC;
        
    end
    
    
end





%% HOG

clear all;close all;clc;

addpath(genpath('.../Code/flann-1.6.11-src'));

load CodeBook_2000_DatasetName_HOG

nCode = size(CX,2);
MaxIndexVal = 0.2;
if length(find(isnan(CX)))>0
    
   error('Error') 
end

    
build_params = struct ...
    ( ...
    'algorithm', 'kmeans', ...
    'target_precision', .99 ...
    );

dataset = double(CX);

[index, parameters, speedup] = flann_build_index(dataset, build_params);

 
DIVMATRootPath ='.../Data/DatasetName/DatasetName_iDTF_mat';
IndexRootPath = sprintf('.../Data/DatasetName/DatasetName_Index_HOG_2000');
    if ~exist(IndexRootPath,'dir')
        mkdir(IndexRootPath);
    end
    
  All_Actions=dir(DIVMATRootPath);
  All_Actions=All_Actions(3:end);
 
for iAction =1:length(All_Actions)
 
    
    MBHActionPath = [DIVMATRootPath,'/',All_Actions(iAction).name];
    IndexActionPath = [IndexRootPath,'/',All_Actions(iAction).name];
    
    if ~exist(IndexActionPath,'dir')
        mkdir(IndexActionPath);
    end
    
    All_files=dir(MBHActionPath);
    All_files=All_files(1:1:end);
    
    
    for iFile = 1:length(All_files)
     
        [kk,mm,nn]=fileparts([MBHActionPath,'/',All_files(iFile).name]);
        if(length(mm)==0 || length(mm)==1)
        
            continue;
        end
          iFile         
   
       File_Path=[MBHActionPath,'/',All_files(iFile).name];
       IndexFile_Path=[IndexActionPath,'/',All_files(iFile).name];
         
     try
       load( File_Path);
  
       catch
       
     error('????')
           
       end
    
       raw_Info_Orignal= zeros(length(descFeat),3);
       HOG_Orignal=zeros(length(descFeat),96);


     for iDESC = 1:length(descFeat)
              
               HOG_Orignal(iDESC,:) =  [descFeat(iDESC).hog/norm(descFeat(iDESC).hog)];
               
               raw_Info_Orignal(iDESC,:)= [descFeat(iDESC).frameNum,descFeat(iDESC).mean_x, descFeat(iDESC).mean_y];  
             
               
     end
  
  
 
%%
Norm_DESC=double(HOG_Orignal');
[MBHIndex, dists] = flann_search(index, Norm_DESC, 1, parameters);
Indexes=[MBHIndex', raw_Info_Orignal];
 
save(IndexFile_Path,'Indexes');
        
        clear Norm_DESC;
        
    end
    
    
end




%% HOF

clear all;close all;clc;

addpath(genpath('.../Code/flann-1.6.11-src'));

load CodeBook_2000_DatasetName_HOF

nCode = size(CX,2);
MaxIndexVal = 0.2;
if length(find(isnan(CX)))>0
    
   error('Error') 
end

build_params = struct ...
    ( ...
    'algorithm', 'kmeans', ...
    'target_precision', .99 ...
    );

dataset = double(CX);

[index, parameters, speedup] = flann_build_index(dataset, build_params);

 
DIVMATRootPath ='.../Data/DatasetName/DatasetName_iDTF_mat';
IndexRootPath = sprintf('.../Data/DatasetName/DatasetName_Index_HOF_2000');
    if ~exist(IndexRootPath,'dir')
        mkdir(IndexRootPath);
    end
    
  All_Actions=dir(DIVMATRootPath);
  All_Actions=All_Actions(3:end);
  missing=0
for iAction =1:length(All_Actions)
 
    
    MBHActionPath = [DIVMATRootPath,'/',All_Actions(iAction).name];
    IndexActionPath = [IndexRootPath,'/',All_Actions(iAction).name];
    
    if ~exist(IndexActionPath,'dir')
        mkdir(IndexActionPath);
    end
    
    All_files=dir(MBHActionPath);
    All_files=All_files(1:1:end);
    
    
    for iFile = 1:length(All_files)
     
        [kk,mm,nn]=fileparts([MBHActionPath,'/',All_files(iFile).name]);
        if(length(mm)==0 || length(mm)==1)
        
            continue;
        end
          iFile         

       File_Path=[MBHActionPath,'/',All_files(iFile).name];
       IndexFile_Path=[IndexActionPath,'/',All_files(iFile).name];
         
 
      try
       load( File_Path);
  
       catch
       
     error('????')
           
       end
    
       raw_Info_Orignal= zeros(length(descFeat),3);
        HOF_Orignal=zeros(length(descFeat),108);



     for iDESC = 1:length(descFeat)
              
               HOF_Orignal(iDESC,:) =  [descFeat(iDESC).hof/norm(descFeat(iDESC).hof)];
               
               raw_Info_Orignal(iDESC,:)= [descFeat(iDESC).frameNum,descFeat(iDESC).mean_x, descFeat(iDESC).mean_y];  
             
               
     end
  

  
 
%%
Norm_DESC=double(HOF_Orignal');
[MBHIndex, dists] = flann_search(index, Norm_DESC, 1, parameters);
Indexes=[MBHIndex', raw_Info_Orignal];

  
      save(IndexFile_Path,'Indexes');
        
        clear Norm_DESC;
        
    end
    
    
end




%% MBH

clear all;close all;clc;

addpath(genpath('.../Code/flann-1.6.11-src'));

load CodeBook_2000_DatasetName_MBH

nCode = size(CX,2);
MaxIndexVal = 0.2;

if length(find(isnan(CX)))>0
    
   error('Error') 
end

build_params = struct ...
    ( ...
    'algorithm', 'kmeans', ...
    'target_precision', .99 ...
    );

dataset = double(CX);

[index, parameters, speedup] = flann_build_index(dataset, build_params);

 
DIVMATRootPath ='.../Data/DatasetName/DatasetName_iDTF_mat';
IndexRootPath = sprintf('.../Data/DatasetName/DatasetName_Index_MBH_2000');
    if ~exist(IndexRootPath,'dir')
        mkdir(IndexRootPath);
    end
    
  All_Actions=dir(DIVMATRootPath);
  All_Actions=All_Actions(3:end);
 
for iAction =1:length(All_Actions)
 
    
    MBHActionPath = [DIVMATRootPath,'/',All_Actions(iAction).name];
    IndexActionPath = [IndexRootPath,'/',All_Actions(iAction).name];
    
    if ~exist(IndexActionPath,'dir')
        mkdir(IndexActionPath);
    end
    
    All_files=dir(MBHActionPath);
    All_files=All_files(1:1:end);
    
    
    for iFile = 1:length(All_files)
     
        [kk,mm,nn]=fileparts([MBHActionPath,'/',All_files(iFile).name]);
        if(length(mm)==0 || length(mm)==1)
        
            continue;
        end
          iFile         
    
       File_Path=[MBHActionPath,'/',All_files(iFile).name];
       IndexFile_Path=[IndexActionPath,'/',All_files(iFile).name];
         
      try
       load( File_Path);
  
       catch
       
     error('????')
           
        end
       
        
        
        raw_Info_Orignal= zeros(length(descFeat),3);
         MBH_Orignal=zeros(length(descFeat),192);



     for iDESC = 1:length(descFeat)
              
                mbhXX=descFeat(iDESC).mbh_x;
               mbhYY=descFeat(iDESC).mbh_y;
               
               mbhXX=mbhXX/norm(mbhXX);
               mbhYY=mbhYY/norm(mbhYY);
               
               
               MBH_Orignal(iDESC,:)=[mbhXX,mbhYY];

               
               raw_Info_Orignal(iDESC,:)= [descFeat(iDESC).frameNum,descFeat(iDESC).mean_x, descFeat(iDESC).mean_y];  
             
               
     end
  
  
 
 
%%
Norm_DESC=double(MBH_Orignal');
[MBHIndex, dists] = flann_search(index, Norm_DESC, 1, parameters);
Indexes=[MBHIndex', raw_Info_Orignal];
 
      save(IndexFile_Path,'Indexes');
        
        clear Norm_DESC HOG_Orignal HOF_Orignal Traj_Orignal MBH_Orignal raw_Info_Orignal;
        
    end
    
    
end

