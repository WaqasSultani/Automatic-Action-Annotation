function [best_sol,best_sol_cost,solution_history,solution_cost_history]=basic_local_search_waqas(netcostmat,NN,prob_type,max_iter)
% [S,BstSolIllus,TabuQL,FreqTS,i,s_history,bbcenters,netCostMatrix]=GMCPTS2_humanTracking(data_pnts_feature,netCostMatrix,NN,MaxIter,MaxTime,MaxRep,BW_MS,Init_method,bbcenters)
                                                                           
n_clusters=size(netcostmat,1)/NN;

%% initialize
%[init_sol,init_sol_cost]=initialize_sol(netcostmat,Init_method,NN,n_clusters,prob_type,BW_MS,data_pnts_feature);
best_sol=[1:NN:size(netcostmat,1)];
netcostmat2=netcostmat(best_sol,:);
netcostmat3=netcostmat2(:,best_sol);
% Trac=tril(ones(size(netcostmat3,1),size(netcostmat3,2)),-1);
%  netcostmat4=netcostmat3.*Trac;
best_sol_cost=sum(sum(netcostmat3)); 

solution_history=[];
solution_cost_history=[];
rep_costs=0;


%%
consumed_time=tic;
for i=1:max_iter

    neighbor_sols=generate_neighbors(best_sol,NN,n_clusters);

    neighbor_sols_cost=calc_neighbor_cost(neighbor_sols,prob_type,netcostmat);

    [best_sol,best_sol_cost,rep_costs]=pick_best_sol(neighbor_sols,neighbor_sols_cost,best_sol,best_sol_cost,rep_costs);
    
    solution_history=[solution_history; best_sol];
    solution_cost_history=[solution_cost_history; best_sol_cost];
    
    display(['Iteration ' num2str(i)]);
    display(['Best Solution Cost ' num2str(best_sol_cost)]);
   
    if rep_costs==0    
        display('Better Solution Found');
    end
% rep_costs;
%     if (toc(consumed_time)>max_time)||(rep_costs>max_rep)
%         break;               
%     end

    

end


end




%% intialization function

function [INIT,init_sol_cost]=initialize_sol(netcostmat,Init_method,NN,n_clusters,prob_type,BW_MS,data_pnts_feature)

sum1=sum(netcostmat,2);

sum2=reshape(sum1,[NN n_clusters]);

[~, mI]=min(sum2);

IPI=0:NN:((n_clusters-1)*NN);

if strcmp(Init_method,'MinS')  
    INIT=IPI+mI;
    
elseif strcmp(Init_method,'Rand')   
    INIT=IPI + [floor(rand(1,n_clusters)*(NN-0.0001))]+1;
    
elseif strcmp(Init_method,'First') 
    INIT=IPI+ones(1,n_clusters);
    
elseif strcmp(Init_method,'Clus') 
    
    INIT=Clust_init(data_pnts_feature,BW_MS,NN);
    
end

init_sol_cost=calc_sol_cost(INIT,netcostmat,prob_type);

end


%% calculates the cost of a solution

function sol_cost=calc_sol_cost(sol,netcostmat,prob_type)

if strcmp(prob_type,'GMCP')
            
    netcostmat2=netcostmat(sol,:);
    
    netcostmat3=netcostmat2(:,sol);   
%     Trac=tril(ones(size(netcostmat3,1),size(netcostmat3,2)),-1);
%     netcostmat4=netcostmat3.*Trac;
   
    sol_cost=sum(sum(netcostmat3));    
    
elseif strcmp(prob_type,'GMST')
         
    netcostmat2=netcostmat(sol,:);
    
    netcostmat3=netcostmat2(:,sol);    
   
    sol_cost=full(sum(sum(graphminspantree(tril(sparse(double(netcostmat3+1))),'Method', 'Kruskal'))));
 
end


end


%% generate the neighboring solutions to the current solution best_sol

function neighbor_sols=generate_neighbors(best_sol,NN,n_clusters)

Nbrs=repmat(best_sol,[n_clusters*NN 1]);

for i=1:n_clusters
    
    Nbrs(((i-1)*NN+1):(i*NN),i)=[((i-1)*NN+1):((i*NN))]';
    
end

repeated_best_sol_ind=ismember(Nbrs, best_sol, 'rows');

neighbor_sols=removerows(Nbrs,'ind',find(repeated_best_sol_ind));

end



%% calculated the cost of each neighboring solution

function neighbor_sols_cost=calc_neighbor_cost(neighbor_sols,prob_type,netcostmat)
if  strcmp(prob_type,'GMST')    
    parfor i=1:size(neighbor_sols,1)


        neighbor_sols_cost(i)=calc_sol_cost(neighbor_sols(i,:),netcostmat,prob_type);

    end
end


if  strcmp(prob_type,'GMCP')    
    for i=1:size(neighbor_sols,1)


        neighbor_sols_cost(i)=calc_sol_cost(neighbor_sols(i,:),netcostmat,prob_type);

    end
end

end



%% finds the best solution among neighbors and updates best sol if a better solution is found

function [best_sol,best_sol_cost,rep_costs]=pick_best_sol(neighbor_sols,neighbor_sols_cost,best_sol,best_sol_cost,rep_costs)

if max(neighbor_sols_cost)>best_sol_cost
   
    [best_sol_cost indx]=max(neighbor_sols_cost);
    best_sol=neighbor_sols(indx,:);
    rep_costs=0;
        
else

    rep_costs=rep_costs+1;
    
end


end
