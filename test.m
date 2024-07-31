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
    for i = 1 : 2
    chrom = generateRandomChromosome();
    [chrom, ~] = calculateFitness3D(chrom, false);
    confs = decodeIndividual(chrom);
    drawProblem3D(confs)

    end
end