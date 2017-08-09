clc
clear all
close all
All_Unary='../Data/DatasetName/BBX50MS_DatasetName';
AllShape_Path='../Data/DatasetName/ShapeSimilarity';
All_BOW_Matrixes_Path='../Data/DatasetName/Distance_Matrices_Chi';
All_Distance_Matrixes_hung='../DatasetName/DatasetName_Similarity_Hung_6';
AllLocation_Path='../Data/DatasetName/LocationSimilarity';
AllBBX_Path='../Data/DatasetName/BBX50MS_DatasetName';

All_Actions=dir(AllShape_Path);
All_Actions=All_Actions(3:end);

for iAction=1:length(All_Actions)

 
              Unary_Weight=0.07;
              Binary_Weight=1;
              Num_Top_Prop=100;
    
              %% Please load here the computed similarity matrices.
              
              Binary_cost=(ShapeSimilarity+Distance_Matrices+Similarity_Hung).*Length_Prior;

              NN=100;
              MaxIter=25;
              MaxRep=4;
              MaxTime=50;

              Total_cost=Unary_Weight*Unary_cost+Binary_Weight*Binary_cost;
              [solution_GMCP1,best_sol_cost1,~,~]=basic_local_search_waqas(Total_cost,NN,'GMCP',MaxIter); 
    
               baseline_idx=[0:Num_Top_Prop:size(Binary_cost,1)-1]; 
               GMCP_Result=[GMCP_Result, solution_GMCP1-baseline_idx]
               
               %% GMCP_Result contain results all videos of the same action.
                %Consider the original proposals as follows
                %[t_b_score,t_b_idx]=sort(Top_BBX_Scores,'descend');
                %t_b_idx1=t_b_idx(1:min(Num_Top_Prop,length( t_b_idx)));
                %Top_BBX=Top_BBX(:,:,t_b_idx1);
               
                %% For example if GMCP(1)=10. It means in first video of the action, the annotation=Top_BBX(:,:,10);
                %% Similarly, if GMCP(11)=23. It means in 11th video of the action, the annotation=Top_BBX(:,:,23);
                
               save('GMCP_Results','GMCP_Result')
end
