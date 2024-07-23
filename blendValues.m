function [gene_c] = blendValues(gene_p1, gene_p2, alpha, bounds, isInteger)
    if gene_p1 < gene_p2
        minGene = gene_p1;
        maxGene = gene_p2;
    else
        minGene = gene_p2;
        maxGene = gene_p1;
    end
    u = rand();
    gamma = (1+2*alpha)*u-alpha;
    gene_c = (1-gamma)*minGene + gamma*maxGene;
    gene_c = max(min(bounds(2),gene_c),bounds(1));
    
    % if the gene is an integer number, transform it
    if isInteger==true
        gene_c = nearest(gene_c);
    end    
end