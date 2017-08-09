clc
clear all
close all
All_Unary='../Data/UCFSports/For_Unary';
AllShape_Path='../Data/UCFSports/ShapeSimilarity';
All_BOW_Matrixes_Path='../Data/UCFSports/Distance_Matrices_Chi';
All_BOW_Matrixes_Zero_Indx_Path='../Data/UCFSports/Distance_Matrices_Chi_zero_idx';

All_Distance_Matrixes_hung='../Data/UCFSports/UCFSports_Similarity_Hung';
AllLocation_Path='../Data/UCFSports/LocationSimilarity';


AllBBX_Path='../Data/UCFSports/BBX50MS';


All_Actions=dir(AllShape_Path);
All_Actions=All_Actions(3:end);

GMCP_Result=[];

for iAction=1:10
         
         Shape_Path=[AllShape_Path,'/', All_Actions(iAction).name];
         BOW_Matrixes=[All_BOW_Matrixes_Path,'/',All_Actions(iAction).name]; 
         Zero_BOW_Index=[All_BOW_Matrixes_Zero_Indx_Path,'/',All_Actions(iAction).name]; 
         
         Hung_Matrixes =[All_Distance_Matrixes_hung,'/',All_Actions(iAction).name]; 
         UnaryPath=[All_Unary,'/', All_Actions(iAction).name(1:end-4)];
         LocationPath=[AllLocation_Path,'/',All_Actions(iAction).name];   

         
         
         
         
         All_Files=dir(UnaryPath);
         All_Files=All_Files(3:end);
         
         Unary_A=[];
         
         for ifile=1:length(All_Files)
             
             
              U_file=[UnaryPath,'/',All_Files(ifile).name];
              load(U_file)
              [t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
              t_b_score=t_b_score(1:min(100,length(t_b_idx)));
              temp_score= t_b_score/max(t_b_score);
              
              Unary_A=[Unary_A;temp_score];
              
              
              if length(temp_score)<100
                 
                   nn=length(Unary_A);
                   temp_n=length(temp_score);
                  for mm=1:(100-temp_n)
                      nn=nn+1
                    Unary_A(nn)=temp_score(1);
                      
                      
                      
                  end
                   
                  

         	  end 

  
                  
              end
              
         
         
         load(Shape_Path);
         load(LocationPath);
         load(Hung_Matrixes);
         load(BOW_Matrixes);
         load(Zero_BOW_Index)
         
         
%          All_Files_BBX=dir(Shape_Path);
%          All_Files_BBX=All_Files_BBX(3:end);
% 
%          Hung_Path=[Distance_Matrixes_hung,'/',All_Action_hung(iAction).name];
%          load(Hung_Path);
%          
%          hogpath=[Distance_Matrixes_Action,'/HOG_Data'];
%          load(hogpath); 
%           
%          mbhpath=[Distance_Matrixes_Action,'/MBH_Data'];
%          load(mbhpath); 
%           
%          hofpath=[Distance_Matrixes_Action,'/HOF_Data'];
%          load(hofpath);
%                   
%          trajpath=[Distance_Matrixes_Action,'/Traj_Data'];
%          load(trajpath);        
%           
%          unarypath=[Distance_Matrixes_Action,'/Unary_Data'];
%          load(unarypath);
% 
%          shapepath=[Distance_Matrixes_Action,'/Shape_Data'];
%          load(shapepath);
%  
%           AA=Tublet_Area_Conf;
%           a=AA>0;
%           AA=AA.*a;
%           Tublet_Area_Conf=exp(-.2*AA);
%           Distri_Matrix=Tublet_Area_Conf*Tublet_Area_Conf';
%           Distri_Matrix=nan2zeros(Distri_Matrix);
%           %imagesc(Distri_Matrix)
%                     
%           Shape_dist=(1-P_shape/max(P_shape(:)));
%           Shape_dist=nan2zeros(Shape_dist);
%           Area_dist=(1-A_shape/max(A_shape(:)));
%            Unary_A=Unary;
%            Unary_A=Unary_A';
%            Unary_A=Unary_A(:)';
% %            Unary_Mat=repmat(Unary_A',[ size(Unary_A,1),1]);
% %            
%           
%            
%             param.gamma=0.7;
%         
%             temp=XCHI_MBH;
%             temp(temp>2.4900e+05)=[];
%             max_XCHI_MBH=max(temp(:));
%               
%             temp=XCHI_HOG;
%             temp(temp>2.4900e+05)=[];
%             max_XCHI_HOG=max(temp(:));
%             
%             
%             temp=XCHI_HOF;
%             temp(temp>2.4900e+05)=[];
%             max_XCHI_HOF=max(temp(:));
%             
%             
%             temp=XCHI_Traj;
%             temp(temp>2.4900e+05)=[];
%             max_XCHI_Traj=max(temp(:));
%             
%             XCHI_MBH=XCHI_MBH/max_XCHI_MBH;
%             XCHI_HOF=XCHI_HOF/max_XCHI_HOF;
%             XCHI_HOG=XCHI_HOG/max_XCHI_HOG;
%             XCHI_Traj=XCHI_Traj/max_XCHI_Traj;
%             
%             Xchi1 = exp(-param.gamma * XCHI_MBH);
%             Xchi2 = exp(-param.gamma * XCHI_HOF);
%             Xchi3 = exp(-param.gamma * XCHI_HOG);
%             Xchi4 = exp(-param.gamma * XCHI_Traj);
%             Com1= Distri_Matrix;
%             %Shape_dist;%.*imagesc(Com1)
        
             %%  C3D
%             
%              cnn_param=1;
%              CNN_f1 = exp(-cnn_param *CNN_Pairwise);
%              
%              temp=CNN_f1;
%              temp(temp>999)=[];
%              max_CNN_f1=max(temp(:));
%              
%              Sim_CNN=CNN_f1/max_CNN_f1;
%             
  %% BOW Matrices
  
  
             HOF_XCHI=HOF_XCHI+triu(HOF_XCHI,1)';
             HOG_XCHI=HOG_XCHI+triu(HOG_XCHI,1)';
             MBH_XCHI=MBH_XCHI+triu(MBH_XCHI,1)';
             Traj_XCHI=Traj_XCHI+triu(Traj_XCHI,1)';
  
            
             param.gamma=.01;
            
             Xchi_mbh  = exp(-param.gamma * MBH_XCHI);
             Xchi_hof  = exp(-param.gamma * HOF_XCHI);
             Xchi_hog  = exp(-param.gamma * HOG_XCHI);
             Xchi_traj = exp(-param.gamma * Traj_XCHI);
  
   
            temp=Xchi_mbh;
            temp(temp>1000)=[];
            max_Xchi_mbh=max(temp(:));
              
            temp=Xchi_hog;
            temp(temp>1000)=[];
            max_Xchi_hog=max(temp(:));
            
            
            temp=Xchi_hof;
            temp(temp>1000)=[];
            max_Xchi_hof=max(temp(:));
            
            
            temp= Xchi_traj;
            temp(temp>1000)=[];
            max_Xchi_traj=max(temp(:));
            
            Xchi_mbh=Xchi_mbh/max_Xchi_mbh;
            Xchi_hof=Xchi_hof/max_Xchi_hof;
            Xchi_hog=Xchi_hog/max_Xchi_hog;
            Xchi_traj=Xchi_traj/max_Xchi_traj;
            
            Xchi_mbh(Zero_Idx_MBH,:)=0;
            Xchi_mbh(:,Zero_Idx_MBH)=0;
            
            Xchi_hof(Zero_Idx_HOF,:)=0;
            Xchi_hof(:,Zero_Idx_Traj)=0;
            
            Xchi_hog(Zero_Idx_HOG,:)=0;
            Xchi_hog(:,Zero_Idx_Traj)=0;
            
            Xchi_traj(Zero_Idx_Traj,:)=0;
            Xchi_traj(:,Zero_Idx_Traj)=0;
            
            
            
            Sim_dtf=(0*Xchi_hof+Xchi_hog+Xchi_traj+0*Xchi_mbh )*0.5;
            % Sim_hung= (0*hung2+hung3+hung1+0*hung1)*0.5;
  

            %%  Hung
                        
             HungHOF=Dist_Mat_HOF;
             HungHOG=Dist_Mat_HOG;
             HungMBH=Dist_Mat_MBH;
             HungTraj=Dist_Mat_Traj;
             HungHOF=HungHOF+triu(HungHOF,1)';
             HungHOG=HungHOG+triu(HungHOG,1)';
             HungMBH=HungMBH+triu(HungMBH,1)';
             HungTraj=HungTraj+triu(HungTraj,1)';
             HungMBH=Inf2thousands(HungMBH);
             HungHOF=Inf2thousands(HungHOF);
             HungHOG=Inf2thousands(HungHOG);
             HungTraj=Inf2thousands(HungTraj);
             
             hung_param=1;
             
            hung1 = exp(-hung_param * HungMBH);
            hung2 = exp(-hung_param * HungHOF);
            hung3 = exp(-hung_param * HungHOG);
            hung4 = exp(-hung_param * HungTraj);
             
             temp=hung1;
             temp(temp>999)=[];
             max_hung1=max(temp(:));
             
             temp=hung2;
             temp(temp>999)=[];
             max_hung2=max(temp(:));
          
             temp=hung3;
             temp(temp>999)=[];
             max_hung3=max(temp(:));
             
             temp=hung4;
             temp(temp>999)=[];
             max_hung4=max(temp(:));
             
             hung1=hung1/max_hung1;
             hung2=hung2/max_hung2;
             hung3=hung3/max_hung3;
             hung4=hung4/max_hung4;
             Sim_hung= (0*hung2+hung3+hung1+0*hung1)*0.5;
              %;  

             
            %% Shape 
             
             Dist_BBX=Dist_BBX+triu(Dist_BBX,1)';
             sh_param=1;
             
             shape1 = exp(-sh_param *Dist_BBX);
             
             temp=shape1;
             temp(temp>999)=[];
             max_shape1=max(temp(:));
             
             Sim_Shape=shape1/max_shape1;
             
             
             %% Location
  
             
             
             %Gauss_BBX=Gauss_BBX+triu(Gauss_BBX,1)';
             
             Gauss_BBX=Loc_Prior;
             
             Com2=(1*Sim_dtf+Sim_Shape+0*Sim_hung).*Length_Prior;
            
%              Com2=(Sim_dtf+0*Sim_hung).* Length_Prior;%.*Loc_Prior;

             
            
            Kernal_DB=zeros(length(Unary_A),length(Unary_A));
            
            
            for ii=1:1:length(Unary_A)
                
                for jj=ii:1:length(Unary_A)
                    
                    
                  Kernal_DB(ii,jj)=  Unary_A(ii)+Unary_A(jj);
                  Kernal_DB(jj,ii)=Kernal_DB(ii,jj);
                    
                end
            end

            Kernal_DB=Kernal_DB/2;
            
            best_sol=[1:100:size(Com2,1)]; 
            bb=[1:100:size(Com2,1)]; 
            NN=length(best_sol);
            n_clusters=size(Com2,1)/NN; 
             
            Solution_track=zeros(1,NN);
            Index_track=[];
            
            U_W=0.07;
            B_W=1;
            
            
            Binary_cost=Com2;
                 
            Binary_cost=B_W*Binary_cost.*(1-diag([ones(1,length(Binary_cost))]));
            Unary_cost= Kernal_DB;
            Unary_cost=U_W*Unary_cost;
            Total_cost=Unary_cost+Binary_cost;
           
            NN=100;
          MaxIter=25;
          MaxRep=4
          MaxTime=50;

      [solution_GMCP1,best_sol_cost1,~,~]=basic_local_search_waqas(Total_cost,NN,'GMCP',MaxIter); 
    
      baseline=[0:100:size(Total_cost,1)-1]; 
     GMCP_Result=[GMCP_Result, solution_GMCP1-baseline]

     
end
save('GMCP_UCFSports','GMCP_Result')

