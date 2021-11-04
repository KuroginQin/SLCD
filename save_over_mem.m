function save_over_mem(link_struct, link_mem, res_path)
%Function to extract and save overlapping community membership
%link_struct: optimized link structure matrix, i.e., B
%link_mem: link membership matrix, i.e., X
%res_path: path to save the overlapping community detection result

    %====================
    %Extract the overlapping community detection result
    [num_links, num_clus] = size(link_mem); %Get the number of links (edges) and clusters
    [~, num_nodes] = size(link_struct); %Get the number of nodes
    %==========
    over_mem = cell(num_clus, 1); %Initialize the overlapping community membership
    for c=1:num_clus
        over_mem{c} = [];
    end
    [~, link_labels] = max(link_mem, [], 2); %Get the disjoint link (community) labels
    %Transform the disjoint link labels to overlapping node labels
    for i=1:num_links
        l = link_labels(i);
        for j=1:num_nodes
            if link_struct(i, j)>0
                over_mem{l} = [over_mem{l}, j];
            end
        end
    end
    for l=1:num_clus
        over_mem{l} = unique(over_mem{l}); %Ensure that there are no duplicate node members in each community
    end
    
    %====================
    %Save the overlapping community detection result
    fid = fopen(res_path, 'w+');
    for c=1:num_clus
        for i=1:length(over_mem{c})
            fprintf(fid, '%d ', over_mem{c}(i)-1);
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
end

