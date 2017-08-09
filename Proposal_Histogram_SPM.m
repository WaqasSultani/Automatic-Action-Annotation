clc
clear all
close all

Action_Path_20BBX='.../Data/DatasetName/BBX50MS_DatasetNameData';
Action_Path_Indexes='.../Data/DatasetName/DatasetName_Index_Traj_2000';
Action_Path_ResultBBX='.../Data/DatasetName/DatasetName_Hist_Traj_2000';

if ~exist(Action_Path_ResultBBX,'dir')
    
    mkdir(Action_Path_ResultBBX)
end
     
All_Files_BBX=dir(Action_Path_20BBX);
All_Files_BBX=All_Files_BBX(3:end);

 
  for ifile=1:1:length(All_Files_BBX)

        
       filePath_BBX_Result=[ Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
 
       filePath_20BBX=[Action_Path_20BBX,'/',All_Files_BBX(ifile).name];
       load(filePath_20BBX);
       
       filePath_Indexes=[Action_Path_Indexes,'/',All_Files_BBX(ifile).name];
       load(filePath_Indexes);
        Num_Top_Prop=100;
       
        [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
         t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
         Top_BBX=Top_BBX(:,:,t_b_idx1);
         nBBX=length(t_b_idx1);
         
       All_Histograms_Tublet=zeros(nBBX,5*2000);   
       
        Coor_cell=cell(nBBX,1);
        for itub=1:nBBX
            itub
            
              Indexes_Info=Indexes;
              Temporal_Info=Indexes_Info(:,2);
              Max_Frames=max(Indexes_Info(:,2));
              Tublet_Coor=zeros(200000,2);
              Tublet_Indexes=zeros(1,200000);
              Tublet_Indexes_SPM=zeros(4,200000);
              A1=round(Top_BBX(:,:,itub));
           
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
            Indexes_Info=Indexes_Info(t,:);
            Col_Index=round(Indexes_Info(:,3));
            Row_Index=round(Indexes_Info(:,4));
            Time_Index=round(Indexes_Info(:,2));
 
             clear Traj_Frames
            Traj_Frames=[min_Tublet_Frames:15:max_Tublet_Frames];
            if Traj_Frames(end)~=max_Tublet_Frames
               
                Traj_Frames=[Traj_Frames max_Tublet_Frames];
               
            end
            
            
            mm_array=ones(1,4);
            mm=1;
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
%                 K=logical(K1);
                Indexes_Info2=Indexes_Info(K,1);
                Col_Index=round(Indexes_Info(K,3));
                Row_Index=round(Indexes_Info(K,4));
                
                spm_cols=round(linspace(col1,col2,3));
                spm_rows=round(linspace(row1,row2,3));
             %SPM_Hist4=cell(1,4);
             ihist=0;
                for icol=1:2
                    for irow=1:2
                   
               c1=Col_Index>=spm_cols(icol);
               c2=Col_Index<=spm_cols(icol+1);
               r1=Row_Index>=spm_rows(irow);
               r2=Row_Index<=spm_rows(irow+1);
               
               cr=logical(c1.*c2.*r1.*r2);  
            
%                Indexes_Info2(cr)';
               
               ihist=ihist+1;
              Tublet_Indexes_SPM( ihist,mm_array(ihist):mm_array(ihist)+length(find(cr))-1) =Indexes_Info2(cr)';
              mm_array(ihist)=mm_array(ihist)+length(find(cr));
   
               
                    end
                end
    
               c1=Col_Index>=col1;
               c2=Col_Index<=col2;
               r1=Row_Index>=row1;
               r2=Row_Index<=row2;
               
               cr=logical(c1.*c2.*r1.*r2);
             
                Tublet_Indexes(mm:mm+length(find(cr))-1) =Indexes_Info2(cr)';
               
                if ~isempty(Col_Index(cr)) && ~isempty(Row_Index(cr))
                
                Tublet_Coor(mm:mm+length(find(cr))-1,:)=[Col_Index(cr) Row_Index(cr)];
                end
                mm=mm+length(find(cr));
                
                clear cr K K1 K2 c1 c2 r1 r2 Indexes_Info2 Col_Index Row_Index B1 col1 col2 row1 row2 t t1 t2
            end
            
          Tublet_Coor=Tublet_Coor(1:mm-1,:);
          Tublet_Indexes=Tublet_Indexes(1:mm-1);
          Tublet_Indexes_SPM1=Tublet_Indexes_SPM(1,1:mm_array(1)-1);
          Tublet_Indexes_SPM2=Tublet_Indexes_SPM(2,1:mm_array(2)-1);
          Tublet_Indexes_SPM3=Tublet_Indexes_SPM(3,1:mm_array(3)-1);
          Tublet_Indexes_SPM4=Tublet_Indexes_SPM(4,1:mm_array(4)-1);

          Tublet_hist=hist(Tublet_Indexes,[1 :2000]);
          Tublet_hist1=hist(Tublet_Indexes_SPM1,[1 :2000]);
          Tublet_hist2=hist(Tublet_Indexes_SPM2,[1 :2000]);
          Tublet_hist3=hist(Tublet_Indexes_SPM3,[1 :2000]);
          Tublet_hist4=hist(Tublet_Indexes_SPM4,[1 :2000]);
          Coor_cell{itub}=Tublet_Coor;
          clear Tublet_Coor;
          All_Histograms_Tublet(itub,:)=[Tublet_hist,Tublet_hist1,Tublet_hist2,Tublet_hist3,Tublet_hist4];
          
 
         clear t1 t2 t
        end
        
        HistFile_Path=[Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
         
       save(HistFile_Path,'All_Histograms_Tublet','Coor_cell'); 
        clear All_Histograms_Tublet
        
    
       
  end


  
%% HOF 2000
clc
clear all
close all


Action_Path_20BBX='.../Data/DatasetName/BBX50MS_DatasetNameData';
Action_Path_Indexes='.../Data/DatasetName/DatasetName_Index_HOF_2000';
Action_Path_ResultBBX='.../Data/DatasetName/DatasetName_Hist_HOF_2000';

if ~exist(Action_Path_ResultBBX,'dir')
    
    mkdir(Action_Path_ResultBBX)
end


 
     
All_Files_BBX=dir(Action_Path_20BBX);
All_Files_BBX=All_Files_BBX(3:end);

     

  
  for ifile=1:1:length(All_Files_BBX)

        
       filePath_BBX_Result=[ Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
 
       filePath_20BBX=[Action_Path_20BBX,'/',All_Files_BBX(ifile).name];
       load(filePath_20BBX);
       
       filePath_Indexes=[Action_Path_Indexes,'/',All_Files_BBX(ifile).name];
       load(filePath_Indexes);
      
        Num_Top_Prop=100;
       
        [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
             
        t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
        Top_BBX=Top_BBX(:,:,t_b_idx1);
        nBBX=length(t_b_idx1);
        
        
        
       All_Histograms_Tublet=zeros(nBBX,5*2000);   
       
        Coor_cell=cell(nBBX,1);
        for itub=1:nBBX
            itub
            
              Indexes_Info=Indexes;
              Temporal_Info=Indexes_Info(:,2);
              Max_Frames=max(Indexes_Info(:,2));
              Tublet_Coor=zeros(200000,2);
              Tublet_Indexes=zeros(1,200000);
              Tublet_Indexes_SPM=zeros(4,200000);
              A1=round(Top_BBX(:,:,itub));
           
            
 
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
            Indexes_Info=Indexes_Info(t,:);
            Col_Index=round(Indexes_Info(:,3));
            Row_Index=round(Indexes_Info(:,4));
            Time_Index=round(Indexes_Info(:,2));
            
%             Traj_Frames=[0; unique(Time_Index)];
             clear Traj_Frames
            Traj_Frames=[min_Tublet_Frames:15:max_Tublet_Frames];
            if Traj_Frames(end)~=max_Tublet_Frames
               
                Traj_Frames=[Traj_Frames max_Tublet_Frames];
               
            end
            
            
            mm_array=ones(1,4);
            mm=1;
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
%                 K=logical(K1);
                Indexes_Info2=Indexes_Info(K,1);
                Col_Index=round(Indexes_Info(K,3));
                Row_Index=round(Indexes_Info(K,4));
                
                spm_cols=round(linspace(col1,col2,3));
                spm_rows=round(linspace(row1,row2,3));
             %SPM_Hist4=cell(1,4);
             ihist=0;
                for icol=1:2
                    for irow=1:2
                   
               c1=Col_Index>=spm_cols(icol);
               c2=Col_Index<=spm_cols(icol+1);
               r1=Row_Index>=spm_rows(irow);
               r2=Row_Index<=spm_rows(irow+1);
               
               cr=logical(c1.*c2.*r1.*r2);  
            
%                Indexes_Info2(cr)';
               
               ihist=ihist+1;
              Tublet_Indexes_SPM( ihist,mm_array(ihist):mm_array(ihist)+length(find(cr))-1) =Indexes_Info2(cr)';
              mm_array(ihist)=mm_array(ihist)+length(find(cr));
               
               
               
                    end
                end
                
             
                
               c1=Col_Index>=col1;
               c2=Col_Index<=col2;
               r1=Row_Index>=row1;
               r2=Row_Index<=row2;
               
               cr=logical(c1.*c2.*r1.*r2);
             
                Tublet_Indexes(mm:mm+length(find(cr))-1) =Indexes_Info2(cr)';
               
                if ~isempty(Col_Index(cr)) && ~isempty(Row_Index(cr))
                
                Tublet_Coor(mm:mm+length(find(cr))-1,:)=[Col_Index(cr) Row_Index(cr)];
                end
                mm=mm+length(find(cr));
                
                clear cr K K1 K2 c1 c2 r1 r2 Indexes_Info2 Col_Index Row_Index B1 col1 col2 row1 row2 t t1 t2
            end
            
          Tublet_Coor=Tublet_Coor(1:mm-1,:);
          Tublet_Indexes=Tublet_Indexes(1:mm-1);
          Tublet_Indexes_SPM1=Tublet_Indexes_SPM(1,1:mm_array(1)-1);
          Tublet_Indexes_SPM2=Tublet_Indexes_SPM(2,1:mm_array(2)-1);
          Tublet_Indexes_SPM3=Tublet_Indexes_SPM(3,1:mm_array(3)-1);
          Tublet_Indexes_SPM4=Tublet_Indexes_SPM(4,1:mm_array(4)-1);

          Tublet_hist=hist(Tublet_Indexes,[1 :2000]);
          Tublet_hist1=hist(Tublet_Indexes_SPM1,[1 :2000]);
          Tublet_hist2=hist(Tublet_Indexes_SPM2,[1 :2000]);
          Tublet_hist3=hist(Tublet_Indexes_SPM3,[1 :2000]);
          Tublet_hist4=hist(Tublet_Indexes_SPM4,[1 :2000]);
          Coor_cell{itub}=Tublet_Coor;
          clear Tublet_Coor;
          All_Histograms_Tublet(itub,:)=[Tublet_hist,Tublet_hist1,Tublet_hist2,Tublet_hist3,Tublet_hist4];
          
 
         clear t1 t2 t
        end
        
        HistFile_Path=[Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
         
       save(HistFile_Path,'All_Histograms_Tublet','Coor_cell'); 
        clear All_Histograms_Tublet
        
        
        
       
  end
     


%% HOG 

clc
clear all
close all

Action_Path_20BBX='.../Data/DatasetName/BBX50MS_DatasetNameData';
Action_Path_Indexes='.../Data/DatasetName/DatasetName_Index_HOG_2000';
Action_Path_ResultBBX='.../Data/DatasetName/DatasetName_Hist_HOG_2000';

if ~exist(Action_Path_ResultBBX,'dir')
    
    mkdir(Action_Path_ResultBBX)
end


 
     
All_Files_BBX=dir(Action_Path_20BBX);
All_Files_BBX=All_Files_BBX(3:end);

     

  
  for ifile=1:1:length(All_Files_BBX)

        
       filePath_BBX_Result=[ Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
 
       filePath_20BBX=[Action_Path_20BBX,'/',All_Files_BBX(ifile).name];
       load(filePath_20BBX);
       
       filePath_Indexes=[Action_Path_Indexes,'/',All_Files_BBX(ifile).name];
       load(filePath_Indexes);
      
       
       
        [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
             
        t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
        Top_BBX=Top_BBX(:,:,t_b_idx1);
        nBBX=length(t_b_idx1);
        
        
        
       All_Histograms_Tublet=zeros(nBBX,5*2000);   
       
        Coor_cell=cell(nBBX,1);
        for itub=1:nBBX
            itub
            
              Indexes_Info=Indexes;
              Temporal_Info=Indexes_Info(:,2);
              Max_Frames=max(Indexes_Info(:,2));
              Tublet_Coor=zeros(200000,2);
              Tublet_Indexes=zeros(1,200000);
              Tublet_Indexes_SPM=zeros(4,200000);
              A1=round(Top_BBX(:,:,itub));
           
            
           % A1=round(Tublets(Tub_act_Ind).CUB);
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
            Indexes_Info=Indexes_Info(t,:);
            Col_Index=round(Indexes_Info(:,3));
            Row_Index=round(Indexes_Info(:,4));
            Time_Index=round(Indexes_Info(:,2));
            
%             Traj_Frames=[0; unique(Time_Index)];
             clear Traj_Frames
            Traj_Frames=[min_Tublet_Frames:15:max_Tublet_Frames];
            if Traj_Frames(end)~=max_Tublet_Frames
               
                Traj_Frames=[Traj_Frames max_Tublet_Frames];
               
            end
            
            
            mm_array=ones(1,4);
            mm=1;
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
%                 K=logical(K1);
                Indexes_Info2=Indexes_Info(K,1);
                Col_Index=round(Indexes_Info(K,3));
                Row_Index=round(Indexes_Info(K,4));
                
                spm_cols=round(linspace(col1,col2,3));
                spm_rows=round(linspace(row1,row2,3));
             %SPM_Hist4=cell(1,4);
             ihist=0;
                for icol=1:2
                    for irow=1:2
                   
               c1=Col_Index>=spm_cols(icol);
               c2=Col_Index<=spm_cols(icol+1);
               r1=Row_Index>=spm_rows(irow);
               r2=Row_Index<=spm_rows(irow+1);
               
               cr=logical(c1.*c2.*r1.*r2);  
            
%                Indexes_Info2(cr)';
               
               ihist=ihist+1;
              Tublet_Indexes_SPM( ihist,mm_array(ihist):mm_array(ihist)+length(find(cr))-1) =Indexes_Info2(cr)';
              mm_array(ihist)=mm_array(ihist)+length(find(cr));
               
               
               
                    end
                end
                
             
                
               c1=Col_Index>=col1;
               c2=Col_Index<=col2;
               r1=Row_Index>=row1;
               r2=Row_Index<=row2;
               
               cr=logical(c1.*c2.*r1.*r2);
             
                Tublet_Indexes(mm:mm+length(find(cr))-1) =Indexes_Info2(cr)';
               
                if ~isempty(Col_Index(cr)) && ~isempty(Row_Index(cr))
                
                Tublet_Coor(mm:mm+length(find(cr))-1,:)=[Col_Index(cr) Row_Index(cr)];
                end
                mm=mm+length(find(cr));
                
                clear cr K K1 K2 c1 c2 r1 r2 Indexes_Info2 Col_Index Row_Index B1 col1 col2 row1 row2 t t1 t2
            end
            
          Tublet_Coor=Tublet_Coor(1:mm-1,:);
          Tublet_Indexes=Tublet_Indexes(1:mm-1);
          Tublet_Indexes_SPM1=Tublet_Indexes_SPM(1,1:mm_array(1)-1);
          Tublet_Indexes_SPM2=Tublet_Indexes_SPM(2,1:mm_array(2)-1);
          Tublet_Indexes_SPM3=Tublet_Indexes_SPM(3,1:mm_array(3)-1);
          Tublet_Indexes_SPM4=Tublet_Indexes_SPM(4,1:mm_array(4)-1);

          Tublet_hist=hist(Tublet_Indexes,[1 :2000]);
          Tublet_hist1=hist(Tublet_Indexes_SPM1,[1 :2000]);
          Tublet_hist2=hist(Tublet_Indexes_SPM2,[1 :2000]);
          Tublet_hist3=hist(Tublet_Indexes_SPM3,[1 :2000]);
          Tublet_hist4=hist(Tublet_Indexes_SPM4,[1 :2000]);
          Coor_cell{itub}=Tublet_Coor;
          clear Tublet_Coor;
          All_Histograms_Tublet(itub,:)=[Tublet_hist,Tublet_hist1,Tublet_hist2,Tublet_hist3,Tublet_hist4];
          
%            if ~any( All_Histograms_Tublet(itub,:))
% 
%              error('waqas')
%            end
         clear t1 t2 t
        end
        
        HistFile_Path=[Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
         
       save(HistFile_Path,'All_Histograms_Tublet','Coor_cell'); 
        clear All_Histograms_Tublet
        
        
        
       
  end

     

     

     
%% MBH 
clc
clear all
close all


Action_Path_20BBX='.../Data/DatasetName/BBX50MS_DatasetNameData';
Action_Path_Indexes='.../Data/DatasetName/DatasetName_Index_MBH_2000';
Action_Path_ResultBBX='.../Data/DatasetName/DatasetName_Hist_MBH_2000';

if ~exist(Action_Path_ResultBBX,'dir')
    
    mkdir(Action_Path_ResultBBX)
end


 
     
All_Files_BBX=dir(Action_Path_20BBX);
All_Files_BBX=All_Files_BBX(3:end);

     

  
  for ifile=1:1:length(All_Files_BBX)

        
       filePath_BBX_Result=[ Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
 
       filePath_20BBX=[Action_Path_20BBX,'/',All_Files_BBX(ifile).name];
       load(filePath_20BBX);
       
       filePath_Indexes=[Action_Path_Indexes,'/',All_Files_BBX(ifile).name];
       load(filePath_Indexes);
      
       
       
        [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
             
        t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
        Top_BBX=Top_BBX(:,:,t_b_idx1);
        nBBX=length(t_b_idx1);
        
        
        
       All_Histograms_Tublet=zeros(nBBX,5*2000);   
       
        Coor_cell=cell(nBBX,1);
        for itub=1:nBBX
            itub
            
              Indexes_Info=Indexes;
              Temporal_Info=Indexes_Info(:,2);
              Max_Frames=max(Indexes_Info(:,2));
              Tublet_Coor=zeros(200000,2);
              Tublet_Indexes=zeros(1,200000);
              Tublet_Indexes_SPM=zeros(4,200000);
              A1=round(Top_BBX(:,:,itub));
           
            
           % A1=round(Tublets(Tub_act_Ind).CUB);
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
            Indexes_Info=Indexes_Info(t,:);
            Col_Index=round(Indexes_Info(:,3));
            Row_Index=round(Indexes_Info(:,4));
            Time_Index=round(Indexes_Info(:,2));
            
%             Traj_Frames=[0; unique(Time_Index)];
             clear Traj_Frames
            Traj_Frames=[min_Tublet_Frames:15:max_Tublet_Frames];
            if Traj_Frames(end)~=max_Tublet_Frames
               
                Traj_Frames=[Traj_Frames max_Tublet_Frames];
               
            end
            
            
            mm_array=ones(1,4);
            mm=1;
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
%                 K=logical(K1);
                Indexes_Info2=Indexes_Info(K,1);
                Col_Index=round(Indexes_Info(K,3));
                Row_Index=round(Indexes_Info(K,4));
                
                spm_cols=round(linspace(col1,col2,3));
                spm_rows=round(linspace(row1,row2,3));
             %SPM_Hist4=cell(1,4);
             ihist=0;
                for icol=1:2
                    for irow=1:2
                   
               c1=Col_Index>=spm_cols(icol);
               c2=Col_Index<=spm_cols(icol+1);
               r1=Row_Index>=spm_rows(irow);
               r2=Row_Index<=spm_rows(irow+1);
               
               cr=logical(c1.*c2.*r1.*r2);  
            
%                Indexes_Info2(cr)';
               
               ihist=ihist+1;
              Tublet_Indexes_SPM( ihist,mm_array(ihist):mm_array(ihist)+length(find(cr))-1) =Indexes_Info2(cr)';
              mm_array(ihist)=mm_array(ihist)+length(find(cr));
               
               
               
                    end
                end
                
             
                
               c1=Col_Index>=col1;
               c2=Col_Index<=col2;
               r1=Row_Index>=row1;
               r2=Row_Index<=row2;
               
               cr=logical(c1.*c2.*r1.*r2);
             
                Tublet_Indexes(mm:mm+length(find(cr))-1) =Indexes_Info2(cr)';
               
                if ~isempty(Col_Index(cr)) && ~isempty(Row_Index(cr))
                
                Tublet_Coor(mm:mm+length(find(cr))-1,:)=[Col_Index(cr) Row_Index(cr)];
                end
                mm=mm+length(find(cr));
                
                clear cr K K1 K2 c1 c2 r1 r2 Indexes_Info2 Col_Index Row_Index B1 col1 col2 row1 row2 t t1 t2
            end
            
          Tublet_Coor=Tublet_Coor(1:mm-1,:);
          Tublet_Indexes=Tublet_Indexes(1:mm-1);
          Tublet_Indexes_SPM1=Tublet_Indexes_SPM(1,1:mm_array(1)-1);
          Tublet_Indexes_SPM2=Tublet_Indexes_SPM(2,1:mm_array(2)-1);
          Tublet_Indexes_SPM3=Tublet_Indexes_SPM(3,1:mm_array(3)-1);
          Tublet_Indexes_SPM4=Tublet_Indexes_SPM(4,1:mm_array(4)-1);

          Tublet_hist=hist(Tublet_Indexes,[1 :2000]);
          Tublet_hist1=hist(Tublet_Indexes_SPM1,[1 :2000]);
          Tublet_hist2=hist(Tublet_Indexes_SPM2,[1 :2000]);
          Tublet_hist3=hist(Tublet_Indexes_SPM3,[1 :2000]);
          Tublet_hist4=hist(Tublet_Indexes_SPM4,[1 :2000]);
          Coor_cell{itub}=Tublet_Coor;
          clear Tublet_Coor;
          All_Histograms_Tublet(itub,:)=[Tublet_hist,Tublet_hist1,Tublet_hist2,Tublet_hist3,Tublet_hist4];
          
 
         clear t1 t2 t
        end
        
        HistFile_Path=[Action_Path_ResultBBX,'/',All_Files_BBX(ifile).name];
         
       save(HistFile_Path,'All_Histograms_Tublet','Coor_cell'); 
        clear All_Histograms_Tublet
   
  end
