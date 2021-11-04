function [link_mem,node_mem,trans,sen_desc,loss] = SLCD(link_struct,link_term,cont_rel,link_mem,node_mem,trans,sen_desc,alpha,beta,max_iter,min_err)
%Function to implement the SLCD method
%link_struct: link structure matrix, i.e., B
%link_term: link-word matrix, i.e., C
%cont_rel: content relation matrix, i.e., V
%link_mem: link membership matrix, i.e., X
%node_mem: node membership matrix, i.e., Y
%trans: membership transition matrix, i.e., R
%sen_desc: sentence description matrix, i.e., U
%alpha, beta: hyper-parameters
%max_iter: maximum number of iterations
%min_err: minimum relative error to determine the convergence
%loss: converged loss value

    %====================
    [num_edges, num_nodes] = size(link_struct); %Get the number of edges and nodes
    [~, num_terms] = size(link_term); %Get number of words (terms)
    [~, num_topo_clus] = size(link_mem); %Get number of topology clusters
    [num_sen, num_cont_clus] = size(sen_desc); %Get number of sentences & content clusters
    
    %====================
    %Compute the loss function
    loss = norm(link_struct - link_mem*node_mem', 'fro')^2;
    loss = loss + alpha*norm(link_term - link_mem*trans*sen_desc'*cont_rel, 'fro')^2;
    loss = loss + beta*norm(ones(1,num_sen)*sen_desc, 'fro')^2;
    %==========
    iter_cnt = 0; %Iteration counter
    error = 0; %Relative error of current loss fucntion
    epsilon = 1e-6;
    while iter_cnt==0 || (error>=min_err && iter_cnt<=max_iter)
        pre_loss = loss; %Loss function of previous iteraton
        %==========
        %X-Step: update the Link Membership Matrix
        aux = trans*sen_desc'*cont_rel;
        numer = link_struct*node_mem + alpha*link_term*aux';
        denom = link_mem*(node_mem'*node_mem + alpha*aux*aux');
        link_mem = link_mem.*(numer./max(denom, epsilon));
        %==========
        %Y-Step: update the Node Membership Matrix
        numer = link_struct'*link_mem;
        denom = node_mem*(link_mem'*link_mem);
        node_mem = node_mem.*(numer./max(denom, epsilon));
        %==========
        %R-Step: update the Transition Matrix
        aux = sen_desc'*cont_rel;
        numer = link_mem'*link_term*aux';
        denom = (link_mem'*link_mem)*trans*(aux*aux');
        trans = trans.*(numer./max(denom, epsilon));
        %==========
        %U-Step: update the Sentence Description Matrix
        aux = link_mem*trans;
        numer = alpha*cont_rel*link_term'*aux;
        denom = alpha*(cont_rel*cont_rel')*sen_desc*(aux'*aux) + beta*ones(num_sen, num_sen)*sen_desc;
        sen_desc = sen_desc.*(numer./max(denom, epsilon));
        %====================
        iter_cnt = iter_cnt+1;
        %=========
        %Compute the loss function
        loss = norm(link_struct - link_mem*node_mem', 'fro')^2;
        loss = loss + alpha*norm(link_term - link_mem*trans*sen_desc'*cont_rel, 'fro')^2;
        loss = loss + beta*norm(ones(1,num_sen)*sen_desc, 'fro')^2;
        %==========
        %Compute the relative error of the current loss fucntion
        error = abs(loss-pre_loss)/pre_loss;
        %fprintf('#%d; Obj. Value %8.4f; Error: %8.8f\n', [iter_cnt, loss, error]);
    end
    
end
