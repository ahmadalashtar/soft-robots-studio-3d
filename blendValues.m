function [gene_cX, gene_cY] = blendValues(gene_p1X, gene_p2X, gene_p1Y, gene_p2Y, alpha, bounds, isInteger)
    if gene_p1X < gene_p2X
        minGeneX = gene_p1X;
        maxGeneX = gene_p2X;
    else
        minGeneX = gene_p2X;
        maxGeneX = gene_p1X;
    end
    if gene_p1Y < gene_p2Y
        minGeneY = gene_p1Y;
        maxGeneY = gene_p2Y;
    else
        minGeneY = gene_p2Y;
        maxGeneY = gene_p1Y;
    end
    u = rand();
    gamma = (1+2*alpha)*u-alpha;

    gene_cX = (1-gamma)*minGeneX + gamma*maxGeneX;
    gene_cX = max(min(bounds(2),gene_cX),bounds(1));

    gene_cY = (1-gamma)*minGeneY + gamma*maxGeneY;
    gene_cY = max(min(bounds(2),gene_cY),bounds(1));
    
    % if the gene is an integer number, transform it
    if isInteger==true
        gene_cX = nearest(gene_cX);
        gene_cY = nearest(gene_cY);
    end    
end