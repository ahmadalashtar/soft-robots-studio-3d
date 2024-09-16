function [cMass] = bigCrunchPhase(pop,fit_array)
    global eas;
    global op;

    switch eas.bbbc.crunchMethod 
        case 'fittest' % taking the fittest as the center of mass (first equation for center of mass on the paper)
            cMass = pop(:,:,fit_array(1,10)); 
            
        case 'com' %calculating the center of mass according to the formula on the paper (second equation for center of mass on the paper)
            n_targets = size(op.targets,1);
            sumFit_mat = zeros(n_targets*2+1,op.n_links+eas.extra_genes);
            sumFit = 0.0;

            for i=1:1:eas.n_individuals
                for j=1:1:n_targets*2+1
                    for k=1:1:op.n_links 
                        sumFit_mat(j,k) = sumFit_mat(j,k) + (1/fit_array(i,6))*pop(j,k,fit_array(i,10));
                    end
                end
            
                sumFit = sumFit + (1/fit_array(i,6));
        
            end

            for j=1:1:n_targets*2+1
                for k=1:1:op.n_links 
                    sumFit_mat(j,k) = sumFit_mat(j,k) / sumFit;
                end
            end
            cMass = sumFit_mat;
            
        case 'fittest+com'
            %%to be continued


    end
    
