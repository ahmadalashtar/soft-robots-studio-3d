%--------------BLX-ALPHA CROSSOVER--------------

function [child] = blendCrossover(p1, p2, alpha)
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    
    n_targets = floor(size(p1,1)-1)/2;
    child = zeros(n_targets*2+1,op.n_links+eas.extra_genes); % newly generated offspring
    ll_index = n_targets*2+1;    % row-index for link length in chromosomes
    
    %angles (targets x nodes+4)
    for i=1:1:n_targets*2
        for j=1:1:op.n_links
            if j==1
                if op.first_angle.is_fixed == false
                    child(i,j) = blendValues(p1(i,j),p2(i,j),alpha,[-179,180],false);
                else                    
                    child(i,j) = op.first_angle.angle; 
                end
            else                
                child(i,j) = blendValues(p1(i,j),p2(i,j),alpha,op.angle_domain,false);
            end
        end
    end
    
    %lengths (+1 x nodes) last 4 is empty
    for j=1:1:op.n_links
        child(ll_index,j) = blendValues(p1(ll_index,j),p2(ll_index,j),alpha,op.length_domain,false);
    end
end
