% This fixes an angle.
% Makes sure that the angle is between 180 and -179, if not, I transform it in that range.
%
% INPUT:
% 'a' is the angle to be fixed (in degrees)
%
% OUTPUT:
% 'angle' is the fixed angle (in degrees)
function test()
disp('hello')
global op;
    for i = 1 : 50
    chrom = generateRandomChromosome();
    [chrom, fitness] = calculateFitness3D(chrom, false);
    if fitness(4)~= 0
        disp(chrom);
        confs = decodeIndividual(chrom);
        drawProblem3D(confs(:,:,1))
        % drawProblem3D(confs(:,:,2))
        disp('')
    end
    % confs = decodeIndividual(chrom)
    % drawProblem3D(confs(:,:,1))
    end
end