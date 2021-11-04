clear;

%====================
data_name = 'Reddit26'; %Dataset name
num_clus = 3; %Number of clusters
%==========
data = load(['data/', data_name, '_data.mat']);
link_struct = data.linkStruct; %Link structure matrix, i.e., B
link_term = data.linkTerm; %Link-word matrix, i.e., C
link_sen = data.linkSen; %(Auxiliary) link-sentence matrix, i.e., S
cont_rel = data.contRel; %Content relation matrix, i.e., V
clear data;

%====================
gnd_path = ['data/', data_name, '_node_gnd.txt']; %Path to save the overlapping ground-truth
res_path = ['buffer/', data_name, '_over.txt']; %Path to save the overlapping community detection result

%====================
link_term = sparse(link_term);
cont_rel = sparse(cont_rel);
%==========
%Initialize link membership matrix X and node membershp matrix Y via NNDSVD
[link_mem_init, node_mem_init] = NNDSVD(link_struct, num_clus, 0);
node_mem_init = node_mem_init';
link_struct = sparse(link_struct);
link_mem_init = sparse(link_mem_init);
node_mem_init = sparse(node_mem_init);
%==========
%Initialize (auxiliary) conent membership matrix Z and sentence discription matrix U via NNDSVD
[cont_mem_init, sen_desc_init] = NNDSVD(link_sen, num_clus, 0);
sen_desc_init = sen_desc_init';
link_sen = sparse(link_sen);
cont_mem_init = sparse(cont_mem_init);
sen_desc_init = sparse(sen_desc_init);
%==========
%Initialize membership transition matrix R
[~, trans_init] = NNDSVD(cont_mem_init, num_clus, 0);
clear cont_mem_init;
trans_init = sparse(trans_init);

%====================
max_iter = 1e4; %Maximum number of iterations
min_err = 1e-6; %Minimum relative error to determine the convergence
%==========
%Test the performance of SLCD with different parameter settings
for alpha = [0.1:0.1:1.0, 2.0:1.0:10.0, 20:10:100]
    for beta = [0.1:0.1:1.0, 2.0:1.0:10.0, 20:10:100]
        tic;
        [link_mem,node_mem,trans,sen_desc,loss] = SLCD(link_struct,link_term,cont_rel,link_mem_init,node_mem_init,trans_init,sen_desc_init,alpha,beta,max_iter,min_err);
        toc;
        runtime = toc;
        %===========
        %Extract the overlapping community membership
        save_over_mem(link_struct, link_mem, res_path);
        %Evaluate the current overlapping community detection result
        [Fsc, Jac] = over_eva(gnd_path, res_path);
        fprintf('Alpha %f Beta %f F-Score %.4f Jaccard %.4f Time %.4f\n', [alpha, beta, Fsc, Jac, runtime]);
        %===========
        fid = fopen(['res/SLCD_demo_', data_name, '.txt'], 'a+');
        fprintf(fid, 'Alpha %f Beta %f F-Score %.4f Jaccard %.4f Time %.4f\n', [alpha, beta, Fsc, Jac, runtime]);
        fclose(fid);
    end
end

%{
%====================
%Demonstration for the random initialization with a given parameter setting
[num_links, num_nodes] = size(link_struct);
[num_sen, num_terms] = size(cont_rel);
link_struct = sparse(link_struct);
link_term = sparse(link_term);
cont_rel = sparse(cont_rel);
%==========
max_iter = 1e4; %Maximum number of iterations
min_err = 1e-6; %Minimum relative error to determine the convergence
alpha = 8;
beta = 0.1;
%==========
num_eva = 10; %Number of independent runs for random initialization
for t=1:num_eva
    %====================
    link_mem_init = rand(num_links, num_clus);
    node_mem_init = rand(num_nodes, num_clus);
    sen_desc_init = rand(num_sen, num_clus);
    trans_init = rand(num_clus, num_clus);
    [link_mem,node_mem,trans,sen_desc,loss] = SLCD(link_struct,link_term,cont_rel,link_mem_init,node_mem_init,trans_init,sen_desc_init,alpha,beta,max_iter,min_err);
    %==========
    save_over_mem(link_struct, link_mem, res_path);
    [Fsc, Jac] = over_eva(gnd_path, res_path);
    fprintf('Alpha %f Beta %f F-Score %.4f Jaccard %.4f Loss %f\n', [alpha, beta, Fsc, Jac, loss]);
end
%}